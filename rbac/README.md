# RBAC: Role-based access control

## References

- https://kubernetes.io/docs/reference/access-authn-authz/rbac/
- https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-v1/
- [Kubernetes RBAC Explained](https://www.youtube.com/watch?v=iE9Qb8dHqWI)
- [RoleBinding examples → subjects](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#role-binding-examples)
  - kind:User + name:user + apiGroup:rbac.authorization.k8s.io
  - kind:Group + name:developers + apiGroup:rbac.authorization.k8s.io
  - kind:ServiceAccount + name:system:serviceaccounts:qa + apiGroup:rbac.authorization.k8s.io
  - kind:Group + name:system:serviceaccounts + apiGroup:rbac.authorization.k8s.io
  - kind:Group + name:system:authenticated + apiGroup:rbac.authorization.k8s.io
  - kind:Group + name:system:unauthenticated + apiGroup:rbac.authorization.k8s.io

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

## User impersonation

```
$ kubectl auth whoami
ATTRIBUTE                                           VALUE
Username                                            system:admin
Groups                                              [system:masters system:authenticated]
Extra: authentication.kubernetes.io/credential-id   [X509SHA256=4b4de9f2...]

$ kubectl auth whoami --as=system:serviceaccount:i12e:default
ATTRIBUTE   VALUE
Username    system:serviceaccount:i12e:default
Groups      [system:serviceaccounts system:serviceaccounts:i12e system:authenticated]
```

## Service account + token client authentication

The key here is `kubectl create token ...`: it's meant to create a token associated to the specified serviceaccount:

```
$ ssh core@192.168.56.51 'sudo cat /etc/rancher/k3s/k3s.yaml' > ~/.kube/config

$ kubectl config get-contexts
CURRENT   NAME      CLUSTER   AUTHINFO   NAMESPACE
*         default   default   default

$ kubectl config get-users
NAME
default

$ kubectl config set-credentials sa-i12e-default --token=$(kubectl create token -n i12e default)
User "sa-i12e-default" set.

$ kubectl config get-contexts
CURRENT   NAME      CLUSTER   AUTHINFO   NAMESPACE
*         default   default   default

$ kubectl config get-users
NAME
default
sa-i12e-default

$ kubectl config set-context sa-i12e-ctx --user=sa-i12e-default --cluster=default
Context "sa-i12e-ctx" created.

$ kubectl config get-contexts
CURRENT   NAME          CLUSTER   AUTHINFO          NAMESPACE
*         default       default   default
          sa-i12e-ctx   default   sa-i12e-default

$ kubectl config use-context sa-i12e-ctx
Switched to context "sa-i12e-ctx".

$ kubectl config get-contexts
CURRENT   NAME          CLUSTER   AUTHINFO          NAMESPACE
          default       default   default
*         sa-i12e-ctx   default   sa-i12e-default

$ kubectl auth whoami
ATTRIBUTE                                           VALUE
Username                                            system:serviceaccount:i12e:default
UID                                                 31a55b72...
Groups                                              [system:serviceaccounts system:serviceaccounts:i12e system:authenticated]
Extra: authentication.kubernetes.io/credential-id   [JTI=48cc355d...]

$ kubectl get pods -A
Error from server (Forbidden): pods is forbidden: User "system:serviceaccount:i12e:default" cannot list resource "pods" in API group "" at the cluster scope

$ kubectl get pods
Error from server (Forbidden): pods is forbidden: User "system:serviceaccount:i12e:default" cannot list resource "pods" in API group "" in the namespace "default"
```

## Certificate based client authentication

### Certificate creation

#### Option 1: O="anything" except for O=systems:masters

Attempts to create **O=systems:masters** users raise **forbidden errors** when using this method. There's no need to log in to the control panel since everything is done on the client side:

```
$ kubectl auth whoami
ATTRIBUTE                                           VALUE
Username                                            system:admin
Groups                                              [system:masters system:authenticated]
Extra: authentication.kubernetes.io/credential-id   [X509SHA256=4b4de9f2...]

$ openssl genrsa -out user1.key 2048

$ openssl req -new -key user1.key -out user1.csr -subj "/CN=user1/O=developers"

$ kubectl get csr -A
No resources found

$ cat <<EOF | kubectl apply -f -
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: user1
spec:
  request: $(base64 -w0 user1.csr)
  signerName: kubernetes.io/kube-apiserver-client
  expirationSeconds: $((365*24*60*60))
  usages:
  - client auth
EOF
certificatesigningrequest.certificates.k8s.io/user1 created

$ kubectl get csr -A
NAME    AGE   SIGNERNAME                            REQUESTOR      REQUESTEDDURATION   CONDITION
user1   9s    kubernetes.io/kube-apiserver-client   system:admin   365d                Pending

$ kubectl certificate approve user1
certificatesigningrequest.certificates.k8s.io/user1 approved

$ kubectl get csr user1
NAME    AGE     SIGNERNAME                            REQUESTOR      REQUESTEDDURATION   CONDITION
user1   2m59s   kubernetes.io/kube-apiserver-client   system:admin   365d                Approved,Issued

$ kubectl get csr user1 -o jsonpath='{ .status.certificate }' | base64 -d > user1.crt
```

#### Option 2: only if O=systems:masters is required

Generate **user1.key** and **user1.crt** in the **Flatcar + K3s** node:

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

### ~/.kube/config setup

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

### ClusterRoleBinding: ClusterRole=cluster-admin → Group=system:masters

```yaml
$ kubectl get clusterrolebindings.rbac.authorization.k8s.io cluster-admin -o yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  annotations:
    rbac.authorization.kubernetes.io/autoupdate: "true"
  creationTimestamp: "2026-07-29T17:07:19Z"
  labels:
    kubernetes.io/bootstrapping: rbac-defaults
  name: cluster-admin
  resourceVersion: "136"
  uid: 53713704-c6b6-4694-be01-d85c5936b1cb
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- apiGroup: rbac.authorization.k8s.io
  kind: Group
  name: system:masters
```
