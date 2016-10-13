# Description:
#   Listen to "show:2FAInfractors" event and shows users with Github 2FA disabled.
#   You can pass:
#   ROOM to set the room in which the message will be shown
#   EMPTY_ANSWER to set the answer in case, all users have 2fa enabled
#   SEC_FA_SERVICE the service to use

DEFAULT_SEC_FA_SERVICE = 'https://api.github.com/orgs/hostinger/members?filter=2fa_disabled'
DEFAULT_ROOM = 'general'
DEFAULT_EMPTY_ANSWER = 'Everybody is using 2FA on Github...:beer:!'
module.exports = (robot) ->
  robot.on 'show:2FAInfractors', () ->
    github = require("githubot")(robot)

    secFAService = process.env.SEC_FA_SERVICE || DEFAULT_SEC_FA_SERVICE
    room = process.env.ROOM || DEFAULT_ROOM
    emptyAnswer = process.env.EMPTY_ANSWER || DEFAULT_EMPTY_ANSWER

    namesList = []
    github.get secFAService, {}, (users) ->
      if users instanceof Array && users.length
        namesList.push '@'+user.login for user in users
        robot.messageRoom(room, namesList.join(', '))
      else
        robot.messageRoom(room, emptyAnswer)