#!/bin/bash

# variables
CURR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )";

[ -d "$CURR_DIR" ] || { echo "FATAL: no current dir (maybe running in zsh?)";  exit 1; }
source "$CURR_DIR/common.sh";

start_message
new_line

# STEP 1) start minikube kubernetes
section "create local cluster by using minikube"
minikube start --kubernetes-version v1.24.4

# STEP 2) check cluster-info
section "Check successfully started kubernetes cluster"
info_pause_exec "Check the cluster list to see if the cluster was successfully created. [Please Enter]" "kubectl cluster-info"

# STEP 3) install tekton Pipelines
section "install tekton pipelines"
info_pause_exec "install tekton pipelines [please enter]" "kubectl apply --filename https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml"
exec_not_visible_command "echo check tekton running... &&\
                          kubectl -n tekton-pipelines wait --for=condition=Ready --timeout=1200s -l app=tekton-pipelines-controller pods &&\
                          highlight_with_color_value \"$GRN\" \"Successfully Deployed Tekton Pipelines! \""
exec_not_visible_command "kubectl label --overwrite ns tekton-pipelines pod-security.kubernetes.io/enforce=privileged"

# STEP 4) deploy simple task resource
section "deploy simple task resource"
exec_not_visible_command "echo Let's deploy a simple hello world task resource like below to Kubernetes &&\
                          cat ./manifests/hello-task.yaml"
new_line
info_pause_exec "Press Enter to deploy the next command" "kubectl apply -f ./manifests/hello-task.yaml"

# STEP 5) Deploy TaskRun
section "deploy taskRun for running simple task"
exec_not_visible_command "echo Deployed task resource. Now let's deploy the TaskRun resource to run the task. &&\
                          cat ./manifests/hello-taskrun.yaml"
new_line
info_pause_exec "Press Enter to deploy the next command" "kubectl apply -f ./manifests/hello-taskrun.yaml"
exec_not_visible_command "echo check taskrun completed... &&\
                          kubectl -n tekton-pipelines wait --for=condition=Succeeded --timeout=30s --selector=tekton.dev/task=hello taskrun &&\
                          kubectl -n tekton-pipelines logs --selector=tekton.dev/taskRun=hello-task-run"

exec_not_visible_command "highlight_with_color_value \"$GRN\" \"congratulations! Onbaord has been executed successfully. Please proceed to the next tutorial (tutorial2) \""