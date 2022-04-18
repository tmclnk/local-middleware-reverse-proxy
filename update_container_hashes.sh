#!/usr/bin/env bash

if ! command -v bw &> /dev/null ; then
	<&2 echo "Expecting bitwarden cli (bw) to be available with a github pat stored under \"github pat\""	
	exit 1
fi

github_pat=$(bw get password "github pat")
owner=dmsi-io
branch=develop

declare -A repos
repos[accounts-receivable-api]=develop
repos[users-api]=develop
repos[session-api]=develop
repos[houston-api-docs]=main

for entry in ${!repos[@]}; do
	repo=$entry
	branch="${repos[$entry]}"
	hash=$(curl -s -H "Authorization: token $github_pat" \
		-H "Accept: application/vnd.github.v3.sha" \
		"https://api.github.com/repos/$owner/$repo/commits/$branch")
	gsed -i -e "s/$repo:[a-f0-9]\{7\}/$repo:${hash:0:7}/" docker-compose.yaml

done


