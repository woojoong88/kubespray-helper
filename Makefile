KUBESPRAY_VERSION ?= master
LOCAL_PATH_PROVISIONER_VERSION ?= master
CNI ?= calico

deploy-kubernetes:
	rm -rf build/kubespray-configs/group_vars
	mkdir -p workspace
	cd workspace; git clone https://github.com/kubernetes-sigs/kubespray.git -b $(KUBESPRAY_VERSION) kubespray || true
	cp build/configs/inventory.ini workspace/kubespray/inventory/sample/inventory.ini
	cd workspace; virtualenv venv
	cd workspace && source venv/bin/activate && cd kubespray && pip install -r requirements.txt && ansible-playbook -b -i inventory/sample/inventory.ini \
		-e "{'override_system_hostname' : False, 'disable_swap' : True}" \
		-e "{'kube_network_plugin_multus' : True, 'multus_version' : stable, 'multus_cni_version' : 0.3.1}" \
		-e "{'kube_network_plugin' : "${CNI}"}" \
		-e "{'cilium_cni_exclusive' : False}" \
		-e "{'kubeadm_enabled': True}" \
		-e "{'kube_pods_subnet' : 192.168.0.0/17, 'kube_service_addresses' : 192.168.128.0/17}" \
		-e "{'kube_apiserver_node_port_range' : 2000-36767}" \
		-e "{'dns_min_replicas' : 1}" \
		cluster.yml -vvv

deploy-local-path-provisioner:
	mkdir -p workspace
	cd workspace; git clone https://github.com/rancher/local-path-provisioner.git -b $(LOCAL_PATH_PROVISIONER_VERSION) local-path-provisioner || true
	cd workspace/local-path-provisioner && helm install local-path-storage --namespace local-path-storage ./deploy/chart/local-path-provisioner --create-namespace

clean:
	cp build/configs/inventory.ini workspace/kubespray/inventory/sample/inventory.ini
	cd workspace; virtualenv venv
	cd workspace && source venv/bin/activate && cd kubespray && pip install -r requirements.txt && ansible-playbook --extra-vars "reset_confirmation=yes" -b -i inventory/sample/inventory.ini reset.yml
	rm -rf workspace