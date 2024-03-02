#!/bin/bash

## variables

user=$(stat -f '%u %Su' /dev/console | cut -d ' ' -f 2)
UUID=$(dscl . -read /Users/$user GeneratedUID | awk '{print $2}')

askPassphrase () {
	osascript <<EOF - 2>/dev/null
tell application "SystemUIServer"
	activate
	text returned of (display dialog "$1" default answer "" with hidden answer)
end tell
EOF
}

jamfHelper="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
jamf="/usr/local/bin/jamf"


## Icon
FileVaultIcon="/Library/Application Support/JAMF/SmallFileVaultIcon.png"
ErrorIcon="/Library/Application Support/JAMF/France_road_sign_A14.svg.png"
SuccessfulIcon="/Library/Application Support/JAMF/ok-1976099_640.png"

######################################################################################################################################

## Messages
Message="
This program synchronizes the Active Directory password and the FileVault password.
Only proceed if the Filevault password does not match the current Windows password."

FailedPwMessage="
The verification of the password failed, please re-enter the new password."

FailedPwMessageAgain="
The input does not match again. The program is ended."

FailedChange="
The password could not be changed. Try again. If the problem persists, contact the ITS Departent."

SuccessfulChange="
Your password has been changed successfully."

######################################################################################################################################

## Query whether the user really wants to change the password. 
HELPER=$("$jamfHelper" -windowType utility -icon "$FileVaultIcon" -title "Change FileVault password" -description "$Message" -button1 "OK" -button2 "Cancel" -cancelButton "2" -defaultButton 2)
echo "Jamf Helper Exit Code: $HELPER"

## If the user agrees, the old password and the new password will be requested. 

if [ "$HELPER" == "0" ]
then
	oldPassphrase=$(askPassphrase 'Please enter the old password.') || exit                       
	newPassphrase=$(askPassphrase 'Please enter the current Active Directory password.') || exit 
	newPassphrase2=$(askPassphrase 'Please enter the current Active Directory password again.') || exit    
	
	
	## Check whether the new password matches.
	if [[ $newPassphrase != $newPassphrase2 ]]
	then 
		
		HELPER=$("$jamfHelper" -windowType utility -icon "$ErrorIcon" -title "Wrong Entry" -description "$FailedPwMessage" -button1 "OK" -defaultButton 1)
		echo "Exit Code: The entry did not match"
		
		newPassphrase=$(askPassphrase 'Please enter the current Active Directory password.') || exit 
		newPassphrase2=$(askPassphrase 'Please enter the current Active Directory password again.') || exit
	fi
	
	## Check again. If the recheck is faulty, the tool is terminated.       
	if [[ $newPassphrase != $newPassphrase2 ]]
	then 
		
		HELPER=$("$jamfHelper" -windowType utility -icon "$ErrorIcon" -title "Renewed wrong entry" -description "$FailedPwMessageAgain" -button1 "OK" -defaultButton 1)
		echo "Exit Code: Die Eingabe war erneut falsch."
		
		exit 1          
	fi
	
	## If the tool was not closed, the password is changed.             
	if diskutil apfs changePassphrase disk1s1 -user $UUID -oldPassphrase $oldPassphrase -newPassphrase $newPassphrase
	then
		
		printf HELPER=$("$jamfHelper" -windowType utility -icon "$SuccessfulIcon" -title "Successful Change" -description "$SuccessfulChange" -button1 "OK" -defaultButton 1)
		echo "Exit Code: Password has been changed succesfully."
		
	else
		
		printf HELPER=$("$jamfHelper" -windowType utility -icon "$ErrorIcon" -title "Error" -description "$FailedChange" -button1 "OK" -defaultButton 1)
		echo "Exit Code: Password could not be changed. Is the old password correct?"
	fi
	
fi

exit 0#!/bin/bash

## variables

user=$(stat -f '%u %Su' /dev/console | cut -d ' ' -f 2)
UUID=$(dscl . -read /Users/$user GeneratedUID | awk '{print $2}')

askPassphrase () {
	osascript <<EOF - 2>/dev/null
tell application "SystemUIServer"
	activate
	text returned of (display dialog "$1" default answer "" with hidden answer)
end tell
EOF
}

jamfHelper="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
jamf="/usr/local/bin/jamf"


## Icon
FileVaultIcon="/Library/Application Support/JAMF/SmallFileVaultIcon.png"
ErrorIcon="/Library/Application Support/JAMF/France_road_sign_A14.svg.png"
SuccessfulIcon="/Library/Application Support/JAMF/ok-1976099_640.png"

######################################################################################################################################

## Messages
Message="
This program synchronizes the Active Directory password and the FileVault password.
Only proceed if the Filevault password does not match the current Windows password."

FailedPwMessage="
The verification of the password failed, please re-enter the new password."

FailedPwMessageAgain="
The input does not match again. The program is ended."

FailedChange="
The password could not be changed. Try again. If the problem persists, contact the ITS Departent."

SuccessfulChange="
Your password has been changed successfully."

######################################################################################################################################

## Query whether the user really wants to change the password. 
HELPER=$("$jamfHelper" -windowType utility -icon "$FileVaultIcon" -title "Change FileVault password" -description "$Message" -button1 "OK" -button2 "Cancel" -cancelButton "2" -defaultButton 2)
echo "Jamf Helper Exit Code: $HELPER"

## If the user agrees, the old password and the new password will be requested. 

if [ "$HELPER" == "0" ]
then
	oldPassphrase=$(askPassphrase 'Please enter the old password.') || exit                       
	newPassphrase=$(askPassphrase 'Please enter the current Active Directory password.') || exit 
	newPassphrase2=$(askPassphrase 'Please enter the current Active Directory password again.') || exit    
	
	
	## Check whether the new password matches.
	if [[ $newPassphrase != $newPassphrase2 ]]
	then 
		
		HELPER=$("$jamfHelper" -windowType utility -icon "$ErrorIcon" -title "Wrong Entry" -description "$FailedPwMessage" -button1 "OK" -defaultButton 1)
		echo "Exit Code: The entry did not match"
		
		newPassphrase=$(askPassphrase 'Please enter the current Active Directory password.') || exit 
		newPassphrase2=$(askPassphrase 'Please enter the current Active Directory password again.') || exit
	fi
	
	## Check again. If the recheck is faulty, the tool is terminated.       
	if [[ $newPassphrase != $newPassphrase2 ]]
	then 
		
		HELPER=$("$jamfHelper" -windowType utility -icon "$ErrorIcon" -title "Renewed wrong entry" -description "$FailedPwMessageAgain" -button1 "OK" -defaultButton 1)
		echo "Exit Code: Die Eingabe war erneut falsch."
		
		exit 1          
	fi
	
	## If the tool was not closed, the password is changed.             
	if diskutil apfs changePassphrase disk1s1 -user $UUID -oldPassphrase $oldPassphrase -newPassphrase $newPassphrase
	then
		
		printf HELPER=$("$jamfHelper" -windowType utility -icon "$SuccessfulIcon" -title "Successful Change" -description "$SuccessfulChange" -button1 "OK" -defaultButton 1)
		echo "Exit Code: Password has been changed succesfully."
		
	else
		
		printf HELPER=$("$jamfHelper" -windowType utility -icon "$ErrorIcon" -title "Error" -description "$FailedChange" -button1 "OK" -defaultButton 1)
		echo "Exit Code: Password could not be changed. Is the old password correct?"
	fi
	
fi

exit 0