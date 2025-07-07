#!/bin/bash
echo "Starting: Ooobabooga's text-generation-webui"

SCRIPTDIR=/root/scripts
VOLUME=/workspace

mkdir -p $VOLUME/logs

if [[ $PUBLIC_KEY ]]; then
	mkdir -p ~/.ssh
	chmod 700 ~/.ssh
	cd ~/.ssh
	echo "$PUBLIC_KEY" >>authorized_keys
	chmod 700 -R ~/.ssh
	service ssh start
fi

# Move text-generation-webui's folder to $VOLUME so models and all config will persist
"$SCRIPTDIR"/textgen-on-workspace.sh

# Move the script that launches text-gen to $VOLUME, so users can make persistent changes to CLI arguments
if [[ ! -f $VOLUME/run-text-generation-webui.sh ]]; then
	mv "$SCRIPTDIR"/run-text-generation-webui.sh $VOLUME/run-text-generation-webui.sh
fi

ARGS=()
while true; do
	# If the user wants to stop the UI from auto launching, they can run:
	# touch $VOLUME/do.not.launch.UI
	if [[ ! -f $VOLUME/do.not.launch.UI ]]; then
		# Launch the UI in a loop forever, allowing UI restart
		if [[ -f /tmp/text-gen-model ]]; then
			# If this file exists, we successfully downloaded a model file or folder
			# Therefore we auto load this model
			ARGS=(--model "$(</tmp/text-gen-model)")
		fi
		if [[ ${UI_ARGS} ]]; then
			# Passed arguments in the template
			ARGS=("${ARGS[@]}" ${UI_ARGS})
		fi

		# Run text-generation-webui and log it.
		# tee is used for logs so they also display on 'screen', ie will show in the Runpod log viewer
		($VOLUME/run-text-generation-webui.sh "${ARGS[@]}" 2>&1) | tee -a $VOLUME/logs/text-generation-webui.log

	fi
	sleep 2
done

# shouldn't actually reach this point
sleep infinity
