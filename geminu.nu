# make sure to set environmental variable for $env.GEMINU_API_KEY so nushell has that
# - get a Google GEMINI API KEY from https://aistudio.google.com/app/apikey
# - add to `env.nu` file located in wherever `$nu.env-path` points

# add this script in to nushell's config file
# - add it to nushell's config file: `config.nu` located wherever `$nu.config-path` points

# consider copying it to nushell's scripts directory
# - cp geminu.nu ($nu.default-config-dir | path join 'scripts')

#!/usr/bin/env nu
def tellme [prompt: string] {
    let prompt_prelude: string = "You are a large language model. You are an expert are being very friendly, helpful, and knowledgable. You strive for accuracy. When provided with a prompt by a user, you very carefully evaluate the request before providing a response.
    When responding, you are always format your response in Markdown so that the user can easily read it.
    You also strive to be concise, factual, and when unable to provide direct answer, you explain why.
    Your response is also suitable to be rendered within a command-line interface environment. Do not wrap your response in block quotes.
    
    Prompt: ";
    let prompt = $prompt_prelude + $prompt
    let prompt = $prompt | str replace --all '"' '\"'
    let prompt = $prompt | str replace --all "'" "\'"
    let prompt = $prompt | str replace --all '\' "\\"
    let apiKey: string = $env.GEMINU_API_KEY;
    let url = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=' + $apiKey ;
    let data = '{"contents": [{"parts":[{"text": "' + $prompt + '"}]}],"safetySettings":[{"category": "HARM_CATEGORY_SEXUALLY_EXPLICIT","threshold": "BLOCK_NONE"}]}' ;
    let result = curl $url -H 'Content-Type: application/json' -X POST -s -d $data ;
    $result | from json | get candidates.content.parts.0.0.text
}