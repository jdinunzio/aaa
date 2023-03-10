.PHONY: help cluster-create cluster-delete istio-install istio-ingress-gw-install
.PHONY: keycloak-install

# General Configuration
SHELL               := /bin/bash
CLUSTER_NAME = sso-cluster
CLUSTER_CONFIG_FILE = kind.config.yaml

help:                         ## Show this help
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'


install: cluster-create istio-install istio-ingress-gw-install


cluster-create:               ## Create a new k8s cluster
	@kind create cluster  --config ${CLUSTER_CONFIG_FILE}  --name ${CLUSTER_NAME}


cluster-delete:               ## Delete cluster
	@kind delete cluster --name ${CLUSTER_NAME}


istio-install:                ## Install istio
	@#helm repo add istio https://istio-release.storage.googleapis.com/charts
	@#helm repo update
	@kubectl create namespace istio-system
	@helm install istio-base istio/base -n istio-system --wait
	@helm install istiod istio/istiod -n istio-system --wait
	@#helm ls -n istio-system


istio-ingress-gw-install:     ## Install istio ingress gateway
	@kubectl create namespace istio-ingress
	@helm install istio-ingress istio/gateway -n istio-ingress --values istio-gateway.values.yaml --wait


keycloak-install:             ## Install keycloack
	@helm install mysso mysso/
	@kubectl apply -f gw-keycloak.yaml



