# Disable-Screen-Saver-Requirements-via-Self-Service
## Purpose of Workflow
This workflow is meant for companies that want the enhanced security settings that Jamf | Pro can give them, while empowering their users to be able to disable those settings when needed for their jobs. 
## What the workflow does
This workflow forces the screen savers of computers to start after X minutes and locks the
computer once the screen saver starts, ensuring that sensitive company data won’t stay
unlocked for long periods of time. It also allows employees to click a button through Self
Service that will disable the screen saver as long as Keynote or PowerPoint are open.
## How to set up this workflow
This workflow has several steps to setting everything up.

**Package isrunning.sh:** You will need to package isrunning.sh so that it puts the script into
*/usr/local/jamf/bin/isrunning.sh*. This location is important because we will be calling to
it in our script. You can package this using Jamf Composer or another application. Once
complete, upload the package to the JSS.

**Create JSS User:** Create an JSS User that will be able to do only the processes that we
need to do through the API. This user should have *Read and Update* privileges to *Static
Computer Groups*.

**Upload Scripts:** Upload the *DisableScreenSaver.sh* script, along with the
*ReEnableScreenSaver.sh* script. Inside of the Options window for both scripts, Parameter
labels should be set to the following
* *Parameter 4:* JSS URL
* *Parameter 5:* Username
* *Parameter 6:* Password

**Create a Static Group:** Create a static group named ExcludeScreenSaver. Don’t put any
computers in it, the script will be making calls to the API to do that.
* NOTE: The script calls to the name “ExcludeScreenSaver” so make sure you enter it exactly like that, otherwise you will have to make changes to the script.
