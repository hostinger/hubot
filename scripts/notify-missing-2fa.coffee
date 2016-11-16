# Description:
#   Listen to "show:2FAInfractors" event and shows users with Github 2FA disabled.
#   You can pass:
#   HUBOT_ROOM to set the room in which the message will be shown
#   HUBOT_EMPTY_ANSWER to set the answer in case, all users have 2fa enabled
#   HUBOT_SEC_FA_SERVICE the service to use

DEFAULT_SEC_FA_SERVICE = 'https://api.github.com/orgs/hostinger/members?filter=2fa_disabled'
DEFAULT_ROOM = 'general'
DEFAULT_EMPTY_ANSWER = 'Everybody is using 2FA on Github...:beer:!'
DEFAULT_MESSAGE = '<!channel>! , here are the guys who have not activated Github Two-factor authentication. Please, activate it ASAP'
module.exports = (robot) ->
  robot.on 'show:2FAInfractors', () ->
    show2FAInfractors(robot)

  robot.respond /show 2FA disabled/i, (res) ->
    show2FAInfractors(robot)

show2FAInfractors = (robot) ->
  github = require("githubot")(robot)
  secFAService = process.env.HUBOT_SEC_FA_SERVICE || DEFAULT_SEC_FA_SERVICE
  room = process.env.HUBOT_ROOM || DEFAULT_ROOM
  emptyAnswer = process.env.HUBOT_EMPTY_ANSWER || DEFAULT_EMPTY_ANSWER
  message = process.env.HUBOT_MESSAGE || DEFAULT_MESSAGE

  namesList = []
  github.get secFAService, {}, (users) ->
    if users instanceof Array && users.length      
      namesList.push "https://github.com/"+user.login for user in users
      robot.messageRoom(room, message+":\n"+namesList.join(', '))
    else      
      robot.messageRoom(room, emptyAnswer) 