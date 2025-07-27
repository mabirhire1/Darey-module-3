
# Working with Kubernetes Pods and Containers

## Pods in Kubernetes

### Definition and Purpose
A Pod in Kubernetes is like a small container for running parts of an application. It can have one or more containers inside it that work closely together. These containers share the same network and storage, which makes them communicate and cooperate easily. A Pod is the smallest thing you can create and manage in Kubernetes. In Minkabe, which is a tool to run Kubernetes easily, Pods are used to set up, change the size, and control applications.

---

## Prerequisites

- Install Docker
- Install Minikube: https://minikube.sigs.k8s.io/docs/start/
- Install kubectl: https://kubernetes.io/docs/tasks/tools/

## Creating and Managing Pods:

Interaction with Pods in Minikube involves using the powerful kubectl command-line tool. kubectl is the command-line interface (CLI) tool for interacting with Kubernetes clusters. It allows users to deploy and manage applications, inspect and manage cluster resources, and execute various commands against Kubernetes clusters.

### Integrating Containers into Pods:

**Pod Definition with Containers:** In the Kubernetes world, containers come to life within Pods. Developers define a Pod YAML file that specifies the containers to run , their images, and other configuration details. This Pod becomes the unit of deployment, representing a cohesive application.

**Start Minikube:**

```bash
minikube start
```
### Step 1: Define a Pod with Containers

Create a file named `pod.yaml` with the following content:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: myapp-pod
  labels:
    app: myapp
spec:
  containers:
    - name: myapp-container
      image: nginx
      ports:
        - containerPort: 80
```

### Step 2: Deploy the Pod

Run the command below to apply the YAML configuration and deploy the Pod:

```bash
kubectl apply -f pod.yaml
```
**output**
```bash
pod/myapp-pod created
```
### Step 3: View Pods

List all running Pods:

```bash
kubectl get pods
```
**Output**
```bash
NAME         READY   STATUS    RESTARTS   AGE
myapp-pod    1/1     Running   0          10s
```

### Step 4: Inspect a Pod

To describe the Pod and get detailed info (like events, state, container logs):

```bash
kubectl describe pod myapp-pod
```
**Output**
```bash
Name:         myapp-pod
Namespace:    default
Priority:     0
Node:         minikube/192.168.49.2
Labels:       app=myapp
Status:       Running
IP:           10.244.0.12
Containers:
  myapp-container:
    Container ID:  docker://...
    Image:         nginx
    Port:          80/TCP
    State:         Running
    Started:       ...
Events:
  Type    Reason     Age   From               Message
  ----    ------     ----  ----               -------
  Normal  Scheduled  10s   default-scheduler  Successfully assigned default/myapp-pod to minikube
  Normal  Pulled     9s    kubelet            Successfully pulled image "nginx"
  Normal  Started    9s    kubelet            Started container myapp-container
```
### Step 5: Interact with the Pod

To execute commands inside the Pod:

```bash
kubectl exec -it myapp-pod -- /bin/bash
```
**Output**
```bash
error: Internal error occurred: error executing command in container: failed to exec in container: failed to start exec "bash": executable not found
---

This error occured because the official nginx Docker image does not include /bin/bash — it only includes /bin/sh.

**Working Alternative**
```bash
kubectl exec -it myapp-pod -- /bin/sh
```
**Output**
```bash
#
```
The shell prompt above will provide access inside the container, where you can run basic commands like ls, cat, curl, etc.

### Step 6: Delete the Pod

To delete the Pod:

```bash
kubectl delete pod myapp-pod
```
**Output**
```bash
pod "myapp-pod" deleted
```

## Notes

- Pods are **ephemeral** – changes made inside a running Pod will be lost if it’s deleted.
- Use **Deployments** for managing Pod replicas and auto-recovery.
- For persistent data, consider using **Volumes**.

## Conclusion

This guide demonstrated how to create, inspect, and delete Kubernetes Pods using `kubectl` on Minikube, including YAML configuration for defining containers inside a Pod.