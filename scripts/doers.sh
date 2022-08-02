#!/bin/bash

. scripts/helpers.sh

function doAuthorisation() {
    # generate if don't have
    if [[ ! -f .auth.json ]]; then 
        echo "Generating auth token"
        if ! getAuthToken; then 
            >&2 echo "Failed to generate auth token"
            if [[ ! -z ERROR_REASON ]]; then
                >&2 echo "ERROR_REASON: $ERROR_REASON"
            fi
            exit 1
        fi
        echo "Generated auth token"
    fi

    # read from file
    echo "Fetching ACCESS TOKEN"
    if ! readAuthToken; then 
        >&2 echo "Failed to fetch ACCESS TOKEN"
        if [[ ! -z ERROR_REASON ]]; then
            >&2 echo "ERROR_REASON: $ERROR_REASON"
        fi
        exit 1
    fi
    echo "ACCESS TOKEN is $ACCESS_TOKEN"

    # refresh for safety :)
    echo "Refreshing access token"
    if ! refreshAuthToken; then 
        >&2 echo "Failed to refresh access token"
        if [[ ! -z ERROR_REASON ]]; then
            >&2 echo "ERROR_REASON: $ERROR_REASON"
        fi
        exit 1
    fi
    echo "Finished refreshing access token"

    # read refreshed from file 
    echo "Fetching ACCESS TOKEN"
    if ! readAuthToken; then 
        >&2 echo "Failed to fetch ACCESS TOKEN"
        if [[ ! -z ERROR_REASON ]]; then
            >&2 echo "ERROR_REASON: $ERROR_REASON"
        fi
        exit 1
    fi
    echo "ACCESS TOKEN is $ACCESS_TOKEN"

}

function doUpload() {
    echo "Uploading package update"
    if ! uploadPackageUpdate; then 
        >&2 echo "Failed to upload package update"
        if [[ ! -z ERROR_REASON ]]; then
            >&2 echo "ERROR_REASON: $ERROR_REASON"
        fi
        exit 1
    fi
    echo "Successfully uploaded package update"
}

function doPublish() {
    echo "Publishing package update"
    if ! publishPackageUpdate; then 
        >&2 echo "Failed to publish package update"
        if [[ ! -z ERROR_REASON ]]; then
            >&2 echo "ERROR_REASON: $ERROR_REASON"
        fi
        exit 1 
    fi
    echo "Successfully published package update"
}
