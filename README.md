## Example on how to setup a Kubernetes cluster with autoscaling

This is a short example that shows how to setup a local kubernetes cluster using Vagrant and Ansible.

### Kubernetes

Kubernetes is a container ochestrator that lets you deploy, change and recover fast. You only job in k8s
is to declare the desired state in which you want your cluster to stay and then k8s will take care
of making that happen.

Kubernetes deploys docker containers in "pods", on the available nodes that compose the cluster.
It can allocate more or less pods scaling accordingly to the resources needed.

Kubernetes can be installed on-premise (as we do here) or on the cloud. Installing it from scratch is painful, therefore either one uses pre-installed versions on AWS or Google Cloud, or one exploit programs 
like kubeadm. Using kubeadm, one can install k8s, create the cluster, configure the networking between nodes and join them to the cluster quite easily.

### What's needed

You need Vagrant and Ansible installed on your system. Then, everything should run as soon as you type:

````
vagrant up
````

After around 60 seconds, you should be able to check that the cluster is working by calling:

````
curl -X GET http://localhost:30000 
````

Kill your vagrant machine with:

````
vagrant halt
vagrant destroy
````

### Tips and tricks

Inspecting your cluster:

````
kubectl cluster-info
````

Get all resources:

````
kubectl get all
````

Get nodes:

````
kubectl get nodes
````

Get info on a resources:

````
kubectl explain pod
````

Get detailed information on something:

````
kubectl describe nodes master
````

Update configuration:

````
kubectl apply -f deployment.yml
````

Monitor performances (requires the metric-server):

````
kubectl top pods
````

Delete service and deployment:

````
kubectl delete deployment name-of-deplyment
kubectl delete service name-of-service
````


### Useful documentation

````
https://kubernetes.io/blog/2019/03/15/kubernetes-setup-using-ansible-and-vagrant/

https://medium.com/@dstrimble/kubernetes-horizontal-pod-autoscaling-for-local-development-d211e52c309c

https://github.com/kelseyhightower/kubernetes-the-hard-way

https://github.com/kubernetes-sigs/metrics-server

https://github.com/kubernetes-sigs/metrics-server/issues/278
````
