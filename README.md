# Disable Screen Saver Requirements via Self Service
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

That’s it! Now enroll a computer into the JSS, and test the workflow out by going into Self Service and clicking the module. The screen saver should be turned off while Keynote and PowerPoint are running.
## Behind The Scenes
So what’s actually happening when a user pushes the button? Quite a number of things, actually. Here’s what happens, step by step:

1. The configuration profile which forces computers to have a screen saver on and the
computer to lock once it activates is deployed to the targeted computers.
2. User pushes the button in Self Service
3. The package you created places isrunning.sh into /usr/local/jamf/bin/
4. DisableScreenSaver.sh runs, doing the following
    * Grabs the serial number of the computer the user is on and adds it to the ExcludeScreenSaver group.
    * Creates a Launch Daemon on the user’s computer that runs /usr/local/jamf/bin/isrunning.sh every 10 seconds
5. isrunning.sh checks to see if PowerPoint or Keynote is running. If they aren’t, it runs jamf policy -trigger reenablescreensaver, which runs the Re-Enable Screensaver policy
6. The Re-Enable Screensaver policy takes the computer out of the ExcludeScreenSaver group, which removes the configuration profile.
## More Information
For more information on how these scripts work, look at the scripts themselves. Each one is heavily commented to explain exactly what is happening.
