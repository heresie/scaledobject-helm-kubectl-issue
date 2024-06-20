# Helm Bug Demonstration

This Repository contains test material to demonstrate Helm bug when deploying ScaledObject entities (Keda).

When a `ScaledObject` is updated directly with kubectl, the `spec.maxReplicaCount` is well updated.  
When a `ScaledObject` is updated through helm, the `spec.maxReplicaCount` is not updated at all.  

## Demo with `kubectl`

```
$ ./deploy-raw.sh
Cleaning previous installation ...
namespace "keda-issue-example" deleted
Applying manifests ...
namespace/keda-issue-example created
deployment.apps/myapp created
scaledobject.keda.sh/myapp created
Sleep 2 seconds ...
Current HPA & ScaledObject status ...
HorizontalPodAutoscaler maxReplicas=10
ScaledObject            maxReplicaCount=10
Changing ScaledObject maxReplicaCount to 5 ...
scaledobject.keda.sh/myapp patched
Sleep 2 seconds ...
Current HPA & ScaledObject status ...
HorizontalPodAutoscaler maxReplicas=5
ScaledObject            maxReplicaCount=5
Reapplying manifests ...
deployment.apps/myapp unchanged
scaledobject.keda.sh/myapp configured
Sleep 2 seconds ...
Current HPA & ScaledObject status ...
HorizontalPodAutoscaler maxReplicas=10
ScaledObject            maxReplicaCount=10
```

Conclusion: After re-applying the yaml manifests, the `ScaledObject` has been correctly updated and `spec.maxReplicaCount` is set to 10 as requested.

## Demo with `helm`

```
Cleaning previous installation ...
release "keda-issue-example" uninstalled
Applying Helm Chart ...
Release "keda-issue-example" does not exist. Installing it now.
NAME: keda-issue-example
LAST DEPLOYED: Thu Jun 20 09:55:45 2024
NAMESPACE: keda-issue-example-helm
STATUS: deployed
REVISION: 1
TEST SUITE: None
Sleep 2 seconds ...
Current HPA & ScaledObject status ...
HorizontalPodAutoscaler maxReplicas=10
ScaledObject            maxReplicaCount=10
Changing ScaledObject maxReplicaCount to 5 ...
scaledobject.keda.sh/myapp patched
Sleep 2 seconds ...
Current HPA & ScaledObject status ...
HorizontalPodAutoscaler maxReplicas=5
ScaledObject            maxReplicaCount=5
Reapplying Helm Chart ...
Release "keda-issue-example" has been upgraded. Happy Helming!
NAME: keda-issue-example
LAST DEPLOYED: Thu Jun 20 09:55:50 2024
NAMESPACE: keda-issue-example-helm
STATUS: deployed
REVISION: 2
TEST SUITE: None
Sleep 2 seconds ...
Current HPA & ScaledObject status ...
HorizontalPodAutoscaler maxReplicas=5
ScaledObject            maxReplicaCount=5
```

Conclusion: After re-applying the Helm Chart, the `ScaledObject` should have `spec.maxReplicaCount` updated to the original value (10), but the value is not updated (5).

---
EOF
