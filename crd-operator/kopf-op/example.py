import kopf
import kubernetes
import logging
import yaml

def __config_map_demo():
    buf = """apiVersion: v1
kind: ConfigMap
metadata:
  name: kops-demo
data:
  color: "blue"
"""
    data = yaml.safe_load(buf)
    print(data)
    api = kubernetes.client.CoreV1Api()
    api.create_namespaced_config_map(namespace="default",body=data)

@kopf.on.create('kopfexamples')
def create_fn(spec, **kwargs):
    try:
        __config_map_demo()
    except Exception as e:
        logging.error(str(e))
    logging.info(f"create_fn(): spec={spec}")
    return {'message': 'hello world'}  # will be the new status
