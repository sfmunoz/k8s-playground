# pip install kubernetes
from time import sleep
from kubernetes import client as kcli, config as kcfg

try:
    kcfg.load_incluster_config()
except:
    kcfg.load_kube_config()

class RawOp(object):
    def __init__(self):
        self.__crd_api = kcli.CustomObjectsApi()
        self.__core_api = kcli.CoreV1Api()
        self.__group = "example.com"
        self.__version = "v1alpha1"
        self.__namespace = "default"
        self.__plural = "widgets"

    def __reconcile(self):
        apps = self.__crd_api.list_namespaced_custom_object(self.__group,self.__version,self.__namespace,self.__plural)
        for app in apps.get("items", []):
            name = app["metadata"]["name"]
            print(name)
            message = app.get("spec", {}).get("message", "hello")
            cm_name = f"{name}-config"
            try:
                self.__core_api.read_namespaced_config_map(cm_name,self.__namespace)
            except kcli.exceptions.ApiException as e:
                if e.status != 404:
                    print("{0}: status = {1}".format(name,e.status))
                    continue
                print("{0}: creating ConfigMap".format(name))
                body = kcli.V1ConfigMap(
                    metadata = kcli.V1ObjectMeta(name=cm_name),
                    data = {"message": message},
                )
                self.__core_api.create_namespaced_config_map(namespace=self.__namespace,body=body)

    def run(self):
        slumber = 3
        while True:
            self.__reconcile()
            print("sleeping {0}s...".format(slumber))
            sleep(slumber)

if __name__ == "__main__":
    RawOp().run()
