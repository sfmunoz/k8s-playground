# CRD + Operator

- [References](#references)
- [CRD](#crd)

## References

- https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/
  Custom resources are extensions of the Kubernetes API.
- https://kubernetes.io/docs/concepts/extend-kubernetes/operator/
  Operators are software extensions to Kubernetes that make use of [custom resources](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/) to manage applications and their components. Operators follow Kubernetes principles, notably the [control loop](https://kubernetes.io/docs/concepts/architecture/controller/).

## CRD

Using provided **widget-rd.yaml** and **widgets.yaml**:
```
$ kubectl api-resources -o json | jq '.resources | length'
65

$ kubectl api-resources | awk '/^(NAME|widget)/'
NAME                                SHORTNAMES   APIVERSION                        NAMESPACED   KIND

$ kubectl apply -f widget-rd.yaml
customresourcedefinition.apiextensions.k8s.io/widgets.example.com created

$ kubectl api-resources -o json | jq '.resources | length'
66

$ kubectl api-resources | awk '/^(NAME|widget)/'
NAME                                SHORTNAMES   APIVERSION                        NAMESPACED   KIND
widgets                             wgt          example.com/v1alpha1              true         Widget
```
Add elements:
```
$ kubectl apply -f widgets.yaml
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
$ kubectl delete -f widgets.yaml
widget.example.com "small-6" deleted from default namespace
widget.example.com "medium-2" deleted from default namespace
widget.example.com "large-4" deleted from default namespace

$ kubectl delete -f widget-rd.yaml
customresourcedefinition.apiextensions.k8s.io "widgets.example.com" deleted
```
