import os
import requests
import sseclient
import json

# Obviously do not commit these values to a repository
# Runpod server url (5000)
SERVER_URL = "https://<my-pod-id-here>-5000.proxy.runpod.net/"
# text-generation-webui API key
API_KEY = "myapikeyhere"

body = {
    # see all values at: https://github.com/oobabooga/text-generation-webui/blob/main/extensions/openai/typing.py
    "temperature": 0.7,
    "messages": [
        {"role": "system", "content": "You are a helpful assistant."},
        {"role": "user", "content": "What is the capital of France?"}
    ],
    "stream": True
}

def call_api_streaming(body):
    """
    Calls the text-gen-webui API with streaming enabled.
    Prints each streamed chunk of content as it arrives.
    """
    api_url = f"{SERVER_URL}v1/chat/completions"
    headers = {
        "Content-Type": "application/json",
        "Authorization": f"Bearer {API_KEY}",
    }
    response = requests.post(api_url, headers=headers, json=body, stream=True)
    client = sseclient.SSEClient(response)

    for event in client.events():
        # Skip empty keep-alive events and the '[DONE]' terminator
        if not event.data or event.data.strip() == "[DONE]":
            continue

        try:
            data = json.loads(event.data)
            delta = data["choices"][0]["delta"]
            chunk = delta.get("content", "")
        except (KeyError, json.JSONDecodeError):
            chunk = ""

        if chunk:
            print(chunk, end='')

call_api_streaming(body)