#!/bin/bash

# https://cloud.google.com/translate/docs/reference/rest/v3beta1/projects/translateText
# https://cloud.google.com/translate/docs/basic/translating-text

if [ ! -n "$1" ]; then
   echo -e "\nPlease enter text to translate as an argument\n\nSyntax: translate.sh my line of text for translation\n"
   exit 0;
fi

# note: $# -eq 0  would also work $# gives number of arguments.
# -z would work instead of ! -n.

function enable_translation {

   # enable google translate
   gcloud services enable translate.googleapis.com

   # store project id in a variable
   export PROJECT_ID=$(gcloud config get-value core/project)

   # create a service account for translation
   gcloud iam service-accounts create translation-sa \
     --display-name "my translation service account"

   # grant the service account the translation role
   gcloud projects add-iam-policy-binding ${PROJECT_ID} \
     --member serviceAccount:translation-sa@${PROJECT_ID}.iam.gserviceaccount.com \
     --role roles/cloudtranslate.user

   # download service account credentials to ~/key.json

   gcloud iam service-accounts keys create ~/key.json \
     --iam-account translation-sa@${PROJECT_ID}.iam.gserviceaccount.com
}
   # set the app credentials variable

   export GOOGLE_APPLICATION_CREDENTIALS=~/key.json


if [ -e ~/key.json ]; then
	echo "Environment is already set up!"
else
	echo "Need to set up environment"
	enable_translation
fi

text_to_translate="$@"

# Make a json file with our text to translate and our target language.

echo '{
  "q": ["'"$@"'"],
  "target": "de"
}' > request.json

# Use curl to make a post request that will provide an auth token (from the auth we set up) and send the payload 
# from the json file.  

response=$(curl -X POST \
-H "Authorization: Bearer "$(gcloud auth application-default print-access-token) \
-H "Content-Type: application/json; charset=utf-8" \
-d @request.json \
https://translation.googleapis.com/language/translate/v2)

echo $response
translated=$(echo $response | grep "translatedText" | awk -F ":" '{print $4}' | awk -F "," '{print $1}')

echo -e "\nYour phrase: $@\n\nYour phrase in German: $translated \n"
