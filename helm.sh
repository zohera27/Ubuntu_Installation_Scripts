						Helm Installation in Ubuntu

Method 1 – From Script

curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3

chmod 700 get_helm.sh 

./get_helm.sh 

Helm Version

Method 2 – From Apt (Debian/Ubuntu)

curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null

sudo apt-get install apt-transport-https --yes

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list

sudo apt-get update

sudo apt-get install helm
Helm Version


					Prometheus & Grafana Installation using Helm Chart

Method 1 – Helm

1. helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

2. helm repo update

3. helm install prometheus prometheus-community/prometheus

4. kubectl gets pods (see if the Prometheus pods are running)

5. kubectl get svc (you need to expose the Prometheus server)

6. So, we will convert ClusterIP to Nodeport

7. kubectl expose service prometheus-server –-type=NodePort –-target-port=9090 --name=prometheus-server-NodePort

Note – Check if the same name Prometheus-server is there in your kubectl get svc

8. kubectl get svc (you will see the new svc Prometheus-server-NodePort)

9. Open the URL with NodePort Port Number

10. Sample Prometheus Queries:


Now Grafana installation using Helm

1. helm repo add grafana https://grafana.github.io/helm-charts

2. helm repo update

3. helm install grafana grafana/grafana

4. kubectl get secret –namespace default grafana -o jsonpath=”{.data.admin-password}” | base64 –decode ; echo

username – admin

5. kubectl expose service grafana --type=NodePort --target-port=3000 --name=Grafana-server-NodePort

6. kubectl get svc (Make a note of Nodeport)

Now in Grafana, add a Datasource -> Prometheus ->ip address of Prometheus

Import the Dashboard with 32262 or 6417	

Method 2 – Operator: Need to Check
