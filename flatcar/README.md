# flatcar

- [References](#references)
- [Butane vs Ignition](#butane-vs-ignition)

## References

- https://www.flatcar.org/
- https://www.flatcar.org/docs/latest/installing/

## Butane vs Ignition

Ref: https://www.flatcar.org/docs/latest/installing/

**cl.yaml**:
```yaml
variant: flatcar
version: 1.0.0
systemd:
  units:
    - name: nginx.service
      enabled: true
      contents: |
        [Unit]
        Description=NGINX example
        After=docker.service
        Requires=docker.service
        [Service]
        TimeoutStartSec=0
        ExecStartPre=-/usr/bin/docker rm --force nginx1
        ExecStart=/usr/bin/docker run --name nginx1 --pull always --log-driver=journald --net host docker.io/nginx:1
        ExecStop=/usr/bin/docker stop nginx1
        Restart=always
        RestartSec=5s
        [Install]
        WantedBy=multi-user.target
```

Butane → Ignition:
```
cat cl.yaml | docker run --rm -i quay.io/coreos/butane:latest > ignition.json
```

`jq . < ignition.json`:
```json
{
  "ignition": {
    "version": "3.3.0"
  },
  "systemd": {
    "units": [
      {
        "contents": "[Unit]\nDescription=NGINX example\nAfter=docker.service\nRequires=docker.service\n[Service]\nTimeoutStartSec=0\nExecStartPre=-/usr/bin/docker rm --force nginx1\nExecStart=/usr/bin/docker run --name nginx1 --pull always --log-driver=journald --net host docker.io/nginx:1\nExecStop=/usr/bin/docker stop nginx1\nRestart=always\nRestartSec=5s\n[Install]\nWantedBy=multi-user.target\n",
        "enabled": true,
        "name": "nginx.service"
      }
    ]
  }
}
```

contents:
```
jq -r '.systemd.units[0].contents' < ignition.json
[Unit]
Description=NGINX example
After=docker.service
Requires=docker.service
[Service]
TimeoutStartSec=0
ExecStartPre=-/usr/bin/docker rm --force nginx1
ExecStart=/usr/bin/docker run --name nginx1 --pull always --log-driver=journald --net host docker.io/nginx:1
ExecStop=/usr/bin/docker stop nginx1
Restart=always
RestartSec=5s
[Install]
WantedBy=multi-user.target
```
