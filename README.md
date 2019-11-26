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

### Further information

There are two apps deployed on the cluster: 

- A simple hello-world app (gcr.io/google-samples/hello-app:1.0) 
reachable through port 30000.
This app is deployed on a single pod, without autoscaling.

    ````
    curl -X GET http://localhost:30000 
    ````

- A web-app taken from `https://github.com/fperi/flask_docker`. 
This one is reachable through port 30001 and it has 2 endpoints:

    ````
    curl -X GET http://localhost:30001/
    ````
    
    ````
    curl -d "[1,2]" -X POST http://localhost:30001/sum_list
    ````
    
    The first is a health check. The second one corresponds to a simple python 
    script that performs the sum of the elements in a list.
    This web-app is deployed with an autoscaler that can create up to 5 pods. 

    If you want to see the autoscaler in action, open 2 terminals. 
    Use the first to go into the master node `vagrant ssh master`. 
    You can check the status of the cluster with: `kubectl get all`. You should 
    see a single node called `app`. In the second widow of the terminal 
    run `source test_autoscaling.sh`. This script will perform around 5000 
    request to the web-app. After a minute or so by calling `kubectl get all`, 
    you should see that the cluster has now 5 pods called `app`. Once the 
    requests have finished, wait for another couple of minutes and the cluster 
    will have destroyed the pods, and kept only one.

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

Check if api metrics are reachable:

````
kubectl get --raw /apis/metrics.k8s.io/v1beta1
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
