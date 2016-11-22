# Description:
#    Show 2fa disabled users
#
# Dependencies:
#   none
#
# Configuration:
#   none
#
# Optional Configuration:
#   HUBOT_2FA_EMPTY_ANSWER to set the answer in case, all users have 2fa enabled
#   HUBOT_2FA_HEADER_MESSAGE The header's message
#   HUBOT_2FA_ACTIVATE_IT_MESSAGE personal request to activate 2fa
#
# Commands:
#   hubot hostinger show github 2fa disabled users - show 2fa disabled users
#
# Author:
#   danielechalar

DEFAULT_EMPTY_ANSWER = 'Everybody is using 2FA on Github :)!'
DEFAULT_2FA_HEADER_MESSAGE = '<!channel>! , here are the guys who have not activated Github Two-factor authentication. Please, activate it ASAP \n'
DEFAULT_ACTIVATE_IT_MESSAGE = 'Please activate it in https://github.com/settings/security'

module.exports = (robot) ->
  robot.respond /hostinger show github 2fa disabled users/i, (res) ->
    show2FAInfractors(robot,res)

show2FAInfractors = (robot,res) ->
  github = require("githubot")(robot)
  emptyAnswer = process.env.HUBOT_2FA_EMPTY_ANSWER || DEFAULT_EMPTY_ANSWER
  message = process.env.HUBOT_2FA_HEADER_MESSAGE || DEFAULT_2FA_HEADER_MESSAGE
  activateItMessage = process.env.HUBOT_2FA_ACTIVATE_IT_MESSAGE || DEFAULT_ACTIVATE_IT_MESSAGE

  namesList = []
  github.get 'https://api.github.com/orgs/hostinger/members', {filter:"2fa_disabled"}, (users) ->
    if users instanceof Array && users.length      
      namesList.push user.login+" - "+user.html_url+"\n" for user in users
      namesList = namesList.join('\n')
      res.send "#{message} #{namesList}\n #{activateItMessage}"
    else      
      res.send emptyAnswer