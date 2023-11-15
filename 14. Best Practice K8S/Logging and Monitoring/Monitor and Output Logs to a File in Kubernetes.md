# Monitor and Output Logs to a File in Kubernetes

![image](https://github.com/zulfikar4568/docker-kubernetes/assets/64786139/c9f30100-ca96-4096-b834-a77e026a1991)

Objective:
- Identify the problematic pod in your cluster.
- Collect the logs from the pod.
- Output the logs to a file.

## Identify the problematic pod in your cluster.
1. Use the following command to view all the pods in your cluster:
```bash
kubectl get pods --all-namespaces
```
## Collect the logs from the pod.
1. Use the following command to collect the logs from the broken pod:
```bash
kubectl logs <pod_name> -n <namespace_name>
```
## Output the logs to a file.
1. Use the following command to output the logs to a file:
```bash
kubectl logs <pod_name> -n <namespace_name> > broken-pod.log
```
