#!/bin/bash

# client_id client_secret auth_code app_id
. .env

function readAuthToken() {
    ACCESS_TOKEN="$(cat .auth.json | jq -r '.access_token')"
    REFRESH_TOKEN="$(cat .auth.json | jq -r '.refresh_token')"
    if [[ $ACCESS_TOKEN == "null" ]]; then
        return 1
    fi
}

function refreshAuthToken() {
    RESPONSE="$(curl -s -XPOST "https://accounts.google.com/o/oauth2/token" \
  -d "client_id=$CLIENT_ID&client_secret=$CLIENT_SECRET&refresh_token=$REFRESH_TOKEN&grant_type=refresh_token&redirect_uri=urn:ietf:wg:oauth:2.0:oob")"
    ERROR="$(echo "$RESPONSE" | jq -r '.error')"
    if [[ ! "$ERROR" == "null" ]]; then
        ERROR_REASON=$(echo "$RESPONSE" | jq -r '.error_description')
        return 1
    fi
    ## ensure refresh_token still there
    RESPONSE=$(echo "$RESPONSE" | jq '. += {"refresh_token": "'""$REFRESH_TOKEN'"}')
    echo "$RESPONSE" > .auth.json
}

function getAuthToken() {
    RESPONSE="$(curl -s "https://accounts.google.com/o/oauth2/token" -d \
        "client_id=$CLIENT_ID&client_secret=$CLIENT_SECRET&code=$AUTH_CODE&grant_type=authorization_code&redirect_uri=urn:ietf:wg:oauth:2.0:oob")"
    ERROR="$(echo "$RESPONSE" | jq -r '.error')"
    if [[ ! "$ERROR" == "null" ]]; then
        ERROR_REASON=$(echo "$RESPONSE" | jq -r '.error_description')
        return 1
    fi
    echo "$RESPONSE" > .auth.json
}

function uploadPackageUpdate() {
    RESPONSE="$(curl -s -XPUT \
        -H "Authorization: Bearer $ACCESS_TOKEN" \
        -H "x-goog-api-version: 2" \
        -T dist/simple-image-rotator.zip \
        https://www.googleapis.com/upload/chromewebstore/v1.1/items/$APP_ID)"
    ERROR_CODE="$(echo "$RESPONSE" | jq -r '.error.code')"
    if [[ ! $ERROR_CODE == "null" ]]; then 
        ERROR_REASON="$(echo "$RESPONSE" | jq -r '.error.message')"
        return 1
    fi
}

function publishPackageUpdate() {
    RESPONSE="$(curl -s -XPOST \
        -H "Authorization: Bearer $ACCESS_TOKEN" \
        -H "x-goog-api-version: 2" \
        -H "Content-Length: 0" \
        https://www.googleapis.com/chromewebstore/v1.1/items/$APP_ID/publish)"
    ERROR_CODE="$(echo "$RESPONSE" | jq -r '.error.code')"
    if [[ ! $ERROR_CODE == "null" ]]; then 
        ERROR_REASON="$(echo "$RESPONSE" | jq -r '.error.message')"
        return 1
    fi
    
}

