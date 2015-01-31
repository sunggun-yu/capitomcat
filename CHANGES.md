# Changes
[1.2.1]: https://github.com/sunggun-yu/capitomcat/releases/tag/v1.2.1
[1.2.0]: https://github.com/sunggun-yu/capitomcat/releases/tag/v1.2.0
[1.1.4]: https://github.com/sunggun-yu/capitomcat/releases/tag/v1.1.4
[1.1.3]: https://github.com/sunggun-yu/capitomcat/releases/tag/v1.1.3
[1.1.2]: https://github.com/sunggun-yu/capitomcat/releases/tag/v1.1.2
[1.1.1]: https://github.com/sunggun-yu/capitomcat/releases/tag/v1.1.1
[1.1.0]: https://github.com/sunggun-yu/capitomcat/releases/tag/v1.1.0
[1.0.1]: https://github.com/sunggun-yu/capitomcat/releases/tag/v1.0.1
[1.0.0]: https://github.com/sunggun-yu/capitomcat/releases/tag/v1.0.0
[0.0.3]: https://github.com/sunggun-yu/capitomcat/releases/tag/v0.0.3

## [v1.2.1][1.2.1]
 * Revert back the executing tomcat command in background. gives choice option whether use background or not
   * It really hard to know which OS is work with pty true/false for tomcat start script. it depends.... please refer to http://capistranorb.com/documentation/faq/why-does-something-work-in-my-ssh-session-but-not-in-capistrano/
   * Some of the OS only works with background script. ex) CentOS 5.6

## [v1.2.0][1.2.0]
 * Updating Capistrano dependency version.
 * Removing background executing of tomcat command. also, sleep time has removed accordingly.
    * PTY option is not properly applied.
    * In actually, executing tomcat command in background is not effective. It is all about Tomcat starting command. In most of case, Tomcat init.d command use `/bin/su -p -s /bin/bash -l $TOMCAT_USER $TOMCAT_HOME/bin/startup.sh`. however, In some OS, such like CentOS/Oracle 5.9 and 6.5, tomcat command process were killed right after the ssh session has closed. To prevent this issue, init.d script should be modified like, `su $TOMCAT_USER -c $TOMCAT_HOME/bin/startup.sh`
 * Adding attribute for Tomcat command waiting timeout. Changing netstat checking logic.

## [v1.1.4][1.1.4]
 * Adding "cleanup unpacked WAR directory" function before tomcat starting.
    * Unpacked WAR directory is not refreshed. eventually, Tomcat doesn't provide latest changes in new WAR file by this issue.
    * Thanks to @jwcarman

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
