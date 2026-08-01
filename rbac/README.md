# RBAC: Role-based access control

## References

- https://kubernetes.io/docs/reference/access-authn-authz/rbac/
- https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-v1/
- [Kubernetes RBAC Explained](https://www.youtube.com/watch?v=iE9Qb8dHqWI)

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

## Client auth example

Generate **user1.key** and **user1.crt** in the **Flatcar + K3s** node (make sure to use **O=system:masters**):

```
core@n0007 ~ $ openssl genrsa -out user1.key 2048

core@n0007 ~ $ openssl req -new -key user1.key -out user1.csr -subj "/CN=user1/O=system:masters"

core@n0007 ~ $ sudo openssl x509 -req \
  -in user1.csr \
  -CA /var/lib/rancher/k3s/server/tls/client-ca.crt \
  -CAkey /var/lib/rancher/k3s/server/tls/client-ca.key \
  -CAcreateserial \
  -out user1.crt \
  -days 365
Certificate request self-signature ok
subject=CN=user1, O=system:masters
```

Update **~/.kube/config** using `kube config ...` commands (192.168.56.51 is the IP of the **Flatcar + K3s** node the certificate was generated at):

```
$ ssh core@192.168.56.51 'sudo cat /etc/rancher/k3s/k3s.yaml' > ~/.kube/config

$ kubectl config get-contexts
CURRENT   NAME      CLUSTER   AUTHINFO   NAMESPACE
*         default   default   default

$ kubectl config get-users
NAME
default

$ kubectl config set-credentials user1 --client-certificate=user1.crt --client-key=user1.key --embed-certs=true
User "user1" set.

$ kubectl config get-contexts
CURRENT   NAME      CLUSTER   AUTHINFO   NAMESPACE
*         default   default   default

$ kubectl config get-users
NAME
default
user1

$ kubectl config set-context ctx1 --user=user1 --cluster=default
Context "ctx1" created.

$ kubectl config get-contexts
CURRENT   NAME      CLUSTER   AUTHINFO   NAMESPACE
          ctx1      default   user1
*         default   default   default

$ kubectl auth whoami
ATTRIBUTE                                           VALUE
Username                                            system:admin
Groups                                              [system:masters system:authenticated]
Extra: authentication.kubernetes.io/credential-id   [X509SHA256=4b4de9f2...]

$ kubectl config use-context ctx1
Switched to context "ctx1".

$ kubectl config get-contexts
CURRENT   NAME      CLUSTER   AUTHINFO   NAMESPACE
*         ctx1      default   user1
          default   default   default

$ kubectl auth whoami
ATTRIBUTE                                           VALUE
Username                                            user1
Groups                                              [system:masters system:authenticated]
Extra: authentication.kubernetes.io/credential-id   [X509SHA256=85525dcd...]
```
