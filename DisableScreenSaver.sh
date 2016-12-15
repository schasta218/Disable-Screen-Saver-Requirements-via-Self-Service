#!/bin/bash

# Checking to see if the user is running Keynote or PowerPoint. If not, it will send them a message and not run the rest of the script.
/bin/ps -ax | grep "/Applications/Microsoft PowerPoint.app/Contents/MacOS/Microsoft PowerPoint" | grep -v grep
if [ $? != 1 ]
	then
	continue=yes
fi
/bin/ps -ax | grep "/Applications/Keynote.app/Contents/MacOS/Keynote" | grep -v grep
if [ $? != 1 ]
	then
	continue=yes
fi
if [ "$continue" != "yes" ]
	then
	sudo jamf displayMessage -message "Please open PowerPoint or Keynote before running"
else
# Making sure the folder that we will be putting files in is both empty, and created
rm -r /tmp/jssproject/
mkdir /tmp/jssproject/

# These are the parameters that will be passed into the script. I'm not even allowing the user to hardcode the values, since I don't want the user passing sensitive data into a script. 
jssurl=$4
username=$5
password=$6

# Grabs the serial number from the computer
serial_number=`system_profiler SPHardwareDataType | awk '/Serial/ {print $4}'`

# Gets the serial number of all the existing computers in the Exlude Screen Saver computer group. This ensures that when we add the new computer to the group, we are also able to add all the existing computers. 
var=$(curl -H "Accept: txt/xml" -sfku ${username}:${password} https://${jssurl}/JSSResource/computergroups/name/ExcludeScreenSaver -X GET | xmllint --format - | grep '<serial_number>' | sed -n 's|<serial_number>\(.*\)</serial_number>|\1|p')
# Passes each individual serial number into an array, so we can grab them one by one later
existing_serials=($var)
ln=${#existing_serials[@]}

# This goes through each item in the array and adds the appropriate XML around it so we can add the computer in through the API. It saves it in multiple xml files.
n=0
while [ $n -lt $ln ]
do
	echo "<computer>
	<serial_number>${existing_serials[$n]}</serial_number>
	</computer>" > "/tmp/jssproject/xml${n}.xml"
	n=$((n+1))
done

# Combines the xml files together
cat /tmp/jssproject/xml* >> /tmp/jssproject/piece2.xml

# Adds the serial number of this computer into another xml file
echo "<computer>
	<serial_number>$serial_number</serial_number>
	</computer>" > "/tmp/jssproject/piece3.xml"

# Adds the other pieces needed to complete the full xml file
echo "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>
<computer_group>
	<computers>" > "/tmp/jssproject/piece1.xml"
echo "</computers>
</computer_group>" > "/tmp/jssproject/piece4.xml"

# Puts all the pieces together to create an XML file that can finally be added through the API
cat /tmp/jssproject/piece* >> /tmp/jssproject/add_computers.xml

# Adds the computers through the API
curl -u ${username}:${password} ${jssurl}/JSSResource/computergroups/name/ExcludeScreenSaver -T /tmp/jssproject/add_computers.xml -X PUT

# Creates a LanchDaemon that will run a script every 10 seconds. The script will check to see if PowerPoint or Keynote is still running. If it is, it will take the computer out of the Exclude Screen Saver computer group, and stop the Launch Daemon. The script was deployed through the JSS with this script.
echo '<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>com.jamfsoftware.screensaver</string>
	<key>ProgramArguments</key>
	<array>
		<string>sh</string>
		<string>/usr/local/jamf/bin/isrunning.sh</string>
	</array>
	<key>RunAtLoad</key>
	<true/>
	<key>StartInterval</key>
	<integer>10</integer>
</dict>
</plist>' > /Library/LaunchDaemons/com.jamfsoftware.screensaver.plist

echo '#!/bin/bash
/bin/ps -ax | grep "/Applications/Microsoft PowerPoint.app/Contents/MacOS/Microsoft PowerPoint" | grep -v grep
if [ $? = 0 ]
	then
	continue=no
fi
/bin/ps -ax | grep "/Applications/Keynote.app/Contents/MacOS/Keynote" | grep -v grep
if [ $? = 0 ]
	then
	continue=no
fi
if [ "$continue" != "no" ]
	then
	/usr/local/jamf/bin/jamf policy -trigger reenablescreensaver
fi' > /usr/local/jamf/bin/isrunning.sh

sleep 5

launchctl load /Library/LaunchDaemons/com.jamfsoftware.screensaver.plist
fi