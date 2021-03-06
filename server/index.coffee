express = require('express')
ex = express()
fs = require('fs')
teamData = require('./teamvalue.coffee')

#(Allow Cross Origin Reference - Potentially important for iOS app)
ex.use( (req, res, next) ->
  res.header("Access-Control-Allow-Origin", "*")
  res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept")
  next()
)

# READING THE DATABASE
getItems = (req) ->
  return switch
    when req.team then readDb("team", req.team, null)
    when req.competition then readDb("competition", null, req.competition)
    else readDb()

readDb = (url = "all", team, comp) ->
  gdata = JSON.parse(fs.readFileSync("#{__dirname}/db.json", 'utf8', (err, data) -> if err then console.log(err)))
  return switch url
    when "team" then dbTeam(gdata, team)
    when "competition" then dbComp(gdata, comp)
    when "all" then gdata
    else "Error"

dbTeam = (data, team="all") ->
  if team isnt "all" then data = cleanDbData(data, team)
  dt = data.teams
  if team is "all" then return dt
  else if dt["#{team}"].teamName is "No Record" and !dt["#{team}"].scout? then return({bad_team: team})
  else return dt["#{team}"]

dbComp = (data, comp="all") ->
  dc = data.competitions["#{comp}"]
  if comp is "all" then return data.competitions
  else return dc

ex.get('/read', (req, res) ->
  res.end(JSON.stringify(getItems(req.query)))
  return
)

# (Perhaps a little bit less complicated on non-http platforms)
ex.get('/read2/:type/:spec', (req, res) ->
  res.end(JSON.stringify(
    switch req.params.type
      when "team" then readDb("team", req.params.spec)
      when "comp" then readDb("competition", null, req.params.spec)
  ))
)

# WRITING TO THE DATABASE
cleanDbData = (data, team) ->
  if !data.teams[team]? then data.teams[team] = {}

  if !data.teams[team].teamName? then data.teams[team].teamName = "No Record"
  if !data.teams[team].teamHome? then data.teams[team].teamHome = "No Record"
  if !data.teams[team].teamNumber? then data.teams[team].teamNumber = team
  if !data.teams[team].teamColour? then data.teams[team].teamColour = "#ffffff"
  if !data.teams[team].teamRecord? then data.teams[team].teamRecord = {win: 0, loss: 0, tie: 0}

  if !data.teams[team].scout? then data.teams[team].scout = {}

  if !data.teams[team].scout.pit? then data.teams[team].scout.pit = {}
  if !data.teams[team].scout.game? then data.teams[team].scout.game = []

  return data

writeDb = (data) ->
  options = data.chosenOptions
  team = data.sTeamNumber

  dbData = JSON.parse(fs.readFileSync("#{__dirname}/db.json", 'utf8', (err, data) -> if err then console.log(err)))
  dbData = cleanDbData(dbData, team)

  for option in Object.keys(options)
    dbData.teams[team].scout.pit[option] = options[option]

  return saveData(dbData)

editDb = (data) ->
  val = data.value
  itm = data.element
  team = data.teamNumber

  dbData = JSON.parse(fs.readFileSync("#{__dirname}/db.json", 'utf8', (err, data) -> if err then console.log(err)))
  dbData = cleanDbData(dbData, team)

  dbData.teams[team].scout.pit[itm] = val

  saveData(dbData)

saveData = (data) ->
  if !fs.writeFileSync("#{__dirname}/db.json", JSON.stringify(data))? then return {success: true}

ex.get('/write', (req, res) ->
  if req.query.e? then res.end(JSON.stringify(editDb(JSON.parse(req.query.q))))
  else res.end(JSON.stringify(writeDb(JSON.parse(req.query.q))))
)

ex.post('/write', (req, res) ->
  if req.query.e? then res.end(JSON.stringify(editDb(JSON.parse(req.query.q))))
  else res.end(JSON.stringify(writeDb(JSON.parse(req.query.q))))
)

##WRITE A GAME ENTRY
addGameElement = (team, entry) ->
  gdata = JSON.parse(fs.readFileSync("#{__dirname}/db.json", 'utf8', (err, data) -> if err then console.log(err)))

  if !gdata.teams[team]? then gdata.teams[team] = {"scout":"pit":{}, "game": []}
  if !gdata.teams[team].scout? then gdata.teams[team].scout = {"pit": {}, "game": []}
  if !gdata.teams[team].scout.game? then gdata.teams[team].scout.game = []

  gdata.teams[team].scout.game.push(entry)

  fs.writeFileSync("#{__dirname}/db.json", JSON.stringify(gdata))
  return JSON.stringify({"team": team, "entry": entry})

ex.get('/writeg', (req, res) ->
  res.end(addGameElement(req.query.team, req.query.words))
)

##"DELETE" AN ENTRY
psDelDb = (d) ->
  r = JSON.parse(fs.readFileSync("#{__dirname}/db.json", 'utf8', (err, data) -> if err then console.log(err)))

  if d.type is "comp"
    # hideComp(d.r0)
  else if d.type is "team"
    if d.r1?
      if d.r2?
        if d.r3?
          r.teams[d.r0][d.r1][d.r2][d.r3] = {del: r.teams[d.r0][d.r1][d.r2][d.r3]}
        else r.teams[d.r0][d.r1][d.r2].hidden = true
      else r.teams[d.r0][d.r1].hidden = true
    else r.teams[d.r0].hidden = true

  return saveData(r)

ex.delete('/rm/:type/:r0/:r1?/:r2?/:r3?', (req, res) ->
  res.end(JSON.stringify(psDelDb(req.params)))
)

##Values of a Team (Individual)
ex.get('/value/:team/:values?/:ignore?', (req, res) ->
  if req.params.values? or req.params.values is {} then x = req.params.values else x = null
  if req.params.ignore? then y = req.params.ignore.split(",") else y = null
  res.end(JSON.stringify(teamData.indVal(req.params.team, x, y)))
)

##Compare two teams against eachother
ex.get('/compare/:team1/:team2/:values?/:ignore?', (req, res) ->
  if req.params.values? or req.params.values is {} then x = req.params.values else x = null
  if req.params.ignore? then y = req.params.ignore.split(",") else y = null
  res.end(JSON.stringify(teamData.compareTeams(req.params.team1, req.params.team2, x, y)))
)

server = ex.listen(8081, () ->
  host = server.address().address
  port = server.address().port
  console.log("Server Online~ [#{host}:#{port}]")
)
