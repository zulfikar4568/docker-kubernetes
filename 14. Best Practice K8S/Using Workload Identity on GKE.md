# Using Workload Identity on GKE

Running workloads with their own unique service identity in GCP allows you to exercise the security principle of least privilege: granting only the granular permissions required by a workload, and limiting the blast radius should it become compromised. With GKE Workload Identity, Kubernetes service accounts can be mapped to GCP service accounts to enable service identity authorization for requests to Google APIs and other services. In this lab, we will create a secret Cloud Run service and then map a service account to allow a GKE workload to access it.

## Deploy the Secret Service to Cloud Run
1. From the GCP console, click the Activate Cloud Shell icon (>_) to the right of the top menu.

2. When prompted, click CONTINUE.

3. In the Cloud Shell terminal, enable the required APIs for this lab:
```bash
gcloud services enable container.googleapis.com containerregistry.googleapis.com cloudbuild.googleapis.com run.googleapis.com
```
   - Note: If prompted, click AUTHORIZE to authorize API calls.

4. Clone the GitHub repo provided for this lab:
```bash
git clone https://github.com/linuxacademy/content-google-certified-pro-cloud-developer
```
5. Change to the GitHub repo's gke-workload-identity/secret-service directory:
```bash
cd content-google-certified-pro-cloud-developer/gke-workload-identity/secret-service/
```
6. From the directory, build the Secret service container, replacing <YOUR_PROJECT_ID> with your own project ID (the yellow text shown in the terminal):
```bash
gcloud builds submit --tag gcr.io/<YOUR_PROJECT_ID>/secret-service
```
7. Deploy the container to Cloud Run, again substituting your project ID:
```bash
gcloud run deploy secret-service --image gcr.io/<YOUR_PROJECT_ID>/secret-service --no-allow-unauthenticated --platform managed --region us-central1
```
8. After the service is deployed, try accessing the Service URL provided in the terminal. You should receive a Forbidden error message, as you do not have permission to access the service without the correct identity.

## Create the GKE Cluster with Workload Identity
1. Go back to the GCP console and navigate to **Kubernetes Engine** using the hamburger menu in the top left corner or the search bar.
2. Click **CREATE** to create a new cluster.
3. At the top, choose **SWITCH TO STANDARD CLUSTER**.
4. In the box that pops open, choose **SWITCH TO STANDARD CLUSTER**.
5. Under **NODE POOLS** on the left, select **default-pool**.
6. In the Size section, set the Number of nodes to **1**.
7. Under **CLUSTER** on the left, select **Security**.
8. Check the boxes next to **Enable Workload Identity** and Enable **Shielded GKE Nodes**.
9. Click **CREATE** to create the cluster.
10. After the cluster is created, use the three-dot Action menu to the right of the cluster details to select **Connect**.
11. In the pop-up **Connect to the cluster**, below **Command-line access**, copy the command to your clipboard.
12. Navigate back to the Cloud Shell terminal and paste the copied command.
13. After the command populates in the Cloud Shell terminal, run it to set up `kubectl`.

## Configure Service Accounts and IAM
1. Create a service account for your Secret Agent workload:
```bash
gcloud iam service-accounts create secret-agent
```
2. Create an IAM policy to allow the Secret Agent service account to invoke the Secret Service in Cloud Run, replacing <YOUR_PROJECT_ID> with your own project ID:
```bash
gcloud run services add-iam-policy-binding secret-service --member='serviceAccount:secret-agent@<YOUR_PROJECT_ID>.iam.gserviceaccount.com' --role='roles/run.invoker' --platform managed --region us-central1
```
3. Change into the gke-workload-identity/secret-agent directory:
```bash
cd ../secret-agent
```
4. Create the Kubernetes service account for the Secret Agent workload:
```bash
kubectl create -f serviceaccount.yaml
```
5. Allow the Kubernetes service account to impersonate the Google service account by creating an IAM policy binding between them, again substituting your project ID in both required locations:
```bash
gcloud iam service-accounts add-iam-policy-binding --role roles/iam.workloadIdentityUser --member "serviceAccount:<YOUR_PROJECT_ID>.svc.id.goog[default/secret-agent]" secret-agent@<YOUR_PROJECT_ID>.iam.gserviceaccount.com
```
6. Annotate the Kubernetes service account to complete the mapping, again substituting your project ID:
```bash
kubectl annotate serviceaccount --namespace default secret-agent iam.gke.io/gcp-service-account=secret-agent@<YOUR_PROJECT_ID>.iam.gserviceaccount.com
```

## Deploy the Secret Agent Workload to GKE
1. Create the PROJECT_ID environment variable for the workload:
```bash
export PROJECT_ID=$(gcloud config list project --format "value(core.project)")
```
2. Create the SECRET_URL environment variable for the workload:
```bash
export SECRET_URL=$(gcloud run services describe secret-service --platform managed --region us-central1 --format 'value(status.url)')
```
3. Confirm the PROJECT_ID variable was set correctly:
```bash
echo $PROJECT_ID
```
4. Confirm the SECRET_URL variable was set correctly:
```bash
echo $SECRET_URL
```
5. From within the gke-workload-identity/secret-agent directory, create the agent Pod manifest:
```bash
envsubst < pod-template.yaml > agent-pod.yaml
```
6. Build the Secret Agent container, replacing <YOUR_PROJECT_ID> with your own project ID:
```bash
gcloud builds submit --tag gcr.io/<YOUR_PROJECT_ID>/secret-agent
```
7. Deploy the Secret Agent Pod to GKE:
```bash
kubectl apply -f agent-pod.yaml
```
8. After the Pod is in a Running state, you should be able to observe that it can successfully connect to the Secret service Cloud Run service by viewing its logs:
```bash
kubectl logs secret-agent
```
9. The agent contacts the Secret service every 5 seconds and logs the results to STDOUT. It uses the GCP metadata server to generate a valid JWT token in order to identify itself as the service account you created earlier. This service account, and only this service account, is permitted to invoke the Cloud Run service.

Note that the JWT token generated by the agent workload will expire after an hour, after which the Pod will log a Forbidden error, which is expected.