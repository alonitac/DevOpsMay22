#!/bin/bash

GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'
RED='\033[0;31m'

if [ -x /usr/local/bin/k0s ]; then
	sudo /usr/local/bin/k0s stop &> /dev/null
	sudo /usr/local/bin/k0s reset &> /dev/null
else

	curl -sSLf https://get.k0s.sh | sudo sh && echo "${CYAN}k0s downloaded${NC}"

fi


/usr/local/bin/k0s config create > k0s.yaml && printf "\n${CYAN}Cluster config filed created${NC}"
sudo /usr/local/bin/k0s install controller -c k0s.yaml --single && printf "\n\n${CYAN}K0s cluster has been installed${NC}"
sudo /usr/local/bin/k0s start && printf "\n\n${CYAN}K0s cluster has been started successfully!${NC}"

sleep 10

kubectl version --client &> /dev/null

if [ $? -ne 0 ]; then
	printf "\n\n${CYAN}Installing kubectl cli tool...${NC}\n\n"
	curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
	sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
fi

mkdir -p ~/.kube
sudo /usr/local/bin/k0s kubeconfig admin > ~/.kube/config

printf "\n\n${CYAN}Installing k8s dashboard${NC}\n\n"

kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.6.1/aio/deploy/recommended.yaml

cat > dashboard-admin-service-account.yaml <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: k0s-admin
  namespace: kube-system
---
apiVersion: v1
kind: Secret
type: kubernetes.io/service-account-token
metadata:
  name: k0s-admin-token
  namespace: kube-system
  annotations:
    kubernetes.io/service-account.name: "k0s-admin"
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: k0s-admin
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: k0s-admin
  namespace: kube-system
---
kind: Service
apiVersion: v1
metadata:
  labels:
    k8s-app: kubernetes-dashboard
  name: kubernetes-dashboard
  namespace: kubernetes-dashboard
spec:
  type: NodePort
  ports:
    - port: 443
      targetPort: 8443
      nodePort: 30001
  selector:
    k8s-app: kubernetes-dashboard
EOF


kubectl apply -f dashboard-admin-service-account.yaml
kubectl apply -f ecr-creds-helper.yaml

printf "\n\n${CYAN}Wait for k8s API server to sync...${NC}\n\n"
sleep 10

kubectl describe secret k0s-admin-token -n kube-system > dashboard-token.yaml


#IP=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)

printf "\n\n${RED}===========README===========${NC}"
printf "\n\n${GREEN}Cluster dashboard address is:  https://<ec2-public-ip>:30001 ${NC}\n\n"
printf "\n\n${GREEN}Access token is (can be always found in ~/dashboard-token.yaml):\n\n"
cat dashboard-token.yaml
printf "${NC}"

printf "\n\n${RED}Good Luck!${NC}\n"