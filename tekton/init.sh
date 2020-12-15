#!/bin/bash

## Step 0: reading config
DIRNAME=$(dirname "$0")
BASENAME=$(basename "$0")

active=$(oc whoami 2>/dev/null | wc -l)

if [ $active -eq 0 ]; then
  echo "Cannot invoke oc command; Please login first to the hub cluster"
  exit 900
fi

if [ -f ${DIRNAME}/config ]; then
  # read config
  source ${DIRNAME}/config
else
  echo "config not found"
  exit 950
fi

# get appname from DIRNAME
# appname=$(git config --get remote.origin.url | cut -d\/ -f5)
giturl=$(git config --get remote.origin.url)

find . -type f -name *.yaml | xargs sed -i .bak "s/{APPNAME}/${appname}/g"
find . -type f -name *.yaml | xargs sed -i .bak "s/{APPVERSION}/${appversion}/g"
find . -type f -name *.yaml | xargs sed -i .bak "s/{GITURL}/${giturl}/g"
find . -type f -name *.yaml | xargs sed -i .bak "s/{DEVNS}/${devns}/g"
find . -type f -name *.yaml | xargs sed -i .bak "s/{QANS}/${qans}/g"
find . -type f -name *.yaml | xargs sed -i .bak "s/{PRODNS}/${prodns}/g"
find . -type f -name *.yaml | xargs sed -i .bak "s/{PORT}/${port}/g"
find . -type f -name *.yaml | xargs sed -i .bak "s/{DEPLOY-DEV}/${deploydev}/g"
find . -type f -name *.yaml | xargs sed -i .bak "s/{DEPLOY-QA}/${deployqa}/g"
find . -name *.bak | xargs rm -f

## Step 1: Create base project in the non-Prod hub

exists=$(oc projects ${devns} 2>/dev/null | wc -l)
if [ $exists -eq 0 ]; then
  oc new-project ${devns}
fi

exists=$(oc projects ${devopsns} 2>/dev/null | wc -l)
if [ $exists -eq 0 ]; then
  oc new-project ${devopsns}
fi

exit
## Step 2: Create tekton resources

for file in $(ls ./Resources); do
  oc delete -f Resources/${file} 2>/dev/null
  oc create -f Resources/${file}
done

## Step 3: Create tekton tasks

for file in $(ls ./Tasks); do
  oc delete -f Tasks/${file} 2>/dev/null
  oc create -f Tasks/${file}
done

## Step 4: Create tekton triggets

for file in $(ls ./Triggers); do
  oc delete -f Triggers/${file} 2>/dev/null
  oc create -f Triggers/${file}
done

## Step 5: Create tekton pipeline

for file in $(ls ./Pipelines); do
  oc delete -f Pipelines/${file} 2>/dev/null
  oc create -f Pipelines/${file}
done

## Step 6: Create other resources

for file in $(ls ./EventListener); do
  oc delete -f EventListener/${file} 2>/dev/null
  oc create -f EventListener/${file}
done
