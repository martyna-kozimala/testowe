#!/usr/bin/bash
DEFAULT_REPOS_DIR=$HOME/repos
gitRepo=$1
personalAccessToken=$HOME/.spagit_token
gitConfig=$(git config -l)
gitUsername=$2
gitEmail=
GITHUB_URL=

mkdir -p $DEFAULT_REPOS_DIR
#cat $personalAccessToken 
sed -i '/^[[:space:]]*$/d' $personalAccessToken

touch $personalAccessToken

#echo before $BROWSER

if [ -z $BROWSER ]; then
	export BROWSER=firefox
fi

#echo after $BROWSER

if [ -z "$gitConfig" ]; then
echo [**] Need to setup git username, enter username:
read gitUsername
git config --global user.name $gitUsername
echo [**] Need to setup git email, enter email:
read gitEmail
git config --global user.email $gitEmail
fi

if [ -z $1 ]; then
	echo [!!] You need to specify the repo. Exiting.
	exit
fi

if [ -z $2 ]; then
	gitUsername=$(git config user.name)
fi



#gitUsername=$(git config user.name)
#gitEmail=$(git config user.email)

#$personalAccessToken
if [ -s $personalAccessToken ]; then
        # The file is not-empty.
        echo jest cos
else
        # The file is empty.
        echo [**] Need personal access token to work 
 echo $gitUsername | xclip -sel clip
	echo [**] Your username is in clipboard, please authenticate and generate personal access token and paste it here
	echo [*] Opening browser
	sleep 2
	$BROWSER https://github.com/settings/tokens
	echo [**] Please paste personal access token here
	read personalAccessTokenString
	echo $personalAccessTokenString > $personalAccessToken
	fi


GITHUB_URL="https://github.com/"$gitUsername"/"$gitRepo".git"
if  cd $DEFAULT_REPOS_DIR/$gitRepo; then
	bash 
else
	echo [**] Creating new repo directory.
	repoPath=$DEFAULT_REPOS_DIR/$gitRepo
	mkdir -p $DEFAULT_REPOS_DIR/$gitRepo
	cd $repoPath
	git init
	#expect here below
	git remote add origin $GITHUB_URL
	#or here below
	git clone $GITHUB_URL
	commandResult=$?
	if [ -z commandResult ]; then
		echo [**] Your repo has been cloned.
	else
		echo [**] Repo does not exist, create it.
		echo $gitRepo | xclip -sel clip
		echo [**] Repo name is in clipboard.

		sleep 2
		$BROWSER 'https://github.com/'$gitUsername'?tab=repositories'
		echo [**] Press any key to clone created repo.
		read anyKey
		git remote add origin $GITHUB_URL
		git clone $GITHUB_URL
	fi
fi



exit
expect -d  <<EOF
set timeout 20
set Username "user"
set Password "***$$$"
spawn ssh \$Username@$FQDN
expect "*assword:"
send "\$Password\r"
expect "#"
send "some command\r"
expect "#"
send "exit\r"
sleep 1
exit
expect eof
EOF
cat $LogFile

