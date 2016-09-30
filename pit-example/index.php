<!DOCTYPE html>
<html><?php include('../allPages.php'); ?>
  <head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css?family=Ubuntu:400,400i" rel="stylesheet">
    <link href="style.css" rel="stylesheet">
  </head>
  <script src="pitJs.js"></script>
  <body>
    <div id="container">
      <div id="add-robot" class="action-card-body">
        <div class="action-card-header">Add a Team's Robot</div>
        <div class="divider"></div>
        <div season="stronghold" class="action-card-content">
          <div id="action-card-subtitle-offense" class="action-card-subtitle">Offense</div>
          <div class="divider short"></div>
          <div class="action-card-split-container">
            <div id="left-offense" class="action-card-subcontent">
              <div class="action-card-subtitle mini">Shooting</div>
              <div class="options options-highgoal">
                <div class="option-title">Can this robot shoot the high goal?</div>
                <div class="options-container radio">
                  <div id="option-highgoal-yes" onclick="radioOption('highgoal', true)" class="option-button radio options-yes">Yes</div>
                  <div id="option-highgoal-no" onclick="radioOption('highgoal', false)" class="option-button radio options-no">No</div>
                </div>
                <form>
                  <!-- 0: no 1: yes 2: unspecified-->
                  <input id="option-highgoal" type="hidden" value="null">
                </form>
              </div>
              <div class="options input-highgoal">
                <div class="option-title">How many shots can this robot consistently land on the high goal in a given match?</div>
                <form>
                  <!-- 0: no 1: yes 2: unspecified-->
                  <input id="variable-highgoal" type="number" value="0" required="" class="variable-option">
                </form>
              </div>
              <div class="options options-lowgoal">
                <div class="option-title">Can this robot shoot the low goal?</div>
                <div class="options-container radio">
                  <div id="option-lowgoal-yes" onclick="radioOption('lowgoal', true)" class="option-button options-yes">Yes</div>
                  <div id="option-lowgoal-no" onclick="radioOption('lowgoal', false)" class="option-button options-no">No</div>
                </div>
                <form>
                  <!-- 0: no 1: yes 2: unspecified-->
                  <input id="option-lowgoal" type="hidden" value="null">
                </form>
              </div>
              <div class="options input-lowgoal">
                <div class="option-title">About how many boulders does this robot get into the low goal in a given match?</div>
                <form>
                  <!-- 0: no 1: yes 2: unspecified-->
                  <input id="variable-lowgoal" type="number" value="0" required="" class="variable-option">
                </form>
              </div>
              <div class="action-card-subtitle mini">Additional Features</div>
              <div id="wheels-var" class="options input-features">
                <div class="option-title">What kind of wheels does this robot have?</div>
                <form>
                  <input id="variable-wheels" type="text" required="" class="variable-option wide">
                </form>
              </div>
              <div id="info-var" class="options input-features">
                <div class="option-title">This is just a proof of concept.</div>
                <form>
                  <input id="variable-unk" type="text" value="These forms don't actually matter" readonly="" class="variable-option wide">
                </form>
              </div>
            </div>
            <div id="right-offense" class="action-card-subcontent">
              <div class="action-card-subtitle mini">Obstacles</div>
              <div class="options options-obstacle">
                <div class="option-title">Obstacle Slot 1</div>
                <div class="options-container">
                  <div id="option-portcullis" on="false" onclick="toggleOption('portcullis')" class="option-button options-yes">Portcullis</div>
                  <div id="option-cheval" on="false" onclick="toggleOption('cheval')" class="option-button options-yes">Cheval de Frise</div>
                </div>
                <form>
                  <input id="option-obstacle-portcullis" type="hidden" value="false">
                  <input id="option-obstacle-cheval" type="hidden" value="false">
                </form>
              </div>
              <div class="options options-obstacle">
                <div class="option-title">Obstacle Slot 2</div>
                <div class="options-container">
                  <div id="option-moat" on="false" onclick="toggleOption('moat')" class="option-button options-yes">Moat</div>
                  <div id="option-rampart" on="false" onclick="toggleOption('rampart')" class="option-button options-yes">Ramparts</div>
                </div>
                <form>
                  <input id="option-obstacle-moat" type="hidden" value="false">
                  <input id="option-obstacle-rampart" type="hidden" value="false">
                </form>
              </div>
              <div class="options options-obstacle">
                <div class="option-title">Obstacle Slot 3</div>
                <div class="options-container">
                  <div id="option-drawbridge" on="false" onclick="toggleOption('drawbridge')" class="option-button options-yes">Draw Bridge</div>
                  <div id="option-sallyport" on="false" onclick="toggleOption('sallyport')" class="option-button options-yes">Sallyport</div>
                </div>
                <form>
                  <input id="option-obstacle-drawbridge" type="hidden" value="false">
                  <input id="option-obstacle-sallyport" type="hidden" value="false">
                </form>
              </div>
              <div class="options options-obstacle">
                <div class="option-title">Obstacle Slot 4</div>
                <div class="options-container">
                  <div id="option-terrain" on="false" onclick="toggleOption('terrain')" class="option-button options-yes">Rough Terrain</div>
                  <div id="option-rockwall" on="false" onclick="toggleOption('rockwall')" class="option-button options-yes">Rock Wall</div>
                </div>
                <form>
                  <input id="option-obstacle-terrain" type="hidden" value="false">
                  <input id="option-obstacle-rockwall" type="hidden" value="false">
                </form>
              </div>
              <div class="options options-obstacle">
                <div class="option-title">Permanent Obstacle</div>
                <div class="options-container">
                  <div id="option-lowbar" on="false" onclick="toggleOption('lowbar')" class="option-button options-yes">Low Bar</div>
                </div>
                <form>
                  <input id="option-obstacle-lowbar" type="hidden" value="false">
                </form>
              </div>
            </div>
          </div>
          <div onclick="submitData()" class="submit-button">Submit Data to Server</div>
        </div>
      </div>
    </div>
    <div id="mobile-notification" class="hidden">
      <div id="mobile-img">&nbsp</div>
      <div id="mobile-txt">On mobile?<br>Pin to your homescreen.</div>
    </div>
  </body>
</html>