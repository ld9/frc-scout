// Generated by CoffeeScript 1.12.1
(function() {
  var cleanDbData, dbComp, dbTeam, editDb, ex, express, fs, getItems, readDb, saveData, server, writeDb;

  express = require('express');

  ex = express();

  fs = require('fs');

  ex.use(function(req, res, next) {
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
    return next();
  });

  getItems = function(req) {
    switch (false) {
      case !req.team:
        return readDb("team", req.team, null);
      case !req.competition:
        return readDb("competition", null, req.competition);
      default:
        return readDb();
    }
  };

  readDb = function(url, team, comp) {
    var gdata;
    if (url == null) {
      url = "all";
    }
    gdata = JSON.parse(fs.readFileSync(__dirname + "/db.json", 'utf8', function(err, data) {
      if (err) {
        return console.log(err);
      }
    }));
    switch (url) {
      case "team":
        return dbTeam(gdata, team);
      case "competition":
        return dbComp(gdata, comp);
      case "all":
        return gdata;
      default:
        return "Error";
    }
  };

  dbTeam = function(data, team) {
    if (team == null) {
      team = "all";
    }
    if (team !== "all") {
      data = cleanDbData(data, team);
    }
    if (team === "all") {
      return data.teams;
    } else if (data.teams["" + team].teamName === "No Record") {
      return {
        bad_team: team
      };
    } else {
      return data.teams["" + team];
    }
  };

  dbComp = function(data, comp) {
    if (comp == null) {
      comp = "all";
    }
    if (comp === "all") {
      return data.competitions;
    } else {
      return data.competitions["" + comp];
    }
  };

  ex.get('/read', function(req, res) {
    res.end(JSON.stringify(getItems(req.query)));
  });

  cleanDbData = function(data, team) {
    if (data.teams[team] == null) {
      data.teams[team] = {};
    }
    if (data.teams[team].teamName == null) {
      data.teams[team].teamName = "No Record";
    }
    if (data.teams[team].teamHome == null) {
      data.teams[team].teamHome = "No Record";
    }
    if (data.teams[team].teamNumber == null) {
      data.teams[team].teamNumber = team;
    }
    if (data.teams[team].teamColour == null) {
      data.teams[team].teamColour = "#ffffff";
    }
    if (data.teams[team].teamRecord == null) {
      data.teams[team].teamRecord = {
        win: 0,
        loss: 0,
        tie: 0
      };
    }
    if (data.teams[team].scout == null) {
      data.teams[team].scout = {};
    }
    if (data.teams[team].scout.pit == null) {
      data.teams[team].scout.pit = {};
    }
    if (data.teams[team].scout.game == null) {
      data.teams[team].scout.game = {};
    }
    return data;
  };

  writeDb = function(data) {
    var dbData, i, len, option, options, ref, team;
    options = data.chosenOptions;
    team = data.currentSelectedTeam;
    dbData = JSON.parse(fs.readFileSync(__dirname + "/db.json", 'utf8', function(err, data) {
      if (err) {
        return console.log(err);
      }
    }));
    dbData = cleanDbData(dbData, team);
    ref = Object.keys(options);
    for (i = 0, len = ref.length; i < len; i++) {
      option = ref[i];
      dbData.teams[team].scout.pit[option] = options[option];
    }
    return saveData(dbData);
  };

  editDb = function(data) {
    var dbData, itm, team, val;
    val = data.value;
    itm = data.element;
    team = data.teamNumber;
    dbData = JSON.parse(fs.readFileSync(__dirname + "/db.json", 'utf8', function(err, data) {
      if (err) {
        return console.log(err);
      }
    }));
    dbData = cleanDbData(dbData, team);
    dbData.teams[team].scout.pit[itm] = val;
    return saveData(dbData);
  };

  saveData = function(data) {
    if (fs.writeFileSync(__dirname + "/db.json", JSON.stringify(data)) == null) {
      return {
        success: true
      };
    }
  };

  ex.get('/write', function(req, res) {
    if (req.query.e != null) {
      return res.end(JSON.stringify(editDb(JSON.parse(req.query.q))));
    } else {
      return res.end(JSON.stringify(writeDb(JSON.parse(req.query.q))));
    }
  });

  server = ex.listen(8081, function() {
    var host, port;
    host = server.address().address;
    port = server.address().port;
    return console.log("Server Online~ [" + host + ":" + port + "]");
  });

}).call(this);
