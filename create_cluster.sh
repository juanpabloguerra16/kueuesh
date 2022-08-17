#!/bin/bash
set -x

CLUSTER_NAME="$1"
CLUSTER_NAME="${CLUSTER_NAME:-demo}"
PROJECT_ID="${PROJECT_ID:-${USER}-gke-dev}"
REGION="${REGION:-us-central1}"
MACHINE_TYPE="${MACHINE_TYPE:-e2-standard-4}"
KUEUE_VERSION="${KUEUE_VERSION:-v0.1.1}"


gcloud container clusters create ${CLUSTER_NAME} --project=${PROJECT_ID} --region ${REGION} --machine-type ${MACHINE_TYPE} --release-channel rapid --cluster-version 1.24 --num-nodes 1 --node-labels spot=false --enable-autoscaling --max-nodes=10 --autoscaling-profile optimize-utilization

gcloud container node-pools create spot --cluster=${CLUSTER_NAME} --project=${PROJECT_ID} --region ${REGION} --node-labels spot=true --spot --enable-autoscaling --max-nodes=20 --num-nodes=0 --machine-type ${MACHINE_TYPE}

kubectl apply -f https://github.com/kubernetes-sigs/kueue/releases/download/${KUEUE_VERSION}/manifests.yaml

kubectl create namespace alpha
kubectl create namespace beta

kubectl apply -f flavors.yaml -f alpha.yaml -f beta.yaml -f spot.yaml
