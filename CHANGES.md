# Changes
[1.1.3]: https://github.com/sunggun-yu/capitomcat/releases/tag/v1.1.3
[1.1.2]: https://github.com/sunggun-yu/capitomcat/releases/tag/v1.1.2
[1.1.1]: https://github.com/sunggun-yu/capitomcat/releases/tag/v1.1.1
[1.1.0]: https://github.com/sunggun-yu/capitomcat/releases/tag/v1.1.0
[1.0.1]: https://github.com/sunggun-yu/capitomcat/releases/tag/v1.0.1
[1.0.0]: https://github.com/sunggun-yu/capitomcat/releases/tag/v1.0.0
[0.0.3]: https://github.com/sunggun-yu/capitomcat/releases/tag/v0.0.3

## [v1.1.3][1.1.3]
 * Bug Fix : There was space between "-" and "u" at Tomcat work directory cleaning task.

## [v1.1.2][1.1.2]
 * Bug Fix : Some Tomcat startup script need to be executed in background #6 (https://github.com/sunggun-yu/capitomcat/issues/6)
    * Start/stop command has modified to be executed in the background.
    * Adding sleep time after command is executed.
 * Bug Fix : SSHKIT test and within not properly working at CentOS5.x #7 (https://github.com/sunggun-yu/capitomcat/issues/7)
    * Removing within method
    * Adding checking method for remote directory and file existing.

## [v1.1.1][1.1.1]
 * File uploading strategy changing.
 * Modifying tomcat starting check script.
 * Adding tomcat stopping check script.

## [v1.1.0][1.1.0]
 * Update Capistrano dependency to v3.1.0
 * Raise an exception instead of using exit command when local war file or context.xml template file does not exist.
 * The example for 'native' has changed because Capistrano do not allow load_imports in Capistrano class since they update to v3.1.0

## [v1.0.1][1.0.1]
 * Remove Unnecessary dependency

## [v1.0.0][1.0.0]
 * Support Capistrano 3

## [v0.0.3][0.0.3]
 * Support Capistrano 2
