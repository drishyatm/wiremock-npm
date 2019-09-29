#!/bin/bash


git remote remove origin
git remote add origin https://$GH_TOKEN@github.com/tomasbjerre/wiremock-npm.git
git remote -v

git tag testtag
git push -u origin --tags



cd release-automate
npm install
versionToRelease=`node release-automate.js`
if [ $? -eq 1 ]; then
 echo "No new release"
 exit
fi
cd ..
echo "version = $versionToRelease" > version.properties

git config user.email "travis@travis-ci.org"
git config user.name "Travis CI"
git checkout master
git commit -a -m "Bump version to $versionToRelease"

./release.sh || exit 1

git push -u origin master
