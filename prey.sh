#! /bin/bash

CONTEXT="$1"
METRIC="visuallyLoaded"
TIME="14d"
DEVICE="flame-kk"
MEMORY="512"
BRANCH="master"
TEST="cold-launch"

if [ -z "$CONTEXT" ]; then
  echo "Missing context for determining regressions"
  # Exiting with 0 code to keep heroku from telling me it crashed
  exit 0
fi

./node_modules/.bin/raptor query measure \
  --host $DB_HOST \
  --port $DB_PORT \
  --username $DB_USERNAME \
  --password $DB_PASSWORD \
  --database $DB_NAME \
  --protocol $DB_PROTOCOL \
  --context $CONTEXT \
  --metric $METRIC \
  --test $TEST \
  --time $TIME \
  --device $DEVICE \
  --memory $MEMORY \
  --branch $BRANCH | ./node_modules/.bin/raptor regression | ./node_modules/.bin/raptor track \
  --host $DB_HOST \
  --port $DB_PORT \
  --username $DB_USERNAME \
  --password $DB_PASSWORD \
  --database $DB_NAME \
  --protocol $DB_PROTOCOL | ./node_modules/.bin/raptor bug \
  --url $BZ_URL \
  --timeout $BZ_TIMEOUT \
  --username $BZ_USERNAME \
  --password $BZ_PASSWORD \
  --token $BITLY_TOKEN
