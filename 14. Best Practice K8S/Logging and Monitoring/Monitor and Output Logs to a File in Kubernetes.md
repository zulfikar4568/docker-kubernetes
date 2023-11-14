# Monitor and Output Logs to a File in Kubernetes

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