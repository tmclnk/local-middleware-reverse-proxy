#!/usr/bin/env bash
set -e

if [ -z "$GITHUB_PAT" ]; then
	# try bitwarden cli
	if ! command -v bw &> /dev/null ; then
		>&2 echo "Expecting bitwarden cli (bw) to be available with a github pat stored under \"github pat\""	
		exit 1
	fi
fi

GITHUB_PAT=$(bw get password "github pat")
owner=dmsi-io
branch=develop

declare -A repos
repos[accounts-receivable-api]=develop
repos[users-api]=develop
repos[session-api]=develop
repos[houston-api-docs]=main

for entry in "${!repos[@]}"; do
	repo=$entry
	branch="${repos[$entry]}"
	hash=$(curl -s -H "Authorization: token $GITHUB_PAT" \
		-H "Accept: application/vnd.github.v3.sha" \
		"https://api.github.com/repos/$owner/$repo/commits/$branch")
			gsed -i -e "s/$repo:[a-f0-9]\{7\}/$repo:${hash:0:7}/" docker-compose.yaml
		done

