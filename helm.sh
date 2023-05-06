						Helm Installation in Ubuntu

Method 1 – From Script

curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3

chmod 700 get_helm.sh 

./get_helm.sh 

helm Version

Method 2 – From Apt (Debian/Ubuntu)

curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null

sudo apt-get install apt-transport-https --yes

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list

sudo apt-get update

sudo apt-get install helm
helm Version


					Prometheus & Grafana Installation using Helm Chart

Method 1 – Helm

1. helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

2. helm repo update

3. helm install prometheus prometheus-community/prometheus

4. kubectl gets pods (see if the Prometheus pods are running)

5. kubectl get svc (you need to expose the Prometheus server)

6. So, we will convert ClusterIP to Nodeport

7. kubectl expose service prometheus-server --type=NodePort --target-port=9090 --name=prometheus-server-nodeport


Note – Check if the same name Prometheus-server is there in your kubectl get svc

8. kubectl get svc (you will see the new svc Prometheus-server-NodePort)

9. Open the URL with NodePort Port Number

10. Sample Prometheus Queries:






Important Note – if you face any issues like Persistent Volume in Prometheus then follow below steps:

apiVersion: v1
kind: PersistentVolume
metadata:
  name: prometheus-pv
spec:
  capacity:
    storage: 8Gi
  accessModes:
    - ReadWriteOnce
  storageClassName: local-storage
  hostPath:
    path: "/mnt/PrometheusVolume"

-------------

apiVersion: v1
kind: PersistentVolume
metadata:
  name: alertmanager-pv
spec:
  capacity:
    storage: 2Gi
  accessModes:
    - ReadWriteOnce
  storageClassName: local-storage
  hostPath:
    path: "/mnt/StorageVolume"

Next File: is PersistentVolumeClaims

apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: storage-prometheus-alertmanager-0
  namespace: default
  labels:
    app.kubernetes.io/name: alertmanager
    app.kubernetes.io/instance: prometheus
  finalizers:
    - kubernetes.io/pvc-protection
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 2Gi
  volumeMode: Filesystem
  storageClassName: local-storage
  volumeName: alertmanager-pv

----------

apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: prometheus-server
  namespace: default
  labels:
    app.kubernetes.io/name: prometheus
    app.kubernetes.io/component: server
    app.kubernetes.io/part-of: prometheus
    app.kubernetes.io/version: v2.43.0
    app.kubernetes.io/instance: prometheus
    app.kubernetes.io/managed-by: Helm

  finalizers:
    - kubernetes.io/pvc-protection
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 8Gi
  volumeMode: Filesystem
  storageClassName: local-storage
  volumeName: prometheus-pv
>>>>>>>>>>>>>>>

kubectl patch pvc storage-prometheus-alertmanager-0 -p '{"spec":{"volumeName":"alertmanager-pv"}}'
kubectl patch pvc storage-prometheus-alertmanager-0 -p '{"spec":{"storageClassName":"local-storage"}}'

kubectl create sa my-service-account
kubectl create clusterrolebinding my-service-account-binding --clusterrole=view --serviceaccount=default:my-service-account

Now Grafana installation using Helm

1. helm repo add grafana https://grafana.github.io/helm-charts

2. helm repo update

3. helm install grafana grafana/grafana

4. kubectl get secret --namespace default grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo

username – admin

5. kubectl expose service grafana --type=NodePort --target-port=3000 --name=Grafana-server-NodePort

6. kubectl get svc (Make a note of Nodeport)

Now in Grafana, add a Datasource -> Prometheus ->ip address of Prometheus

Import the Dashboard with 32262 or 6417

Important Notes you can Check optionally

Get the Alertmanager URL by running these commands in the same shell:
  export POD_NAME=$(kubectl get pods --namespace default -l "app=prometheus,component=" -o jsonpath="{.items[0].metadata.name}")
  kubectl --namespace default port-forward $POD_NAME 9093


Get the PushGateway URL by running these commands in the same shell:
  export POD_NAME=$(kubectl get pods --namespace default -l "app=prometheus-pushgateway,component=pushgateway" -o jsonpath="{.items[0].metadata.name}")
  kubectl --namespace default port-forward $POD_NAME 9091
  
  
  Get the Grafana URL to visit by running these commands in the same shell:
     export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=grafana,app.kubernetes.io/instance=grafana" -o jsonpath="{.items[0].metadata.name}")
     kubectl --namespace default port-forward $POD_NAME 3000
     

To uninstall 

helm uninstall prometheus --namespace default && kubectl delete pvc -l release=prometheus --namespace default


Method 2 – Operator: Need to Check
