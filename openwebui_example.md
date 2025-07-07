# Connect text-generation-webui runpod to Open WebUI:

First setup the pod as described in the root `README.md` file.

Then fetch the API url (5000) from runpod:

![5000](images/port_5000.png)

Now while setting up the pod you set the `MY_OPENAI_KEY`, you will need it to communicate with API.

Go to OpenWebUI settings:

![open](images/openwebui1.png)

Go to `Connections` and add:

![web](images/openwebui2.png)

Add your url and your `MY_OPENAI_KEY`. Also add `/v1` after the URL. Like this: `https://<my-pod-id-here>-5000.proxy.runpod.net/v1`

![web](images/openwebui3.png)