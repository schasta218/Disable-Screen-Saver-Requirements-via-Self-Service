# Disable-Screen-Saver-Requirements-via-Self-Service
## Purpose of Workflow
This workflow is meant for companies that want the enhanced security settings that Jamf | Pro can give them, while empowering their users to be able to disable those settings when needed for their jobs. 
## What the workflow does
This workflow forces the screen savers of computers to start after X minutes and locks the computer once the screen saver starts, ensuring that sensitive company data won’t stay unlocked for long periods of time. It also allows employees to click a button through Self Service that will disable the screen saver as long as Keynote or PowerPoint are open.
## How to set up this workflow
This workflow has several steps to setting everything up.

**Package isrunning.sh:** You will need to package isrunning.sh so that it puts the script into */usr/local/jamf/bin/isrunning.sh*. This location is important because we will be calling to it in our script. You can package this using Jamf Composer or another application. Once complete, upload the package to the JSS.

**Create JSS User:** Create an JSS User that will be able to do only the processes that we need to do through the API. This user should have *Read and Update* privileges to *Static Computer Groups*.

**Upload Scripts:** Upload the *DisableScreenSaver.sh* script, along with the *ReEnableScreenSaver.sh* script. Inside of the Options window for both scripts, Parameter labels should be set to the following
* *Parameter 4:* JSS URL
* *Parameter 5:* Username
* *Parameter 6:* Password

**Create a Static Group:** Create a static group named ExcludeScreenSaver. Don’t put any computers in it, the script will be making calls to the API to do that.
* *NOTE: The script calls to the name “ExcludeScreenSaver” so make sure you enter it exactly like that, otherwise you will have to make changes to the script.*

**Create Configuration Profile:** Create a configuration profile to force the screen saver to start after X minutes and lock the computer once the screen saver starts.
* Configure the Login Window payload and check the box for “Start Screen Saver After” under the Options Window.
* Configure the Security and Privacy payload and check the box for “Require Password X seconds/minutes after sleep or screen saver begins.” I recommend setting this to “5 seconds” because we’ve seen problems with setting it to “Immediately.”
* Scope the configuration profile to any computers you want to scope it to, and under “Exclusions” add the “Exclude Screen Saver” static group.

**Create the Disable Screen Saver Policy:** Create a policy to disable the screen saver. This policy should have the following properties:
* Packages: Configure the packages payload and select the package you uploaded earlier that deploys the “isrunning.sh” script.
* Scripts: Configure the scripts payload and select the DisableScreenSaver.sh script. Configure the following parameters:
    * JSS URL: Your full JSS URL (EG: https://yourdomain.com:8443 )
    * Username: The JSS User you created earlier to access the API
    * Password: The password for the JSS User
* Scope: Scope it the the same users you scoped the configuration profile to. Don’t add anything to the exclusions.
* Trigger: Self Service
* Frequency: Ongoing

**Create the ReEnable Screen Saver Policy:** Create a policy to disable the screen saver. This policy should have the following properties:
* Scripts: Configure the scripts payload and select the ReEnableScreenSaver.sh script. Configure the following parameters:
    * JSS URL: Your full JSS URL (EG: https://yourdomain.com:8443 )
    * Username: The JSS User you created earlier to access the API
    * Password: The password for the JSS User
* Scope: All Computers
* Trigger: Custom: reenablescreensaver (its important to use this exact name, as its called to in the script
* Frequency: Ongoing

