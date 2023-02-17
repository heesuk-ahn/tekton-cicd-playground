#!/bin/bash

# variables
CURR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )";

[ -d "$CURR_DIR" ] || { echo "FATAL: no current dir (maybe running in zsh?)";  exit 1; }
source "$CURR_DIR/common.sh";

start_message
new_line

# STEP 1) install tekton ui
section "Define new task - goodbye"
echo "Declare a new Task named goodbye as shown below"
cat ./manifests/goodbye-task.yaml

new_line
exec_not_visible_command "highlight_with_color_value \"$GRN\" \"Note) This Task uses parameters passed to param using params.username\""
info_pause_exec "Deploy a goodbye task. Please press enter." "kubectl apply -f ./manifests/goodbye-task.yaml"

# Step 2) Create and run a pipeline
section "Define new pipeline - hello -> goodbye"
exec_not_visible_command "highlight_with_color_value \"$GRN\" \"Define the pipeline as below\""
cat ./manifests/hello-goodbye-pipeline.yaml
info_pause_exec "Deploy the hello-goodbye-pipeline . Please press enter" "kubectl apply -f ./manifests/hello-goodbye-pipeline.yaml"

# Step 3) Create PipelineRun for hello goodbye pipeline
section "Deploy pipelineRun - hello -> goodbye"
exec_not_visible_command "highlight_with_color_value \"$GRN\" \"Define pipelineRun as below. Enter Tekton as the username.\""
cat ./manifests/hello-goodbye-pipeline-run.yaml
info_pause_exec "Deploy hello-goodbye-pipeline-run. please press enter" "kubectl apply -f ./manifests/hello-goodbye-pipeline-run.yaml"

# Step 4) View Tekton UI
section "Check Tekton UI"
exec_not_visible_command "highlight_with_color_value \"$GRN\" \"Go to http://localhost:9097 and check Tekton - pipelineRun\""








