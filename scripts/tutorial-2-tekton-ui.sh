#!/bin/bash

# variables
CURR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )";

[ -d "$CURR_DIR" ] || { echo "FATAL: no current dir (maybe running in zsh?)";  exit 1; }
source "$CURR_DIR/common.sh";

start_message
new_line

# STEP 1) install tekton ui
section "install tekton-ui to your local kubernetes"
# This will install the Dashboard in read-only mode by default.
#Previous versions are available at previous/$VERSION_NUMBER/*.yaml, e.g. https://storage.googleapis.com/tekton-releases/dashboard/previous/v0.32.0/release.yaml
kubectl apply --filename https://storage.googleapis.com/tekton-releases/dashboard/latest/release-full.yaml
exec_not_visible_command "echo check tekton-ui running... &&\
                          kubectl -n tekton-pipelines wait --for=condition=Ready --timeout=30s -l app=tekton-dashboard pods &&\
                          highlight_with_color_value \"$GRN\" \"Successfully Deployed Tekton UI! \""

section "check your tekton-dashboard in browser"
kubectl --namespace tekton-pipelines port-forward svc/tekton-dashboard 9097:9097 &

exec_not_visible_command "highlight_with_color_value \"$GRN\" \"access : localhost:9097\""
exec_not_visible_command "highlight_with_color_value \"$GRN\" \"You have completed Tutorial 2 successfully. Please proceed to the next tutorial
 (make tutorial3) \""