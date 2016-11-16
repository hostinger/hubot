# Description:
#   Listen to "show:2FAInfractors" event and shows users with Github 2FA disabled.
#   You can pass:
#   HUBOT_ROOM to set the room in which the message will be shown
#   HUBOT_EMPTY_ANSWER to set the answer in case, all users have 2fa enabled
#   HUBOT_SEC_FA_SERVICE the service to use
#   DEFAULT_MESSAGE The header's message
#   DEFAULT_ACTIVATE_IT_MESSAGE personal request to activate 2fa
#   DEFAULT_COLOR The left stroke color for each item

DEFAULT_SEC_FA_SERVICE = 'https://api.github.com/orgs/hostinger/members?filter=2fa_disabled'
DEFAULT_ROOM = 'general'
DEFAULT_EMPTY_ANSWER = 'Everybody is using 2FA on Github...:beer:!'
DEFAULT_MESSAGE = '<!channel>! , here are the guys who have not activated Github Two-factor authentication. Please, activate it ASAP'
DEFAULT_ACTIVATE_IT_MESSAGE = 'Please activate it in https://github.com/settings/security'
DEFAULT_COLOR = "#EC737E"
module.exports = (robot) ->

  robot.respond /show github 2fa disabled users/i, (res) ->
    show2FAInfractors(robot)

show2FAInfractors = (robot) ->
  github = require("githubot")(robot)
  secFAService = process.env.HUBOT_SEC_FA_SERVICE || DEFAULT_SEC_FA_SERVICE
  room = process.env.HUBOT_ROOM || DEFAULT_ROOM
  emptyAnswer = process.env.HUBOT_EMPTY_ANSWER || DEFAULT_EMPTY_ANSWER
  message = process.env.HUBOT_MESSAGE || DEFAULT_MESSAGE
  activateItMessage = process.env.HUBOT_ACTIVATE_IT_MESSAGE || DEFAULT_ACTIVATE_IT_MESSAGE
  color = process.env.HUBOT_COLOR || DEFAULT_COLOR

  msgData = {
    channel: room
    text: message
    attachments: []
  }

  github.get secFAService, {}, (users) ->
    if users instanceof Array && users.length      
      for user in users
        msgData.attachments.push {
          title: user.login
          color: color
          title_link: user.html_url
          thumb_url: user.avatar_url
          text: activateItMessage
        }
      robot.adapter.customMessage msgData      
    else      
      robot.messageRoom(room, emptyAnswer) 