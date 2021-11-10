#!/bin/sh

# Get latest repository's versioning tag
version=$(git describe --tags `git rev-list --tags --max-count=1`)
year=`echo $version | cut -d '.' -f1`
major=`echo $version | cut -d '.' -f2`
minor=`echo $version | cut -d '.' -f3`

# Get current time for checking tag
cur_year=`date +%Y`
cur_month=$(date +%m | bc)
cur_major=$((($cur_month-1)/3+1))

if [ $year -ne $cur_year ]; then
    year=$cur_year
    major=$cur_major
    minor=1
else
    if [ $major -ne $cur_major ]; then
        major=$cur_major
        minor=1
    else
        minor=$(($minor+1))
    fi
fi

# Get message
git_message=$(git log --format=%B -n 1 $GIT_COMMIT)

# Update new version tag
git tag -a $year.$major.$minor -m "test tagging script"
git push --tags