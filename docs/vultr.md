# Vultr

## Vultr

Ref: https://www.vultr.com/

Instance creation with **Debian 13** and **k3s** installed (plan/region/OS/script/ssh-key details follow):
```
$ vultr-cli instance create -r mad -p vc2-1c-2gb --os 2625 --script-id 402931bb-6d73-4b19-9b71-857da8951f0d -s dea4ebd6-c439-497f-a145-761cfa9ce68b
```
ssh shortcut to use **kubectl** from the local computer (it can be used from within the instance too):
```
$ vultr-cli instance list
ID                                      IP              LABEL   OS                      STATUS  REGION  CPU     RAM     DISK    BANDWIDTH       TAGS
(...)
0768fad1-a988-4362-9357-0554659bd854    208.76.222.72           Debian 13 x64 (trixie)  active  mad     1       2048    55      3               []
(...)

$ scp root@208.76.222.72:/etc/rancher/k3s/k3s.yaml ~/.kube/config

$ ssh -L 6443:127.0.0.1:6443 root@208.76.222.72
```
Plan:
```
$ vultr-cli plans list
ID                              VCPU COUNT      RAM     DISK    DISK COUNT      BANDWIDTH GB    PRICE PER MONTH         TYPE    GPU VRAM        GPU TYPE        REGIONS
(...)
vc2-1c-2gb                      1               2048    55      1               2048            10.00                   vc2     0                               [ewr, ord, dfw, sea, lax, atl, ams, lhr, fra, sjc, syd, yto, cdg, nrt, waw, mad, icn, mia, sgp, sto, mex, mel, bom, jnb, tlv, blr, del, scl, itm, man]
(...)
```
Region:
```
$ vultr-cli regions list
ID      CITY            COUNTRY         CONTINENT       OPTIONS
(...)
mad     Madrid          ES              Europe          [ddos_protection, block_storage_storage_opt, load_balancers, kubernetes]
(...)
```
OS:
```
$ vultr-cli os list
ID      NAME                                    ARCH    FAMILY
(...)
2625    Debian 13 x64 (trixie)                  x64     debian
(...)
```
Script:
```
$ vultr-cli script list
ID                                      DATE CREATED                    DATE MODIFIED                   TYPE    NAME
(...)
402931bb-6d73-4b19-9b71-857da8951f0d    2025-09-19T08:03:30+00:00       2025-09-19T08:15:53+00:00       boot    k3s
(...)
```
ssh-key:
```
$ vultr-cli ssh-key list
ID                                      DATE CREATED                    NAME    KEY
(...)
dea4ebd6-c439-497f-a145-761cfa9ce68b    2025-..-..T..:..:..+..:..       sfm     ssh-rsa AAAA...g3uDkQ== sfm
```
