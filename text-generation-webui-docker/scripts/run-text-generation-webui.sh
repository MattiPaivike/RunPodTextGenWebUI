#!/bin/bash
cd /workspace/text-generation-webui

# Edit these arguments if you want to customise text-generation-webui launch.
# Don't remove "$@" from the start unless you want to prevent automatic model loading from template arguments
ARGS=("$@" --listen --extensions openai --gradio-auth $GRADIO_USERNAME:$GRADIO_PASSWORD --api-key $MY_OPENAI_KEY)

echo "Launching text-generation-webui with args: ${ARGS[@]}"

python3 server.py "${ARGS[@]}"
