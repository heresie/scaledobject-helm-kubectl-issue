#!/usr/bin/env bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

NAMESPACE=keda-issue-example
RAW_YAML=helm-chart/templates/

echo "Cleaning previous installation ..."
kubectl delete namespace ${NAMESPACE} || echo "Previous installation not found"

echo "Applying manifests ..."
kubectl create namespace ${NAMESPACE}
kubectl --namespace=${NAMESPACE} apply -f ${RAW_YAML}

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

echo "Reapplying manifests ..."
kubectl --namespace=${NAMESPACE} apply -f ${RAW_YAML}

echo "Sleep 2 seconds ..."
sleep 2

echo "Current HPA & ScaledObject status ..."
MAXREPLICAS_HPA=$(kubectl -n ${NAMESPACE} get hpa myapp -o=jsonpath='{.spec.maxReplicas}')
MAXREPLICAS_SCALEDOBJECT=$(kubectl -n ${NAMESPACE} get scaledobject myapp -o=jsonpath='{.spec.maxReplicaCount}')
[[ "${MAXREPLICAS_HPA}" == "10" || "${MAXRELICAS_SCALEDOBJECT}" == "10" ]] && echo -ne ${GREEN} || echo -ne ${RED}
echo "HorizontalPodAutoscaler maxReplicas=${MAXREPLICAS_HPA}"
echo "ScaledObject            maxReplicaCount=${MAXREPLICAS_SCALEDOBJECT}"
echo -ne ${NC}
