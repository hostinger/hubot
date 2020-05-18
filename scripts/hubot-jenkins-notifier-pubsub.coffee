# Description:
#   Receive event data from Jenkins Notifier Plugin
#   Notify subscribers about jenkins events
#
# Dependencies:
#   "hubot-pubsub": "1.0.0"
#
# URLS:
#   POST /hubot/jenkins
#
# Notes:
#   @see https://wiki.jenkins-ci.org/display/JENKINS/Notification+Plugin

module.exports = (robot) ->
  robot.router.post '/hubot/jenkins', (req, res) ->
    res.end('')
    data = req.body
    message = "#{data.name} ##{data.build.number} #{data.build.status} (#{data.build.full_url})"
    event = "build.#{data.name}.#{data.build.status.toLowerCase()}"

    if data.build.status == 'SUCCESS'
      message = ":sunny: " + message
    if data.build.status == 'FAILURE'
      message = ":red_circle: " + message

    robot.emit 'pubsub:publish', event, message
