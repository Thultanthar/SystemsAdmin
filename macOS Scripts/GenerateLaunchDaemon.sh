#!/bin/bash

#This will create a plist that will update inventory at startup

# the tee command will duplicate input (in this case create a file with the contents and output in standard out)
# a heredoc allows us to pass multiple blocks of text or code to an interactive command like tee

plistFile="/Library/LaunchDaemons/com.my.Example.plist"
labelName=$(basename "$plistFile" | sed 's/.plist//')
#checking to see if $plistfile exists
if [[ -f "$plistFile" ]]
then
	launchctl bootout system "$plistFile" 2>/dev/null
	# 2>/dev/null redirects error to the void
	# 2 represents standard error
	rm "$plistFile"
fi

tee "$plistFile"  << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
<key>Label</key>
<string>$labelName</string>
<key>ProgramArguments</key>
<array>
<string>/bin/bash</string>
<string>/Users/Shared/Scripts/example.sh</string>
</array>
<key>RunAtLoad</key>
<true/>
<key>StartCalendarInterval</key>
<dict>
	<key>Hour</key>
	<integer>8</integer>
	<key>Minute</key>
	<integer>30</integer>
	<key>Weekday</key>
	<integer>3</integer>
</dict>
</dict>
</plist>
EOF

# Set ownership and permissions

chown root:wheel "$plistFile"
chmod 644 "$plistFile"
#bootstrap the LaunchDaemon
launchctl bootstrap system "$plistFile"