#!/bin/bash

currentUser=$( echo "show State:/Users/ConsoleUser" | scutil | awk '/Name :/ { print $3 }' )
plistfile=/Library/LaunchAgents/com.trusourcelabs.NoMAD.plist
shellFile=/Users/Shared/Remove-Nomad.sh
rm "$shellFile"
sleep 1
tee "$shellFile" << EOF
#!/bin/bash
cd /
launchctl unload $plistfile
EOF

chmod 755 $shellFile
chown -R "$currentUser":staff "$shellFile"
su "$currentUser" -c "sh "$shellFile""

rm "$shellFile"
rm "$plistFile"
rm -rf /Applications/NoMad.app
