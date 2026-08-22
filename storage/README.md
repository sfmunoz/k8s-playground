# storage

## References

- [local-path-provisioner (rancher.io/local-path): use it to replace hardcoded routes](https://github.com/sfmunoz/i12e/issues/269)
  - https://github.com/rancher/local-path-provisioner
- [csi-rclone: create StorageClass and PersistentVolumeClaim](https://github.com/sfmunoz/i12e/issues/273)
  - https://www.veloxpack.io/docs/csi-driver-rclone/quick-start
  - https://www.veloxpack.io/docs/csi-driver-rclone/rclone-configuration
  - [https://www.veloxpack.io/docs/csi-driver-rclone/storageclass](https://www.veloxpack.io/docs/csi-driver-rclone/storageclass): be careful since `csi.storage.*` entries are not properly indented under `parameters`

## local-path-provisioner

From https://github.com/rancher/local-path-provisioner :

```
kubectl create -f https://raw.githubusercontent.com/rancher/local-path-provisioner/master/examples/pvc/pvc.yaml
kubectl create -f https://raw.githubusercontent.com/rancher/local-path-provisioner/master/examples/pod/pod.yaml
```

### pvc.yaml

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: local-path-pvc
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: local-path
  resources:
    requests:
      storage: 128Mi
```

### pod.yaml

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: volume-test
spec:
  containers:
  - name: volume-test
    image: nginx:stable-alpine
    imagePullPolicy: IfNotPresent
    volumeMounts:
    - name: volv
      mountPath: /data
    ports:
    - containerPort: 80
  volumes:
  - name: volv
    persistentVolumeClaim:
      claimName: local-path-pvc
```

## csi-rclone (Veloxpack)

[https://www.veloxpack.io/docs/csi-driver-rclone/storageclass](https://www.veloxpack.io/docs/csi-driver-rclone/storageclass): be careful since `csi.storage.*` entries are not properly indented under `parameters`:

```
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: rclone-csi
provisioner: rclone.csi.veloxpack.io
parameters:
  remote: "s3"
  remotePath: "my-bucket"
  csi.storage.k8s.io/node-publish-secret-name: "rclone-secret"
  csi.storage.k8s.io/node-publish-secret-namespace: "default"
reclaimPolicy: Delete
volumeBindingMode: Immediate
allowVolumeExpansion: true
```
