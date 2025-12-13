# CRD + Operator

- [References](#references)
- [CRD](#crd)
- [Operator](#operator)
  - [Kopf](#kopf)

## References

- https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/
  Custom resources are extensions of the Kubernetes API.
- https://kubernetes.io/docs/concepts/extend-kubernetes/operator/
  Operators are software extensions to Kubernetes that make use of [custom resources](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/) to manage applications and their components. Operators follow Kubernetes principles, notably the [control loop](https://kubernetes.io/docs/concepts/architecture/controller/).
- [https://operatorhub.io/](https://operatorhub.io/): OperatorHub.io is a new home for the Kubernetes community to share Operators. Find an existing Operator or list your own today.

## CRD

Using provided **widget-rd.yaml** and **widgets.yaml**:
```
$ kubectl api-resources -o json | jq '.resources | length'
65

$ kubectl api-resources | awk '/^(NAME|widget)/'
NAME                                SHORTNAMES   APIVERSION                        NAMESPACED   KIND

$ kubectl apply -f raw-op/widget-rd.yaml
customresourcedefinition.apiextensions.k8s.io/widgets.example.com created

$ kubectl api-resources -o json | jq '.resources | length'
66

$ kubectl api-resources | awk '/^(NAME|widget)/'
NAME                                SHORTNAMES   APIVERSION                        NAMESPACED   KIND
widgets                             wgt          example.com/v1alpha1              true         Widget
```
Add elements:
```
$ kubectl apply -f raw-op/widgets.yaml
widget.example.com/small-6 created
widget.example.com/medium-2 created
widget.example.com/large-4 created

$ kubectl get widgets.example.com
NAME       SIZE     REPLICAS   COLOR
large-4    large    4
medium-2   medium   2
small-6    small    6          blue
```
Cleanup:
```
$ kubectl delete -f raw-op/widgets.yaml
widget.example.com "small-6" deleted from default namespace
widget.example.com "medium-2" deleted from default namespace
widget.example.com "large-4" deleted from default namespace

$ kubectl delete -f raw-op/widget-rd.yaml
customresourcedefinition.apiextensions.k8s.io "widgets.example.com" deleted
```
## Operator
From [https://kubernetes.io/docs/concepts/extend-kubernetes/operator/](https://kubernetes.io/docs/concepts/extend-kubernetes/operator/):

- [Charmed Operator Framework](https://juju.is/)
- [Java Operator SDK](https://github.com/operator-framework/java-operator-sdk)
- **[Kopf](https://github.com/nolar/kopf) (Kubernetes Operator Pythonic Framework)**
- [kube-rs](https://kube.rs/) (Rust)
- [kubebuilder](https://book.kubebuilder.io/)
- [KubeOps](https://dotnet.github.io/dotnet-operator-sdk/) (.NET operator SDK)
- [Mast](https://docs.ansi.services/mast/user_guide/operator/)
- [Metacontroller](https://metacontroller.github.io/metacontroller/intro.html) along with WebHooks that you implement yourself
- [Operator Framework](https://operatorframework.io/)
- [shell-operator](https://github.com/flant/shell-operator)

### Kopf

Refs:

- https://kopf.readthedocs.io/en/stable/install/
- https://github.com/nolar/kopf
  - https://github.com/nolar/kopf/tree/main/examples/01-minimal

Execution:
```
$ ./kopf-op/run.sh
```
Details:
- python virtualenv is created with Kopf installed
- CRDs are applied to the cluster
- Kopf is executed
- kubectl apply/delete executed to show Kopf behaviour
