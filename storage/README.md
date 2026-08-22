# storage

## References

- [local-path-provisioner (rancher.io/local-path): use it to replace hardcoded routes](https://github.com/sfmunoz/i12e/issues/269)
  - https://github.com/rancher/local-path-provisioner
- [csi-rclone: create StorageClass and PersistentVolumeClaim](https://github.com/sfmunoz/i12e/issues/273)

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
