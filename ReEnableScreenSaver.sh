#!/bin/bash
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

# This goes through each item in the array and adds the appropriate XML around it so we can add the computer in through the API. It saves it in multiple xml files. It also checks to see if the serial number it's adding matches the serial number of the computer, since we DON'T want to add that one to the group (we are actually taking it out the the group)
n=0
while [ $n -lt $ln ]
do
	if [ ${existing_serials[$n]} != $serial_number ]
	then
		echo "<computer>
		<serial_number>${existing_serials[$n]}</serial_number>
		</computer>" > "/tmp/jssproject/xml${n}.xml"
	fi
	n=$((n+1))
done

# Combines the xml files together
cat /tmp/jssproject/xml* >> /tmp/jssproject/piece2.xml

# Adds the other pieces needed to complete the full xml file
echo "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>
<computer_group>
	<computers>" > "/tmp/jssproject/piece1.xml"
echo "</computers>
</computer_group>" > "/tmp/jssproject/piece3.xml"

# Puts all the pieces together to create an XML file that can finally be added through the API
cat /tmp/jssproject/piece* >> /tmp/jssproject/add_computers.xml

# Adds the computers through the API
curl -u ${username}:${password} ${jssurl}/JSSResource/computergroups/name/ExcludeScreenSaver -T /tmp/jssproject/add_computers.xml -X PUT

# Does some basic clean up
rm -r /tmp/jssproject/
launchctl unload /Library/LaunchDaemons/com.jamfsoftware.screensaver.plist