#!/usr/bin/env bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

RELEASE_NAME=keda-issue-example
NAMESPACE=keda-issue-example-helm
CHART_FOLDER=helm-chart

echo "Cleaning previous installation ..."
helm --namespace=${NAMESPACE} uninstall ${RELEASE_NAME} || echo "Previous installation not found"

echo "Applying Helm Chart ..."
helm upgrade --install --namespace=${NAMESPACE} --create-namespace ${RELEASE_NAME} ${CHART_FOLDER}

echo "Sleep 2 seconds ..."
sleep 2

echo "Current HPA & ScaledObject status ..."
MAXREPLICAS_HPA=$(kubectl -n ${NAMESPACE} get hpa myapp -o=jsonpath='{.spec.maxReplicas}')
MAXREPLICAS_SCALEDOBJECT=$(kubectl -n ${NAMESPACE} get scaledobject myapp -o=jsonpath='{.spec.maxReplicaCount}')
[[ "${MAXREPLICAS_HPA}" == "10" || "${MAXRELICAS_SCALEDOBJECT}" == "10" ]] && echo -ne ${GREEN} || echo -ne ${RED}
echo "HorizontalPodAutoscaler maxReplicas=${MAXREPLICAS_HPA}"
echo "ScaledObject            maxReplicaCount=${MAXREPLICAS_SCALEDOBJECT}"
echo -ne ${NC}

echo "Changing ScaledObject maxReplicaCount to 5 ..."
kubectl --namespace=${NAMESPACE} patch scaledobject myapp --type merge -p '{"spec":{"maxReplicaCount":5}}'

echo "Sleep 2 seconds ..."
sleep 2

echo "Current HPA & ScaledObject status ..."
MAXREPLICAS_HPA=$(kubectl -n ${NAMESPACE} get hpa myapp -o=jsonpath='{.spec.maxReplicas}')
MAXREPLICAS_SCALEDOBJECT=$(kubectl -n ${NAMESPACE} get scaledobject myapp -o=jsonpath='{.spec.maxReplicaCount}')
[[ "${MAXREPLICAS_HPA}" == "5" || "${MAXRELICAS_SCALEDOBJECT}" == "5" ]] && echo -ne ${GREEN} || echo -ne ${RED}
echo "HorizontalPodAutoscaler maxReplicas=${MAXREPLICAS_HPA}"
echo "ScaledObject            maxReplicaCount=${MAXREPLICAS_SCALEDOBJECT}"
echo -ne ${NC}

echo "Reapplying Helm Chart ..."
helm upgrade --install --namespace=${NAMESPACE} ${RELEASE_NAME} ${CHART_FOLDER}

echo "Sleep 2 seconds ..."
sleep 2

echo "Current HPA & ScaledObject status ..."
MAXREPLICAS_HPA=$(kubectl -n ${NAMESPACE} get hpa myapp -o=jsonpath='{.spec.maxReplicas}')
MAXREPLICAS_SCALEDOBJECT=$(kubectl -n ${NAMESPACE} get scaledobject myapp -o=jsonpath='{.spec.maxReplicaCount}')
[[ "${MAXREPLICAS_HPA}" == "10" || "${MAXRELICAS_SCALEDOBJECT}" == "10" ]] && echo -ne ${GREEN} || echo -ne ${RED}
echo "HorizontalPodAutoscaler maxReplicas=${MAXREPLICAS_HPA}"
echo "ScaledObject            maxReplicaCount=${MAXREPLICAS_SCALEDOBJECT}"
echo -ne ${NC}
