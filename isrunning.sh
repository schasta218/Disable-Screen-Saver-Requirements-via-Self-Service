#!/bin/bash
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
fi
