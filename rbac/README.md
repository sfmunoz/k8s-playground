# rbac

- [References](#references)
- [Usage](#usage)

## References

- https://kubernetes.io/docs/reference/access-authn-authz/rbac/
- https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-v1/

## Usage

Install:
```
$ helm upgrade --install -n rbac --create-namespace rbac rbac
```
Check:
```
$ kubectl logs -n rbac pod-reader -f
(...)
1766157225.3664873 pod-reader | Running | 10.42.0.96
1766157225.375102 ----
1766157226.3887348 pod-reader | Running | 10.42.0.96
1766157226.3911226 ----
1766157227.4056594 pod-reader | Running | 10.42.0.96
1766157227.407509 ----
(...)
```
Uninstall:
```
$ helm uninstall -n rbac rbac
$ kubectl delete namespaces rbac
```
