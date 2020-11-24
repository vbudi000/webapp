#!/bin/bash

## Step 0: reading config
DIRNAME=$(dirname "$0")
BASENAME=$(basename "$0")

active=$(oc whoami 2>/dev/null | wc -l)

if [ $active -eq 0 ]; then
  echo "Cannot invoke oc command; Please login first to the hub cluster"
  exit 999
fi
 
if [ -f ${DIRNAME}/config ]; then
  # read config
  source ${DIRNAME}/config
else
  echo "config not found"
  exit 999
fi

## Step 1: Create base project in the hub

exists=$(oc projects ${appname} 2>/dev/null | wc -l)
if [ $exists -eq 0 ]; then
  oc new-project ${appname}
fi

if [ "$prod" == "true" ]; then
  # Need to consider what to do for the PROD later 
fi

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
