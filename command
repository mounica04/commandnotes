START DOCUMENT

KUBERNETES, AZURE, AWS, HELM, DOCKER, GIT, CERTIFICATE, AND TROUBLESHOOTING COMMAND REFERENCE

Purpose:
This document contains commonly used commands for Kubernetes AKS operations, pod troubleshooting, logs, secrets, ConfigMaps, certificates, Azure Workload Identity, Key Vault validation, Docker, Helm, Git, AWS ECR, storage, DNS, Redis connectivity, Playwright validation, and backup or restore activities.

Important Security Note:
Do not store real passwords, PAT tokens, API keys, database passwords, storage account keys, AWS temporary credentials, kubeconfig files, or private keys in Notepad, Word documents, Git repositories, emails, or chat messages. Use Azure Key Vault, Kubernetes Secrets, CI CD secret variables, or approved enterprise secret management tools.

If any secret was accidentally exposed, rotate or revoke it immediately.

============================================================
1. KUBECONFIG AND CONTEXT COMMANDS
============================================================

These commands are used to connect your local terminal to the correct AKS cluster and set the default namespace.

Command:
export KUBECONFIG="/c/Users/<USER>/Downloads/<cluster-config>.yaml"

Explanation:
This command sets the kubeconfig file that kubectl should use. The kubeconfig file contains cluster connection details, authentication information, and context information.

Example:
export KUBECONFIG="/c/Users/ALLADMO1/Downloads/aksgainqa.yaml"

------------------------------------------------------------

Command:
kubectl config current-context

Explanation:
This command shows the currently active Kubernetes context. It helps confirm which cluster you are connected to before running commands.

Example:
kubectl config current-context

------------------------------------------------------------

Command:
kubectl config get-contexts

Explanation:
This command lists all available Kubernetes contexts from the current kubeconfig file.

Example:
kubectl config get-contexts

------------------------------------------------------------

Command:
kubectl config set-context --current --namespace=<namespace>

Explanation:
This command sets the default namespace for the current context. After this, you do not need to pass -n <namespace> with every kubectl command.

Example:
kubectl config set-context --current --namespace=dev-gain-core

------------------------------------------------------------

Command:
kubectl get ns

Explanation:
This command lists all namespaces available in the current Kubernetes cluster.

Example:
kubectl get ns


============================================================
2. POD, DEPLOYMENT, SERVICE, AND INGRESS CHECK COMMANDS
============================================================

These commands are used to check application status, pod placement, services, endpoints, and ingress resources.

Command:
kubectl get pods -n <namespace>

Explanation:
Lists all pods running in a specific namespace.

Example:
kubectl get pods -n gain-prod

------------------------------------------------------------

Command:
kubectl get pods -n <namespace> -o wide

Explanation:
Lists pods with additional details such as pod IP, node name, and readiness status.

Example:
kubectl get pods -n gain-prod -o wide

------------------------------------------------------------

Command:
kubectl describe pod <pod-name> -n <namespace>

Explanation:
Shows detailed pod information, including container status, environment details, mounted volumes, events, probe failures, and scheduling issues.

Example:
kubectl describe pod api-deployment-xxxxx -n dev-gain-core

------------------------------------------------------------

Command:
kubectl get deploy,svc,ingress -n <namespace>

Explanation:
Lists deployments, services, and ingress resources in a namespace.

Example:
kubectl get deploy,svc,ingress -n dev-gain-core

------------------------------------------------------------

Command:
kubectl get svc -n <namespace>

Explanation:
Lists services in a namespace.

Example:
kubectl get svc -n gain-prod

------------------------------------------------------------

Command:
kubectl describe svc <service-name> -n <namespace>

Explanation:
Shows service details such as selector, ports, target ports, endpoints, and service type.

Example:
kubectl describe svc api-service -n gain-prod

------------------------------------------------------------

Command:
kubectl get endpoints <service-name> -n <namespace> -o wide

Explanation:
Shows backend pod IPs currently attached to a service.

Example:
kubectl get endpoints api-service -n gain-prod -o wide

------------------------------------------------------------

Command:
kubectl get endpointslice -n <namespace> -l kubernetes.io/service-name=<service-name> -o wide

Explanation:
Shows EndpointSlice details for a service. EndpointSlice is the newer Kubernetes object used to track service endpoints.

Example:
kubectl get endpointslice -n gain-prod -l kubernetes.io/service-name=api-service -o wide

------------------------------------------------------------

Command:
kubectl get ingress -n <namespace>

Explanation:
Lists ingress resources in a namespace.

Example:
kubectl get ingress -n dev-gain-core

------------------------------------------------------------

Command:
kubectl describe ingress <ingress-name> -n <namespace>

Explanation:
Shows ingress host rules, backend services, TLS configuration, annotations, and events.

Example:
kubectl describe ingress dev-api-ingress -n dev-gain-core


============================================================
3. LOGS AND EVENTS COMMANDS
============================================================

These commands are used to troubleshoot pod startup issues, crash loops, application errors, and Kubernetes events.

Command:
kubectl logs <pod-name> -n <namespace>

Explanation:
Shows logs for a specific pod.

Example:
kubectl logs api-deployment-xxxxx -n dev-gain-core

------------------------------------------------------------

Command:
kubectl logs -f <pod-name> -n <namespace>

Explanation:
Streams live logs from a pod continuously.

Example:
kubectl logs -f api-deployment-xxxxx -n dev-gain-core

------------------------------------------------------------

Command:
kubectl logs <pod-name> -n <namespace> -c <container-name>

Explanation:
Shows logs from a specific container when a pod has multiple containers.

Example:
kubectl logs clickhouse-deployment-xxxxx -n gain-qa -c clickhouse-log-cleanup

------------------------------------------------------------

Command:
kubectl logs deploy/<deployment-name> -n <namespace> --tail=200 -f

Explanation:
Shows the last 200 log lines from pods managed by a deployment and continues streaming logs.

Example:
kubectl logs deploy/api-deployment -n dev-gain-core --tail=200 -f

------------------------------------------------------------

Command:
kubectl logs -l app=<label-value> -n <namespace>

Explanation:
Shows logs for all pods matching a specific label.

Example:
kubectl logs -l app=api -n dev-gain-core

------------------------------------------------------------

Command:
kubectl get events -n <namespace> --sort-by=.metadata.creationTimestamp

Explanation:
Shows Kubernetes events sorted by creation time. Useful for checking pod scheduling, image pull errors, mount failures, and probe failures.

Example:
kubectl get events -n dev-gain-core --sort-by=.metadata.creationTimestamp

------------------------------------------------------------

Command:
kubectl get events -A | grep -v PolicyViolation

Explanation:
Shows cluster-wide events while excluding PolicyViolation messages.

Example:
kubectl get events -A | grep -v PolicyViolation


============================================================
4. EXEC INTO POD AND CONTAINER INSPECTION COMMANDS
============================================================

These commands are used to enter a pod and check container-level details.

Command:
kubectl exec -it <pod-name> -n <namespace> -- sh

Explanation:
Opens an interactive shell inside a pod.

Example:
kubectl exec -it api-deployment-xxxxx -n dev-gain-core -- sh

------------------------------------------------------------

Command:
kubectl exec -it <pod-name> -n <namespace> -c <container-name> -- sh

Explanation:
Opens a shell inside a specific container in a multi-container pod.

Example:
kubectl exec -it igpt-aap-xxxxx -n ichatgpt-autonomous-agent -c igpt-aap-backend -- sh

------------------------------------------------------------

Command:
whoami

Explanation:
Shows the current user running inside the container.

Example:
whoami

------------------------------------------------------------

Command:
cat /etc/os-release || uname -a

Explanation:
Shows operating system details inside the container.

Example:
cat /etc/os-release || uname -a

------------------------------------------------------------

Command:
env | sort

Explanation:
Shows all environment variables in sorted order.

Example:
env | sort

------------------------------------------------------------

Command:
env | grep -i proxy

Explanation:
Shows proxy-related environment variables.

Example:
env | grep -i proxy

------------------------------------------------------------

Command:
env | grep -i redis

Explanation:
Shows Redis-related environment variables.

Example:
env | grep -i redis

------------------------------------------------------------

Command:
ps aux

Explanation:
Lists all running processes in the container.

Example:
ps aux

------------------------------------------------------------

Command:
ps aux | sort -rk 3,3 | head -n 10

Explanation:
Shows the top CPU-consuming processes inside the container.

Example:
ps aux | sort -rk 3,3 | head -n 10

------------------------------------------------------------

Command:
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem

Explanation:
Shows processes sorted by memory usage.

Example:
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem


============================================================
5. CPU, MEMORY, SCALING, AND ROLLOUT COMMANDS
============================================================

These commands are used to monitor resource usage and manage deployment replicas.

Command:
kubectl top pod <pod-name> -n <namespace>

Explanation:
Shows CPU and memory usage for one pod.

Example:
kubectl top pod api-deployment-xxxxx -n dev-gain-core

------------------------------------------------------------

Command:
kubectl top pods -n <namespace>

Explanation:
Shows CPU and memory usage for all pods in a namespace.

Example:
kubectl top pods -n gain-prod

------------------------------------------------------------

Command:
kubectl top pod --all-namespaces -o wide

Explanation:
Shows CPU and memory usage for pods across all namespaces with node placement details.

Example:
kubectl top pod --all-namespaces -o wide

------------------------------------------------------------

Command:
kubectl describe nodes | grep -A 5 "Capacity"

Explanation:
Shows CPU and memory capacity of cluster nodes.

Example:
kubectl describe nodes | grep -A 5 "Capacity"

------------------------------------------------------------

Command:
kubectl scale deployment <deployment-name> --replicas=<count> -n <namespace>

Explanation:
Scales a deployment to the required number of replicas.

Example:
kubectl scale deployment dify-plugin-daemon --replicas=3 -n dev-gain-core

------------------------------------------------------------

Command:
kubectl rollout restart deployment <deployment-name> -n <namespace>

Explanation:
Restarts all pods under a deployment without changing the deployment YAML.

Example:
kubectl rollout restart deployment api-deployment -n dev-gain-core

------------------------------------------------------------

Command:
kubectl -n <namespace> set resources deployment/<deployment-name> --containers=<container-name> --requests=cpu=<cpu>,memory=<memory> --limits=cpu=<cpu>,memory=<memory>

Explanation:
Updates CPU and memory requests and limits for a container inside a deployment.

Example:
kubectl -n dev-gain-core set resources deployment/api-deployment --containers=api --requests=cpu=600m,memory=1024Mi --limits=cpu=1000m,memory=2048Mi


============================================================
6. NODE AND POD COUNT COMMANDS
============================================================

These commands are used to check pod distribution across nodes.

Command:
kubectl get pods -A --field-selector spec.nodeName=<node-name>

Explanation:
Lists all pods running on a specific node.

Example:
kubectl get pods -A --field-selector spec.nodeName=aks-agentpool01-xxxxx

------------------------------------------------------------

Command:
kubectl get pods -A --no-headers | wc -l

Explanation:
Counts the total number of pods in the cluster.

Example:
kubectl get pods -A --no-headers | wc -l

------------------------------------------------------------

Command:
kubectl get pods -A --field-selector spec.nodeName=<node-name> --no-headers | wc -l

Explanation:
Counts how many pods are running on one specific node.

Example:
kubectl get pods -A --field-selector spec.nodeName=aks-agentpool01-xxxxx --no-headers | wc -l

------------------------------------------------------------

Command:
kubectl get pods -A -o jsonpath='{range .items[*]}{.spec.nodeName}{"\n"}{end}' | sort | uniq -c

Explanation:
Shows pod count grouped by node.

Example:
kubectl get pods -A -o jsonpath='{range .items[*]}{.spec.nodeName}{"\n"}{end}' | sort | uniq -c


============================================================
7. FILE COPY COMMANDS
============================================================

These commands are used to copy files between local machine and Kubernetes pods.

Command:
kubectl cp <local-file> <namespace>/<pod-name>:<target-path>

Explanation:
Copies a local file into a pod.

Example:
kubectl cp ./file.txt dev-gain-core/api-pod-xxxxx:/tmp/file.txt

------------------------------------------------------------

Command:
kubectl cp <local-directory> <namespace>/<pod-name>:<target-directory>

Explanation:
Copies a local directory into a pod.

Example:
kubectl cp ./dict termite-dev/termite-deployment-xxxxx:/data/termite/dictionaries/

------------------------------------------------------------

Command:
kubectl cp <namespace>/<pod-name>:<source-path> <local-path>

Explanation:
Copies a file or directory from a pod to the local machine.

Example:
kubectl cp dev-gain-core/api-pod-xxxxx:/tmp/output.log ./output.log

------------------------------------------------------------

Command:
kubectl exec -it <pod-name> -n <namespace> -- ls -lah <path>

Explanation:
Verifies whether copied files exist inside the pod.

Example:
kubectl exec -it api-pod-xxxxx -n dev-gain-core -- ls -lah /tmp


============================================================
8. CONFIGMAP COMMANDS
============================================================

ConfigMaps are used to store non-sensitive configuration files or key-value configuration.

Command:
kubectl create configmap <configmap-name> --from-file=<file-path> -n <namespace>

Explanation:
Creates a ConfigMap from a single file.

Example:
kubectl create configmap termite-server-config --from-file=/path/server-config.json -n termite-dev

------------------------------------------------------------

Command:
kubectl create configmap <configmap-name> --from-file=<directory-path> -n <namespace>

Explanation:
Creates a ConfigMap using all files from a directory.

Example:
kubectl create configmap termite-dicts --from-file=/path/dictionaries/ -n termite-dev

------------------------------------------------------------

Command:
kubectl get configmap <configmap-name> -n <namespace> -o yaml

Explanation:
Displays ConfigMap content in YAML format.

Example:
kubectl get configmap termite-server-config -n termite-dev -o yaml

------------------------------------------------------------

Command:
kubectl delete configmap <configmap-name> -n <namespace>

Explanation:
Deletes a ConfigMap from a namespace.

Example:
kubectl delete configmap termite-server-config -n termite-dev


============================================================
9. SECRET COMMANDS
============================================================

Kubernetes Secrets are used for sensitive values, but avoid typing secrets directly in commands because they may be stored in shell history.

Command:
kubectl create secret generic <secret-name> --from-literal=<key>=<value> -n <namespace>

Explanation:
Creates a generic secret from a literal key-value pair.

Example:
kubectl create secret generic db-secret --from-literal=password=<password> -n dev-gain-core

------------------------------------------------------------

Command:
kubectl create secret generic <secret-name> --from-file=<key>=<file-path> -n <namespace>

Explanation:
Creates a secret from a file.

Example:
kubectl create secret generic app-license --from-file=license.lic=/path/license.lic -n dev-gain-core

------------------------------------------------------------

Command:
kubectl create secret generic <secret-name> --from-env-file=<env-file> -n <namespace>

Explanation:
Creates a secret from an environment file.

Example:
kubectl create secret generic backend-env-secret --from-env-file=.env -n ichatgpt-autonomous-agent

------------------------------------------------------------

Command:
kubectl create secret tls <secret-name> --cert=<cert-file.pem> --key=<key-file.key> -n <namespace>

Explanation:
Creates a TLS secret using a certificate and private key.

Example:
kubectl create secret tls gain-dev-tls --cert=cert_gain-dev.novartis.net.pem --key=gain-dev.key -n dev-gain-core

------------------------------------------------------------

Command:
kubectl create secret docker-registry <secret-name> --docker-server=<registry-url> --docker-username=<username> --docker-password=<password> -n <namespace>

Explanation:
Creates an image pull secret for authenticating to a private container registry.

Example:
kubectl create secret docker-registry acr-secret --docker-server=<acr-url> --docker-username=<username> --docker-password=<password> -n dev-gain-core

------------------------------------------------------------

Command:
kubectl get secrets -n <namespace>

Explanation:
Lists all secrets in a namespace.

Example:
kubectl get secrets -n dev-gain-core

------------------------------------------------------------

Command:
kubectl describe secret <secret-name> -n <namespace>

Explanation:
Shows secret metadata without decoding the secret values.

Example:
kubectl describe secret gain-dev-tls -n dev-gain-core

------------------------------------------------------------

Command:
kubectl delete secret <secret-name> -n <namespace>

Explanation:
Deletes a secret from a namespace.

Example:
kubectl delete secret old-secret -n dev-gain-core


============================================================
10. TLS CERTIFICATE AND CSR COMMANDS
============================================================

These commands are used to generate private keys, CSRs, and inspect certificates.

Command:
openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -out <name>.key

Explanation:
Generates a 2048-bit RSA private key.

Example:
openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -out realtime.key

------------------------------------------------------------

Command:
openssl req -new -key <name>.key -out <name>.csr -config <openssl-config.cnf>

Explanation:
Generates a certificate signing request using an existing private key and OpenSSL configuration file.

Example:
openssl req -new -key realtime.key -out realtime.csr -config openssl-realtime.cnf

------------------------------------------------------------

Command:
openssl req -out <name>.csr -newkey rsa:2048 -nodes -keyout <name>.key -config <openssl-config.cnf>

Explanation:
Generates a private key and CSR in one command.

Example:
openssl req -out realtime.csr -newkey rsa:2048 -nodes -keyout realtime.key -config openssl-realtime.cnf

------------------------------------------------------------

Command:
openssl x509 -in <certificate.pem> -noout -text

Explanation:
Displays detailed certificate information.

Example:
openssl x509 -in cert_gain-dev.pem -noout -text

------------------------------------------------------------

Command:
openssl x509 -in <certificate.pem> -noout -dates

Explanation:
Shows certificate validity start and end dates.

Example:
openssl x509 -in cert_gain-dev.pem -noout -dates

------------------------------------------------------------

Command:
openssl rand -base64 32

Explanation:
Generates a random base64 string that can be used as a secret value.

Example:
openssl rand -base64 32


============================================================
11. DNS AND CONNECTIVITY COMMANDS
============================================================

These commands are used to verify DNS resolution, HTTP connectivity, HTTPS connectivity, and TCP port reachability.

Command:
nslookup <hostname>

Explanation:
Checks DNS resolution for a hostname.

Example:
nslookup api-service

------------------------------------------------------------

Command:
getent hosts <hostname>

Explanation:
Checks host resolution using the system resolver.

Example:
getent hosts pgsqlflexweudevgain01.postgres.database.azure.com

------------------------------------------------------------

Command:
curl -v <url>

Explanation:
Tests HTTP or HTTPS connectivity with verbose output.

Example:
curl -v https://example.com

------------------------------------------------------------

Command:
curl -vk <url>

Explanation:
Tests HTTPS connectivity and skips certificate verification. Use only for troubleshooting.

Example:
curl -vk https://dev-milvus.novartis.net/api/v1/healthy

------------------------------------------------------------

Command:
curl -I <url>

Explanation:
Fetches only HTTP response headers.

Example:
curl -I https://gain-qa.novartis.net

------------------------------------------------------------

Command:
nc -zv <hostname> <port>

Explanation:
Tests whether a TCP port is reachable.

Example:
nc -zv rcache-example.redis.cache.windows.net 6380

------------------------------------------------------------

Command:
bash -lc 'echo > /dev/tcp/<hostname>/<port> && echo CONNECTED || echo FAILED'

Explanation:
Tests TCP connectivity when netcat is not installed.

Example:
bash -lc 'echo > /dev/tcp/rcache-example.redis.cache.windows.net/6380 && echo CONNECTED || echo FAILED'

------------------------------------------------------------

Command:
netstat -tuln | grep <port>

Explanation:
Checks listening ports inside a Linux container.

Example:
netstat -tuln | grep 9090

------------------------------------------------------------

Command:
netstat -a -n | findstr ":<port>"

Explanation:
Checks listening ports on Windows.

Example:
netstat -a -n | findstr ":80"


============================================================
12. REDIS CONNECTIVITY VALIDATION
============================================================

Redis is not an HTTP service, so normal curl testing is not reliable. Use DNS checks and TCP checks.

Command:
env | grep -i redis

Explanation:
Checks Redis-related environment variables inside the pod.

Example:
env | grep -i redis

------------------------------------------------------------

Command:
nslookup <redis-hostname>

Explanation:
Checks whether the Redis hostname resolves.

Example:
nslookup rcache-example.redis.cache.windows.net

------------------------------------------------------------

Command:
nc -zv <redis-hostname> 6380

Explanation:
Tests TCP connectivity to Redis TLS port 6380.

Example:
nc -zv rcache-example.redis.cache.windows.net 6380

------------------------------------------------------------

Command:
bash -lc 'echo > /dev/tcp/<redis-hostname>/6380 && echo CONNECTED || echo FAILED'

Explanation:
Tests Redis TCP connectivity if netcat is not available.

Example:
bash -lc 'echo > /dev/tcp/rcache-example.redis.cache.windows.net/6380 && echo CONNECTED || echo FAILED'

------------------------------------------------------------

Command:
curl -vk telnet://<redis-hostname>:6380

Explanation:
Only checks whether the Redis TLS port is reachable. It does not validate Redis authentication or Redis protocol.

Example:
curl -vk telnet://rcache-example.redis.cache.windows.net:6380


============================================================
13. PVC AND PV COMMANDS
============================================================

These commands are used to inspect persistent volumes, retain data, and expand storage.

Command:
kubectl get pvc -n <namespace>

Explanation:
Lists persistent volume claims in a namespace.

Example:
kubectl get pvc -n dev-gain-core

------------------------------------------------------------

Command:
kubectl describe pvc <pvc-name> -n <namespace>

Explanation:
Shows detailed PVC information.

Example:
kubectl describe pvc data-pvc -n gain-prod

------------------------------------------------------------

Command:
kubectl patch pv <pv-name> -p '{"spec":{"persistentVolumeReclaimPolicy":"Retain"}}'

Explanation:
Changes the persistent volume reclaim policy to Retain, so the volume is not deleted when the PVC is deleted.

Example:
kubectl patch pv pvc-xxxxx -p '{"spec":{"persistentVolumeReclaimPolicy":"Retain"}}'

------------------------------------------------------------

Command:
kubectl patch pvc <pvc-name> -n <namespace> -p '{"spec":{"resources":{"requests":{"storage":"50Gi"}}}}'

Explanation:
Expands the PVC requested storage size to 50Gi. The storage class must support volume expansion.

Example:
kubectl patch pvc data-pvc -n gain-prod -p '{"spec":{"resources":{"requests":{"storage":"50Gi"}}}}'

------------------------------------------------------------

Command:
df -h

Explanation:
Shows filesystem disk usage inside a pod.

Example:
df -h

------------------------------------------------------------

Command:
du -ah <path> | sort -hr | head -20

Explanation:
Shows the largest files and folders under a path.

Example:
du -ah /var/lib/clickhouse | sort -hr | head -20


============================================================
14. CLICKHOUSE LOG CLEANUP COMMANDS
============================================================

These commands are used to remove old ClickHouse system logs when storage is full. Use carefully and only after confirming with the application or database owner.

Command:
rm -rf /var/lib/clickhouse/data/system/text_log/

Explanation:
Removes ClickHouse text log data.

------------------------------------------------------------

Command:
rm -rf /var/lib/clickhouse/data/system/trace_log/

Explanation:
Removes ClickHouse trace log data.

------------------------------------------------------------

Command:
rm -rf /var/lib/clickhouse/data/system/metric_log/

Explanation:
Removes ClickHouse metric log data.

------------------------------------------------------------

Command:
rm -rf /var/lib/clickhouse/data/system/query_log/

Explanation:
Removes ClickHouse query log data.

------------------------------------------------------------

Command:
du -ah /var/lib/clickhouse | sort -hr | head -20

Explanation:
Checks which folders are consuming the most storage.

Example:
du -ah /var/lib/clickhouse | sort -hr | head -20


============================================================
15. BACKUP AND RESTORE COMMANDS
============================================================

Use these commands to back up Kubernetes resources. Avoid exporting secrets unless absolutely required.

Command:
kubectl get pvc,po,svc,cm,deploy,ingress,hpa,cronjob,sa,sts,ds,netpol,role,pdb -n <namespace> -o yaml > <backup-file>.yaml

Explanation:
Backs up common namespace resources excluding secrets.

Example:
kubectl get pvc,po,svc,cm,deploy,ingress,hpa,cronjob,sa,sts,ds,netpol,role,pdb -n termite-dev -o yaml > termite-dev-backup.yaml

------------------------------------------------------------

Command:
kubectl get secret -n <namespace> -o yaml > <secret-backup-file>.yaml

Explanation:
Backs up secrets. This file is highly sensitive and must be stored securely.

Example:
kubectl get secret -n termite-dev -o yaml > termite-dev-secrets-backup.yaml

------------------------------------------------------------

Command:
kubectl create -f <backup-file>.yaml -n <namespace>

Explanation:
Restores resources from a backup file if they do not already exist.

Example:
kubectl create -f termite-dev-backup.yaml -n termite-dev

------------------------------------------------------------

Command:
kubectl apply -f <backup-file>.yaml -n <namespace>

Explanation:
Creates or updates resources from a backup file.

Example:
kubectl apply -f termite-dev-backup.yaml -n termite-dev


============================================================
16. HELM COMMANDS
============================================================

Helm is used to package, install, upgrade, and manage Kubernetes applications.

Command:
helm create <chart-name>

Explanation:
Creates a new Helm chart folder structure.

Example:
helm create admin-ui

------------------------------------------------------------

Command:
helm lint <chart-path>

Explanation:
Validates Helm chart syntax and best practices.

Example:
helm lint ./gain-api

------------------------------------------------------------

Command:
helm template <release-name> <chart-path> -f <values-file> --namespace <namespace>

Explanation:
Renders Kubernetes YAML from a Helm chart without installing it.

Example:
helm template gain-api ./gain-api -f ./gain-api/values-dev.yaml --namespace dev-gain-core

------------------------------------------------------------

Command:
helm install <release-name> <chart-path> -n <namespace> --create-namespace -f <values-file>

Explanation:
Installs a Helm chart as a release.

Example:
helm install gain-api-dev ./gain-api -n dev-gain-core --create-namespace -f gain-api/values-dev.yaml

------------------------------------------------------------

Command:
helm upgrade --install <release-name> <chart-path> -f <values-file> --namespace <namespace> --create-namespace

Explanation:
Installs the release if it does not exist, or upgrades it if it already exists.

Example:
helm upgrade --install gain-api-dev ./gain-api -f gain-api/values-dev.yaml --namespace dev-gain-core --create-namespace

------------------------------------------------------------

Command:
helm uninstall <release-name> --namespace <namespace>

Explanation:
Uninstalls a Helm release from a namespace.

Example:
helm uninstall gain-api-dev --namespace dev-gain-core


============================================================
17. APPLY, CREATE, AND DELETE KUBERNETES YAML
============================================================

These commands are used to deploy or remove Kubernetes YAML files.

Command:
kubectl apply -f <file.yml> -n <namespace>

Explanation:
Creates or updates Kubernetes resources from one YAML file.

Example:
kubectl apply -f api-dep.yml -n dev-gain-core

------------------------------------------------------------

Command:
kubectl apply -f <file1.yml> -f <file2.yml> -f <file3.yml> -n <namespace>

Explanation:
Creates or updates multiple Kubernetes YAML files together.

Example:
kubectl apply -f api-dep.yml -f api-svc.yml -f dev-api-ingress.yml -n dev-gain-core

------------------------------------------------------------

Command:
kubectl create -f <file.yml> -n <namespace>

Explanation:
Creates resources from a YAML file only if they do not already exist.

Example:
kubectl create -f search-server-dep.yml -n search-dev

------------------------------------------------------------

Command:
kubectl delete -f <file.yml> -n <namespace>

Explanation:
Deletes resources defined in a YAML file.

Example:
kubectl delete -f search-server-dep.yml -n search-dev

------------------------------------------------------------

Command:
kubectl delete deployment <deployment-name> -n <namespace>

Explanation:
Deletes a deployment.

Example:
kubectl delete deployment search-client-service -n search-dev

------------------------------------------------------------

Command:
kubectl delete ingress <ingress-name> -n <namespace>

Explanation:
Deletes an ingress resource.

Example:
kubectl delete ingress dev-difydaemon-ingress -n dev-gain-core

------------------------------------------------------------

Command:
kubectl delete service <service-name> -n <namespace>

Explanation:
Deletes a service.

Example:
kubectl delete service client -n search-dev

------------------------------------------------------------

Command:
kubectl delete pod <pod-name> -n <namespace> --force

Explanation:
Force deletes a pod. Kubernetes recreates it if it is managed by a deployment, replica set, daemonset, or statefulset.

Example:
kubectl delete pod celery-deployment-xxxxx -n gain-preprod --force


============================================================
18. AZURE WORKLOAD IDENTITY VALIDATION
============================================================

These commands verify whether a pod is correctly configured to use Azure Workload Identity.

Command:
kubectl -n <namespace> get pod <pod-name> -o jsonpath='{.spec.serviceAccountName}{"\n"}'

Explanation:
Shows which service account the pod is using.

Example:
kubectl -n docling-prod get pod app-pod-xxxxx -o jsonpath='{.spec.serviceAccountName}{"\n"}'

------------------------------------------------------------

Command:
kubectl -n <namespace> get pod <pod-name> -o jsonpath='{.metadata.labels.azure\.workload\.identity/use}{"\n"}'

Explanation:
Checks whether the pod has the required Azure Workload Identity label.

Example:
kubectl -n docling-prod get pod app-pod-xxxxx -o jsonpath='{.metadata.labels.azure\.workload\.identity/use}{"\n"}'

------------------------------------------------------------

Command:
kubectl -n <namespace> get sa <serviceaccount-name> -o jsonpath='{.metadata.annotations.azure\.workload\.identity/client-id}{"\n"}'

Explanation:
Shows the Azure managed identity client ID configured on the service account.

Example:
kubectl -n docling-prod get sa workload-identity-sa -o jsonpath='{.metadata.annotations.azure\.workload\.identity/client-id}{"\n"}'

------------------------------------------------------------

Command:
kubectl -n <namespace> describe sa <serviceaccount-name>

Explanation:
Displays full service account details and annotations.

Example:
kubectl -n docling-prod describe sa workload-identity-sa

------------------------------------------------------------

Command:
kubectl -n <namespace> exec -it <pod-name> -- sh -c 'env | egrep "AZURE_TENANT_ID|AZURE_CLIENT_ID|AZURE_FEDERATED_TOKEN_FILE" | sort'

Explanation:
Checks whether Azure Workload Identity environment variables are injected into the pod.

Example:
kubectl -n docling-prod exec -it app-pod-xxxxx -- sh -c 'env | egrep "AZURE_TENANT_ID|AZURE_CLIENT_ID|AZURE_FEDERATED_TOKEN_FILE" | sort'


============================================================
19. KEY VAULT CSI DRIVER VALIDATION
============================================================

These commands are used when Azure Key Vault secrets are mounted into pods using the Secrets Store CSI Driver.

Command:
kubectl -n <namespace> get pod <pod-name> -o jsonpath='{range .spec.volumes[*]}{.name}{" "}{.csi.driver}{"\n"}{end}'

Explanation:
Checks whether the pod has CSI volumes configured.

Example:
kubectl -n dev-gain-core get pod app-pod-xxxxx -o jsonpath='{range .spec.volumes[*]}{.name}{" "}{.csi.driver}{"\n"}{end}'

------------------------------------------------------------

Command:
kubectl -n <namespace> get secretproviderclass

Explanation:
Lists SecretProviderClass resources in the namespace.

Example:
kubectl -n dev-gain-core get secretproviderclass

------------------------------------------------------------

Command:
kubectl -n <namespace> describe secretproviderclass <spc-name>

Explanation:
Shows Key Vault CSI configuration such as vault name, tenant ID, identity mode, and object names.

Example:
kubectl -n dev-gain-core describe secretproviderclass app-keyvault-spc

------------------------------------------------------------

Command:
kubectl -n <namespace> describe pod <pod-name>

Explanation:
Checks pod events for Key Vault mount errors, authorization failures, or CSI driver errors.

Example:
kubectl -n dev-gain-core describe pod app-pod-xxxxx

------------------------------------------------------------

Command:
kubectl -n <namespace> logs <pod-name> --all-containers=true --tail=200

Explanation:
Checks pod logs for Key Vault authentication or secret mount errors.

Example:
kubectl -n dev-gain-core logs app-pod-xxxxx --all-containers=true --tail=200


============================================================
20. SAFE AZURE KEY VAULT PYTHON VALIDATION
============================================================

This script validates access to Azure Key Vault without printing secret values.

Step 1: Install packages.

Command:
python3 -m ensurepip --upgrade
python3 -m pip install --upgrade pip
python3 -m pip install azure-identity azure-keyvault-secrets
python3 -c "from azure.keyvault.secrets import SecretClient; print('Key Vault package import ok')"

Explanation:
Installs required Python packages for Azure Key Vault access and verifies that the package import works.

------------------------------------------------------------

Step 2: Create Python script.

Command:
cat > test_kv.py <<'EOF'
import os
from azure.identity import DefaultAzureCredential
from azure.keyvault.secrets import SecretClient

key_vault_uri = "https://<keyvault-name>.vault.azure.net/"
client_id = os.getenv("AZURE_CLIENT_ID")

print(f"AZURE_CLIENT_ID present: {bool(client_id)}")

if not client_id:
    print("AZURE_CLIENT_ID is missing. Workload Identity may not be configured.")
    raise SystemExit(1)

credential = DefaultAzureCredential(managed_identity_client_id=client_id)
secret_client = SecretClient(vault_url=key_vault_uri, credential=credential)

secret_names = [
    "<secret-name-1>",
    "<secret-name-2>"
]

for secret_name in secret_names:
    try:
        secret = secret_client.get_secret(secret_name)
        print(f"{secret_name}: fetched successfully, value length = {len(secret.value)}")
    except Exception as error:
        print(f"{secret_name}: ERROR: {error}")
EOF

Explanation:
Creates a safe Key Vault validation script. It confirms whether secrets can be fetched but does not print the secret values.

------------------------------------------------------------

Step 3: Run the script.

Command:
python3 test_kv.py

Explanation:
Executes the Key Vault validation script.

Example:
python3 test_kv.py


============================================================
21. SAFE AZURE BLOB STORAGE PYTHON VALIDATION
============================================================

This script validates Azure Blob Storage access without exposing keys.

Step 1: Install packages.

Command:
python3 -m pip install azure-identity azure-storage-blob
python3 -c "from azure.storage.blob import BlobServiceClient; print('Blob package import ok')"

Explanation:
Installs Azure Blob Storage Python SDK and validates import.

------------------------------------------------------------

Step 2: Create Python script.

Command:
cat > test_blob.py <<'EOF'
from azure.identity import DefaultAzureCredential
from azure.storage.blob import BlobServiceClient

credential = DefaultAzureCredential()

blob_service_client = BlobServiceClient(
    account_url="https://<storage-account-name>.blob.core.windows.net",
    credential=credential
)

container_client = blob_service_client.get_container_client("<container-name>")

count = 0
for blob in container_client.list_blobs():
    print(blob.name)
    count += 1
    if count >= 10:
        break

print(f"Listed {count} blobs successfully")
EOF

Explanation:
Creates a script to list up to 10 blobs from a container using Azure identity authentication.

------------------------------------------------------------

Step 3: Run the script.

Command:
python3 test_blob.py

Explanation:
Executes the Blob Storage validation script.

Example:
python3 test_blob.py


============================================================
22. DOCKER COMMANDS
============================================================

These commands are used to build, run, and push Docker images.

Command:
docker build -t <image-name>:<tag> -f Dockerfile .

Explanation:
Builds a Docker image using Dockerfile from the current directory.

Example:
docker build -t search_server:latest -f Dockerfile .

------------------------------------------------------------

Command:
docker run -d --restart unless-stopped --name <container-name> -p <host-port>:<container-port> <image-name>:<tag>

Explanation:
Runs a Docker container in detached mode and restarts it automatically unless stopped manually.

Example:
docker run -d --restart unless-stopped --name termite -p 9090:9090 scibite/termite:6.6.3-dicts

------------------------------------------------------------

Command:
docker login <registry-url>

Explanation:
Logs in to a Docker registry.

Example:
docker login myregistry.example.com

------------------------------------------------------------

Command:
docker push <registry-url>/<repository>:<tag>

Explanation:
Pushes a Docker image to a container registry.

Example:
docker push myregistry.example.com/search_server:latest


============================================================
23. AWS ECR AND ACM COMMANDS
============================================================

These commands are used for AWS role assumption, ECR login, image build and push, and ACM certificate operations.

Command:
aws sts assume-role --role-arn <role-arn> --role-session-name <session-name> --external-id <external-id>

Explanation:
Assumes an AWS IAM role and returns temporary credentials.

Example:
aws sts assume-role --role-arn arn:aws:iam::<account-id>:role/<role-name> --role-session-name <session-name> --external-id <external-id>

------------------------------------------------------------

Command:
aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <account-id>.dkr.ecr.<region>.amazonaws.com

Explanation:
Authenticates Docker to AWS Elastic Container Registry.

Example:
aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin <account-id>.dkr.ecr.eu-west-1.amazonaws.com

------------------------------------------------------------

Command:
docker build -t <account-id>.dkr.ecr.<region>.amazonaws.com/<repository>:<tag> -f Dockerfile .

Explanation:
Builds a Docker image and tags it for AWS ECR.

Example:
docker build -t <account-id>.dkr.ecr.eu-west-1.amazonaws.com/search_server:latest -f Dockerfile .

------------------------------------------------------------

Command:
docker push <account-id>.dkr.ecr.<region>.amazonaws.com/<repository>:<tag>

Explanation:
Pushes the Docker image to AWS ECR.

Example:
docker push <account-id>.dkr.ecr.eu-west-1.amazonaws.com/search_server:latest

------------------------------------------------------------

Command:
aws acm import-certificate --certificate fileb://<cert.pem> --private-key fileb://<private-key.pem> --certificate-chain fileb://<chain.pem> --profile <profile>

Explanation:
Imports a certificate into AWS Certificate Manager.

Example:
aws acm import-certificate --certificate fileb://cert.pem --private-key fileb://private-key.pem --certificate-chain fileb://chain.pem --profile prod

------------------------------------------------------------

Command:
aws elbv2 add-listener-certificates --listener-arn <listener-arn> --certificates CertificateArn=<certificate-arn> --profile <profile>

Explanation:
Adds an ACM certificate to an Application Load Balancer listener.

Example:
aws elbv2 add-listener-certificates --listener-arn <listener-arn> --certificates CertificateArn=<certificate-arn> --profile prod


============================================================
24. GIT COMMANDS
============================================================

These commands are used for Git configuration, branch update, merge, commit, and push.

Command:
git config --global user.email "<email>"

Explanation:
Sets the global Git email.

Example:
git config --global user.email "user@example.com"

------------------------------------------------------------

Command:
git config --global user.name "<name>"

Explanation:
Sets the global Git username.

Example:
git config --global user.name "User Name"

------------------------------------------------------------

Command:
git status

Explanation:
Shows current branch status and changed files.

Example:
git status

------------------------------------------------------------

Command:
git fetch origin

Explanation:
Fetches latest branch references from remote repository.

Example:
git fetch origin

------------------------------------------------------------

Command:
git checkout <branch-name>

Explanation:
Switches to a specific branch.

Example:
git checkout preprod_jenkinsfile

------------------------------------------------------------

Command:
git pull origin <branch-name>

Explanation:
Pulls latest changes from the remote branch.

Example:
git pull origin preprod_jenkinsfile

------------------------------------------------------------

Command:
git merge origin/main

Explanation:
Merges the latest main branch changes into the current branch.

Example:
git merge origin/main

------------------------------------------------------------

Command:
git add .

Explanation:
Stages all modified files.

Example:
git add .

------------------------------------------------------------

Command:
git commit -m "<message>"

Explanation:
Commits staged changes with a message.

Example:
git commit -m "Updated deployment configuration"

------------------------------------------------------------

Command:
git push origin <branch-name>

Explanation:
Pushes local branch changes to remote repository.

Example:
git push origin preprod_jenkinsfile


============================================================
25. PLAYWRIGHT VALIDATION INSIDE POD
============================================================

These commands validate Node.js, npm, Playwright, browser binaries, and required Linux libraries.

Command:
node --version

Explanation:
Checks Node.js version.

Example:
node --version

------------------------------------------------------------

Command:
npm --version

Explanation:
Checks npm version.

Example:
npm --version

------------------------------------------------------------

Command:
npx playwright --version

Explanation:
Checks Playwright CLI version.

Example:
npx playwright --version

------------------------------------------------------------

Command:
echo $PLAYWRIGHT_BROWSERS_PATH

Explanation:
Shows the Playwright browser installation path.

Example:
echo $PLAYWRIGHT_BROWSERS_PATH

------------------------------------------------------------

Command:
ls -lah /ms-playwright

Explanation:
Lists Playwright browser files.

Example:
ls -lah /ms-playwright

------------------------------------------------------------

Command:
find /ms-playwright -maxdepth 3 -type f | head -20

Explanation:
Shows sample browser files installed under the Playwright path.

Example:
find /ms-playwright -maxdepth 3 -type f | head -20

------------------------------------------------------------

Command:
ldconfig -p | grep libnspr4

Explanation:
Checks whether libnspr4 is installed.

Example:
ldconfig -p | grep libnspr4

------------------------------------------------------------

Command:
ldconfig -p | grep libnss3

Explanation:
Checks whether libnss3 is installed.

Example:
ldconfig -p | grep libnss3

------------------------------------------------------------

Command:
ldconfig -p | grep libatk

Explanation:
Checks whether libatk is installed.

Example:
ldconfig -p | grep libatk

------------------------------------------------------------

Command:
ldconfig -p | grep libgtk-3

Explanation:
Checks whether GTK 3 library is installed.

Example:
ldconfig -p | grep libgtk-3

------------------------------------------------------------

Command:
node -e "const { chromium } = require('playwright'); (async() => { const browser = await chromium.launch({ headless: true }); const page = await browser.newPage(); await page.goto('https://example.com'); console.log(await page.title()); await browser.close(); })();"

Explanation:
Launches Chromium using Playwright in headless mode and opens example.com. Expected output is Example Domain.

Example:
node -e "const { chromium } = require('playwright'); (async() => { const browser = await chromium.launch({ headless: true }); const page = await browser.newPage(); await page.goto('https://example.com'); console.log(await page.title()); await browser.close(); })();"


============================================================
26. TEMPORARY NETWORK TEST POD
============================================================

Use this when you need a temporary pod for DNS and connectivity testing.

Command:
kubectl create deploy netshoot --image=<netshoot-image> -n <namespace> -- sleep 3600

Explanation:
Creates a temporary troubleshooting deployment using a network utility image.

Example:
kubectl create deploy netshoot --image=docker-repo.example.com/nirmata/netshoot:latest -n gain-preprod-us -- sleep 3600

------------------------------------------------------------

Command:
kubectl exec -it deploy/netshoot -n <namespace> -- bash

Explanation:
Opens a shell inside the netshoot pod.

Example:
kubectl exec -it deploy/netshoot -n gain-preprod-us -- bash

------------------------------------------------------------

Command:
kubectl delete deploy netshoot -n <namespace>

Explanation:
Deletes the temporary troubleshooting deployment.

Example:
kubectl delete deploy netshoot -n gain-preprod-us


============================================================
27. CRONJOB AND JOB COMMANDS
============================================================

These commands are used to check scheduled jobs and job history.

Command:
kubectl get cronjob -n <namespace>

Explanation:
Lists CronJobs in a namespace.

Example:
kubectl get cronjob -n igpt-dev

------------------------------------------------------------

Command:
kubectl get cronjob <cronjob-name> -n <namespace> -o wide

Explanation:
Shows more details about a specific CronJob.

Example:
kubectl get cronjob daily-internal-api-call -n igpt-dev -o wide

------------------------------------------------------------

Command:
kubectl get jobs -n <namespace> --sort-by=.metadata.creationTimestamp

Explanation:
Lists Jobs sorted by creation time.

Example:
kubectl get jobs -n igpt-dev --sort-by=.metadata.creationTimestamp

------------------------------------------------------------

Command:
kubectl logs job/<job-name> -n <namespace>

Explanation:
Shows logs from a Kubernetes Job.

Example:
kubectl logs job/daily-internal-api-call-xxxxx -n igpt-dev


============================================================
28. JENKINS BRANCH FILTER REGEX
============================================================

These examples are used in Jenkins when filtering branch names.

Command:
^jenkinsfile$

Explanation:
Triggers Jenkins job only for the jenkinsfile branch.

Example:
^jenkinsfile$

------------------------------------------------------------

Command:
^(jenkins-backend|jenkinsfile)$

Explanation:
Triggers Jenkins job for either jenkins-backend or jenkinsfile branches.

Example:
^(jenkins-backend|jenkinsfile)$

------------------------------------------------------------

Command:
^(jenkinspipelineqa|jenkinsfile|main)$

Explanation:
Triggers Jenkins job for jenkinspipelineqa, jenkinsfile, or main branches.

Example:
^(jenkinspipelineqa|jenkinsfile|main)$


============================================================
29. WINDOWS TROUBLESHOOTING COMMANDS
============================================================

These commands are used when Windows Explorer or Task Manager has issues.

Command:
Ctrl + Shift + Esc

Explanation:
Keyboard shortcut to open Task Manager directly.

------------------------------------------------------------

Command:
taskkill /f /im explorer.exe

Explanation:
Force kills Windows Explorer.

Example:
taskkill /f /im explorer.exe

------------------------------------------------------------

Command:
start explorer.exe

Explanation:
Starts Windows Explorer again.

Example:
start explorer.exe


============================================================
30. LIVENESS AND READINESS PROBE EXPLANATION
============================================================

Liveness Probe:
A liveness probe checks whether the application container is still alive. If the liveness probe fails repeatedly, Kubernetes restarts the container.

Readiness Probe:
A readiness probe checks whether the application is ready to receive traffic. If the readiness probe fails, Kubernetes stops sending traffic to the pod but does not restart the container.

Example Meaning:
If readiness fails, users may not reach the pod through service.
If liveness fails, Kubernetes restarts the pod container.


============================================================
31. SERVICE DNS FORMAT
============================================================

Kubernetes service DNS format:
<service-name>.<namespace>.svc.cluster.local

Explanation:
This is the full internal DNS name for a Kubernetes service.

Example:
milvus-standalone-service.milvus-dev.svc.cluster.local


============================================================
32. COMMON TROUBLESHOOTING FLOW
============================================================

Step 1:
Check pod status.

Command:
kubectl get pods -n <namespace> -o wide

Step 2:
Describe the failing pod.

Command:
kubectl describe pod <pod-name> -n <namespace>

Step 3:
Check logs.

Command:
kubectl logs <pod-name> -n <namespace> --tail=200

Step 4:
Check service and endpoints.

Command:
kubectl get svc <service-name> -n <namespace> -o wide
kubectl get endpoints <service-name> -n <namespace> -o wide

Step 5:
Exec into the pod.

Command:
kubectl exec -it <pod-name> -n <namespace> -- sh

Step 6:
Check DNS.

Command:
nslookup <service-name>

Step 7:
Check TCP connectivity.

Command:
nc -zv <hostname> <port>

Step 8:
Check application health endpoint.

Command:
curl -vk <health-url>


============================================================
33. SECURITY ACTION ITEMS
============================================================

1. Rotate exposed Azure Storage account keys.
2. Revoke and recreate exposed Azure DevOps PAT tokens.
3. Rotate exposed database passwords.
4. Invalidate exposed AWS temporary credentials if still active.
5. Rotate exposed API keys.
6. Rotate exposed application secrets.
7. Review access logs for unusual activity.
8. Move all secrets to Azure Key Vault or approved enterprise secret manager.
9. Do not store production credentials in local text files, Word documents, Git repositories, screenshots, or chat tools.
10. Use placeholders in documentation instead of real credentials.



START UPDATED SECTION

============================================================
34. AWS STS ASSUME ROLE VALIDATION USING PYTHON
============================================================

Purpose:
This section explains how to safely assume an AWS IAM role using Python boto3, validate the active AWS identity, and optionally check ECR access.

Important Security Note:
Never hardcode AWS AccessKeyId, SecretAccessKey, SessionToken, PAT tokens, passwords, or API keys directly inside Python files, shell scripts, Jenkinsfiles, Git repositories, Word documents, or Notepad files.

Do not print SecretAccessKey or SessionToken in logs.

If any AWS key, secret key, or session token is exposed, treat it as compromised and rotate or revoke it immediately.

------------------------------------------------------------
34.1 Install required Python package
------------------------------------------------------------

Command:
python3 -m pip install boto3 botocore

Explanation:
Installs boto3 and botocore packages required to connect to AWS services from Python.

Example:
python3 -m pip install boto3 botocore

------------------------------------------------------------
34.2 Check current AWS identity using AWS CLI
------------------------------------------------------------

Command:
aws sts get-caller-identity

Explanation:
Shows the current AWS identity being used by your terminal. This confirms whether your source credentials are working before running the Python script.

Example:
aws sts get-caller-identity

Expected output example:
{
    "UserId": "XXXXXXXXXXXXXXXXXXXXX",
    "Account": "123456789012",
    "Arn": "arn:aws:sts::123456789012:assumed-role/source-role/session-name"
}

------------------------------------------------------------
34.3 Check AWS credential configuration
------------------------------------------------------------

Command:
aws configure list

Explanation:
Shows where AWS credentials and region are coming from, such as environment variables, AWS profile, credentials file, or instance role.

Example:
aws configure list

------------------------------------------------------------
34.4 Check available AWS profiles
------------------------------------------------------------

Command:
aws configure list-profiles

Explanation:
Lists locally configured AWS profiles.

Example:
aws configure list-profiles

------------------------------------------------------------
34.5 Use AWS profile as source credentials
------------------------------------------------------------

Command:
export SOURCE_PROFILE=<source-profile-name>

Explanation:
Sets the local AWS profile that the Python script should use as source credentials before assuming the target role.

Example:
export SOURCE_PROFILE=RIDY_AWS_RSSR86_APPADMDEV

------------------------------------------------------------
34.6 Use environment variables as source credentials
------------------------------------------------------------

Command:
export AWS_ACCESS_KEY_ID="<access-key-id>"
export AWS_SECRET_ACCESS_KEY="<secret-access-key>"
export AWS_SESSION_TOKEN="<session-token>"
export AWS_REGION="<aws-region>"

Explanation:
Sets temporary AWS credentials in the current shell session. Use this only when required. Do not save these values in scripts or documents.

Example:
export AWS_ACCESS_KEY_ID="<access-key-id>"
export AWS_SECRET_ACCESS_KEY="<secret-access-key>"
export AWS_SESSION_TOKEN="<session-token>"
export AWS_REGION="eu-west-1"

------------------------------------------------------------
34.7 Clear AWS environment credentials after use
------------------------------------------------------------

Command:
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset AWS_SESSION_TOKEN
unset SOURCE_PROFILE

Explanation:
Removes AWS credential variables from the current shell session after use.

Example:
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset AWS_SESSION_TOKEN
unset SOURCE_PROFILE

------------------------------------------------------------
34.8 Safe Python script to assume AWS role
------------------------------------------------------------

File name:
assume_role_validate.py

Command:
cat > assume_role_validate.py <<'EOF'
#!/usr/bin/env python3

import os
import sys
import boto3
from botocore.exceptions import ClientError, NoCredentialsError, ProfileNotFound


TARGET_ROLE_ARN = os.environ.get(
    "TARGET_ROLE_ARN",
    "arn:aws:iam::<target-account-id>:role/<target-role-name>"
)

ROLE_SESSION_NAME = os.environ.get(
    "ROLE_SESSION_NAME",
    "assume-role-validation-session"
)

EXTERNAL_ID = os.environ.get("EXTERNAL_ID")

AWS_REGION = os.environ.get("AWS_REGION", "eu-west-1")

SOURCE_PROFILE = os.environ.get("SOURCE_PROFILE")


def create_source_session():
    """
    Creates a boto3 source session using either:
    1. SOURCE_PROFILE if provided
    2. Default AWS credential chain otherwise

    Default AWS credential chain includes:
    - Environment variables
    - ~/.aws/credentials
    - AWS SSO cached credentials
    - EC2, ECS, or Jenkins instance role
    """

    try:
        if SOURCE_PROFILE:
            print("Using AWS profile: {}".format(SOURCE_PROFILE))
            return boto3.Session(
                profile_name=SOURCE_PROFILE,
                region_name=AWS_REGION
            )

        print("Using default AWS credential chain")
        return boto3.Session(region_name=AWS_REGION)

    except ProfileNotFound as error:
        print("ERROR: AWS profile not found: {}".format(SOURCE_PROFILE))
        raise error


def get_identity(session):
    sts_client = session.client("sts")
    return sts_client.get_caller_identity()


def parse_role_name_from_arn(role_arn):
    return role_arn.split("/")[-1]


def parse_account_from_arn(role_arn):
    return role_arn.split(":")[4]


def is_already_target_role(identity, target_role_arn):
    current_arn = identity.get("Arn", "")
    current_account = identity.get("Account", "")

    target_account = parse_account_from_arn(target_role_arn)
    target_role_name = parse_role_name_from_arn(target_role_arn)

    expected_assumed_role_part = "assumed-role/{}/".format(target_role_name)

    return (
        current_account == target_account
        and expected_assumed_role_part in current_arn
    )


def assume_target_role(source_session):
    sts_client = source_session.client("sts")

    assume_role_params = {
        "RoleArn": TARGET_ROLE_ARN,
        "RoleSessionName": ROLE_SESSION_NAME
    }

    if EXTERNAL_ID:
        assume_role_params["ExternalId"] = EXTERNAL_ID

    response = sts_client.assume_role(**assume_role_params)
    credentials = response["Credentials"]

    assumed_session = boto3.Session(
        aws_access_key_id=credentials["AccessKeyId"],
        aws_secret_access_key=credentials["SecretAccessKey"],
        aws_session_token=credentials["SessionToken"],
        region_name=AWS_REGION
    )

    return assumed_session, credentials


def validate_session(session, title):
    identity = get_identity(session)

    print("")
    print(title)
    print("Account: {}".format(identity.get("Account")))
    print("Arn:     {}".format(identity.get("Arn")))
    print("UserId:  {}".format(identity.get("UserId")))

    return identity


def validate_ecr_access(session):
    """
    Optional ECR validation.
    This confirms whether the assumed role can call ECR describe_repositories.
    It does not print credentials.
    """

    ecr_client = session.client("ecr", region_name=AWS_REGION)

    try:
        response = ecr_client.describe_repositories(maxResults=10)

        print("")
        print("ECR access validation: SUCCESS")
        print("Repositories visible: {}".format(
            len(response.get("repositories", []))
        ))

        for repo in response.get("repositories", []):
            print("- {}".format(repo.get("repositoryName")))

    except ClientError as error:
        print("")
        print("ECR access validation: FAILED")
        print("Code:    {}".format(
            error.response.get("Error", {}).get("Code")
        ))
        print("Message: {}".format(
            error.response.get("Error", {}).get("Message")
        ))


def print_safe_credential_summary(credentials):
    """
    Prints only safe credential summary.
    Does not print SecretAccessKey or SessionToken.
    """

    access_key = credentials.get("AccessKeyId", "")
    expiration = credentials.get("Expiration", "")

    print("")
    print("AssumeRole successful")
    print("AccessKeyId prefix: {}********".format(access_key[:8]))
    print("Expiration:         {}".format(expiration))


def main():
    try:
        print("")
        print("AWS region:")
        print(AWS_REGION)

        print("")
        print("Target role ARN:")
        print(TARGET_ROLE_ARN)

        source_session = create_source_session()

        source_identity = validate_session(
            source_session,
            "Source AWS identity:"
        )

        if is_already_target_role(source_identity, TARGET_ROLE_ARN):
            print("")
            print("You are already using the target role.")
            print("Skipping sts.assume_role().")

            final_session = source_session

        else:
            print("")
            print("You are not currently using the target role.")
            print("Trying to assume target role...")

            final_session, credentials = assume_target_role(source_session)

            print_safe_credential_summary(credentials)

            validate_session(
                final_session,
                "Assumed AWS identity:"
            )

        validate_ecr_access(final_session)

    except NoCredentialsError:
        print("")
        print("ERROR: No AWS credentials found.")
        print("")
        print("Use one of these options:")
        print("- aws configure")
        print("- export SOURCE_PROFILE=<profile-name>")
        print("- export AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_SESSION_TOKEN")
        print("- Jenkins credentials binding")
        print("- EC2, ECS, or EKS IAM role")
        sys.exit(1)

    except ClientError as error:
        print("")
        print("AWS ClientError:")
        print("Code:    {}".format(
            error.response.get("Error", {}).get("Code")
        ))
        print("Message: {}".format(
            error.response.get("Error", {}).get("Message")
        ))

        print("")
        print("Common reasons:")
        print("- Source identity is not allowed to call sts:AssumeRole")
        print("- Target role trust policy does not trust the source identity")
        print("- ExternalId is wrong")
        print("- ExternalId was provided but target role does not expect it")
        print("- ExternalId is required but not provided")
        print("- Temporary source credentials expired")
        print("- Role ARN is incorrect")
        print("- AWS region is incorrect for the service call")
        print("- You are trying to assume the same role again without self-trust")

        sys.exit(1)

    except Exception as error:
        print("")
        print("Unexpected error:")
        print(str(error))
        sys.exit(1)


if __name__ == "__main__":
    main()
EOF

Explanation:
This script safely validates source AWS identity, assumes the target IAM role, checks the assumed identity, and optionally validates ECR access. It does not print SecretAccessKey or SessionToken.

------------------------------------------------------------
34.9 Make the script executable
------------------------------------------------------------

Command:
chmod +x assume_role_validate.py

Explanation:
Gives execute permission to the Python script.

Example:
chmod +x assume_role_validate.py

------------------------------------------------------------
34.10 Run the script using default AWS credential chain
------------------------------------------------------------

Command:
python3 assume_role_validate.py

Explanation:
Runs the script using default AWS credential resolution, such as environment variables, default AWS profile, SSO cache, EC2 role, ECS role, or Jenkins role.

Example:
python3 assume_role_validate.py

------------------------------------------------------------
34.11 Run the script using a specific source profile
------------------------------------------------------------

Command:
export SOURCE_PROFILE=<source-profile-name>
export AWS_REGION=<aws-region>
export TARGET_ROLE_ARN="arn:aws:iam::<target-account-id>:role/<target-role-name>"
export ROLE_SESSION_NAME="<role-session-name>"
export EXTERNAL_ID="<external-id>"
python3 assume_role_validate.py

Explanation:
Runs the script using a specific local AWS profile and assumes the target role.

Example:
export SOURCE_PROFILE=RIDY_AWS_RSSR86_APPADMDEV
export AWS_REGION=eu-west-1
export TARGET_ROLE_ARN="arn:aws:iam::065620475321:role/RIDY_AWS_RSSR86_APPADMV1"
export ROLE_SESSION_NAME="RIDY_AWS_RSSR86_APPADMV1"
export EXTERNAL_ID="12345"
python3 assume_role_validate.py

------------------------------------------------------------
34.12 Run the script using temporary environment credentials
------------------------------------------------------------

Command:
export AWS_ACCESS_KEY_ID="<source-access-key-id>"
export AWS_SECRET_ACCESS_KEY="<source-secret-access-key>"
export AWS_SESSION_TOKEN="<source-session-token>"
export AWS_REGION="<aws-region>"
export TARGET_ROLE_ARN="arn:aws:iam::<target-account-id>:role/<target-role-name>"
export ROLE_SESSION_NAME="<role-session-name>"
export EXTERNAL_ID="<external-id>"
python3 assume_role_validate.py

Explanation:
Uses temporary source credentials from environment variables, then assumes the configured target role.

Example:
export AWS_ACCESS_KEY_ID="<source-access-key-id>"
export AWS_SECRET_ACCESS_KEY="<source-secret-access-key>"
export AWS_SESSION_TOKEN="<source-session-token>"
export AWS_REGION="eu-west-1"
export TARGET_ROLE_ARN="arn:aws:iam::065620475321:role/RIDY_AWS_RSSR86_APPADMV1"
export ROLE_SESSION_NAME="RIDY_AWS_RSSR86_APPADMV1"
export EXTERNAL_ID="12345"
python3 assume_role_validate.py

Important:
Do not put real AWS credentials in this document.

------------------------------------------------------------
34.13 Check whether AssumeRole works using AWS CLI
------------------------------------------------------------

Command:
aws sts assume-role \
  --role-arn "arn:aws:iam::<target-account-id>:role/<target-role-name>" \
  --role-session-name "<role-session-name>" \
  --external-id "<external-id>"

Explanation:
Tests AWS STS AssumeRole directly from AWS CLI.

Example:
aws sts assume-role \
  --role-arn "arn:aws:iam::065620475321:role/RIDY_AWS_RSSR86_APPADMV1" \
  --role-session-name "RIDY_AWS_RSSR86_APPADMV1" \
  --external-id "12345"

Security Note:
This command returns temporary credentials. Do not paste the output into tickets, chats, Git, or documents.

------------------------------------------------------------
34.14 Check current identity after setting credentials
------------------------------------------------------------

Command:
aws sts get-caller-identity

Explanation:
Confirms which AWS identity is active after setting credentials or assuming a role.

Example:
aws sts get-caller-identity

------------------------------------------------------------
34.15 Validate ECR access using AWS CLI
------------------------------------------------------------

Command:
aws ecr describe-repositories --region <aws-region> --max-results 10

Explanation:
Checks whether the current AWS identity can access ECR repositories.

Example:
aws ecr describe-repositories --region eu-west-1 --max-results 10

------------------------------------------------------------
34.16 Login to AWS ECR
------------------------------------------------------------

Command:
aws ecr get-login-password --region <aws-region> | docker login --username AWS --password-stdin <account-id>.dkr.ecr.<aws-region>.amazonaws.com

Explanation:
Authenticates Docker to AWS ECR using the active AWS identity.

Example:
aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin <account-id>.dkr.ecr.eu-west-1.amazonaws.com

------------------------------------------------------------
34.17 Build Docker image for ECR
------------------------------------------------------------

Command:
docker build -t <account-id>.dkr.ecr.<aws-region>.amazonaws.com/<repository-name>:<tag> -f Dockerfile .

Explanation:
Builds and tags the Docker image for AWS ECR.

Example:
docker build -t <account-id>.dkr.ecr.eu-west-1.amazonaws.com/search_server:latest -f Dockerfile .

------------------------------------------------------------
34.18 Push Docker image to ECR
------------------------------------------------------------

Command:
docker push <account-id>.dkr.ecr.<aws-region>.amazonaws.com/<repository-name>:<tag>

Explanation:
Pushes the Docker image to AWS ECR.

Example:
docker push <account-id>.dkr.ecr.eu-west-1.amazonaws.com/search_server:latest

------------------------------------------------------------
34.19 Check whether region is valid
------------------------------------------------------------

Command:
aws ec2 describe-regions --query "Regions[].RegionName" --output table

Explanation:
Lists AWS regions available to the current AWS account.

Example:
aws ec2 describe-regions --query "Regions[].RegionName" --output table

Important:
Use a valid AWS region such as eu-west-1 or us-east-1. If a non-existing region is used, AWS commands may fail.

------------------------------------------------------------
34.20 Check IAM role details
------------------------------------------------------------

Command:
aws iam get-role --role-name <role-name>

Explanation:
Shows IAM role details if the current identity has permission to read IAM role information.

Example:
aws iam get-role --role-name RIDY_AWS_RSSR86_APPADMV1

------------------------------------------------------------
34.21 Check ECR repositories in a specific region
------------------------------------------------------------

Command:
aws ecr describe-repositories --region <region>

Explanation:
Lists ECR repositories in the selected AWS region.

Example:
aws ecr describe-repositories --region eu-west-1

------------------------------------------------------------
34.22 Check Docker authentication status indirectly
------------------------------------------------------------

Command:
docker pull <account-id>.dkr.ecr.<region>.amazonaws.com/<repository-name>:<tag>

Explanation:
Tests whether Docker can pull an image from ECR using the current Docker login session.

Example:
docker pull <account-id>.dkr.ecr.eu-west-1.amazonaws.com/search_server:latest

------------------------------------------------------------
34.23 Common AssumeRole errors and meaning
------------------------------------------------------------

Error:
AccessDenied

Meaning:
The source identity does not have permission to assume the target role, or the target role trust policy does not trust the source identity.

Fix:
Check source IAM policy and target role trust relationship.

------------------------------------------------------------

Error:
InvalidClientTokenId

Meaning:
The AWS access key, secret key, or session token is invalid.

Fix:
Refresh credentials and run aws sts get-caller-identity.

------------------------------------------------------------

Error:
ExpiredToken

Meaning:
Temporary AWS credentials have expired.

Fix:
Generate new temporary credentials or re-login using SSO.

------------------------------------------------------------

Error:
AccessDenied with ExternalId

Meaning:
ExternalId is missing, incorrect, or not expected by the target role trust policy.

Fix:
Confirm whether ExternalId is required and use the correct value.

------------------------------------------------------------

Error:
ProfileNotFound

Meaning:
The AWS profile set in SOURCE_PROFILE does not exist locally.

Fix:
Run aws configure list-profiles and use a valid profile.

------------------------------------------------------------

Error:
NoCredentialsError

Meaning:
boto3 could not find AWS credentials.

Fix:
Configure credentials using AWS profile, environment variables, SSO, Jenkins binding, or instance role.

------------------------------------------------------------
34.24 Safe checklist before running AWS role commands
------------------------------------------------------------

1. Confirm the source identity.

Command:
aws sts get-caller-identity

2. Confirm the region.

Command:
echo $AWS_REGION

3. Confirm configured profiles.

Command:
aws configure list-profiles

4. Confirm selected source profile if used.

Command:
echo $SOURCE_PROFILE

5. Confirm target role ARN.

Command:
echo $TARGET_ROLE_ARN

6. Run the Python validation script.

Command:
python3 assume_role_validate.py

7. Confirm assumed role identity from script output.

8. Validate ECR access.

Command:
aws ecr describe-repositories --region <aws-region> --max-results 10

9. Login to ECR.

Command:
aws ecr get-login-password --region <aws-region> | docker login --username AWS --password-stdin <account-id>.dkr.ecr.<aws-region>.amazonaws.com

10. Clear temporary environment variables after work.

Command:
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset AWS_SESSION_TOKEN
unset SOURCE_PROFILE
unset TARGET_ROLE_ARN
unset ROLE_SESSION_NAME
unset EXTERNAL_ID

END UPDATED SECTION

START ADDITIONAL UPDATED SECTION

============================================================
35. ADDITIONAL AWS CLI, STS, IAM, ECR, DOCKER, AND BOTO3 COMMANDS
============================================================

Purpose:
This section contains additional related commands for AWS STS AssumeRole, IAM role validation, ECR login, Docker build and push, AWS profile checks, SSO login, and boto3 troubleshooting.

Important Security Note:
Do not print, paste, store, or commit AWS SecretAccessKey, SessionToken, passwords, API keys, or private credentials.
If credentials are accidentally exposed, rotate or revoke them immediately.

============================================================
35.1 CHECK AWS CLI INSTALLATION
============================================================

Command:
aws --version

Explanation:
Checks whether AWS CLI is installed and shows the installed version.

Example:
aws --version

Expected output example:
aws-cli/2.x.x Python/3.x.x


============================================================
35.2 CHECK PYTHON AND BOTO3 INSTALLATION
============================================================

Command:
python3 --version

Explanation:
Checks the installed Python version.

Example:
python3 --version

------------------------------------------------------------

Command:
python3 -m pip show boto3

Explanation:
Checks whether boto3 is installed and shows version details.

Example:
python3 -m pip show boto3

------------------------------------------------------------

Command:
python3 -m pip install --upgrade boto3 botocore

Explanation:
Installs or upgrades boto3 and botocore packages.

Example:
python3 -m pip install --upgrade boto3 botocore

------------------------------------------------------------

Command:
python3 -c "import boto3; print(boto3.__version__)"

Explanation:
Prints the installed boto3 version.

Example:
python3 -c "import boto3; print(boto3.__version__)"


============================================================
35.3 CHECK AWS CLI CONFIGURATION
============================================================

Command:
aws configure list

Explanation:
Shows which credentials, region, and output format are currently being used by AWS CLI.

Example:
aws configure list

------------------------------------------------------------

Command:
aws configure list-profiles

Explanation:
Lists all AWS profiles configured on the local machine.

Example:
aws configure list-profiles

------------------------------------------------------------

Command:
aws configure get region

Explanation:
Shows the default AWS region configured for the current profile.

Example:
aws configure get region

------------------------------------------------------------

Command:
aws configure get region --profile <profile-name>

Explanation:
Shows the configured region for a specific AWS profile.

Example:
aws configure get region --profile dev-profile

------------------------------------------------------------

Command:
aws configure get role_arn --profile <profile-name>

Explanation:
Shows the role ARN configured for a profile, if the profile is role-based.

Example:
aws configure get role_arn --profile dev-profile

------------------------------------------------------------

Command:
aws configure get source_profile --profile <profile-name>

Explanation:
Shows the source profile used by a role-based profile.

Example:
aws configure get source_profile --profile dev-profile


============================================================
35.4 CHECK CURRENT AWS ENVIRONMENT VARIABLES
============================================================

Command:
env | grep '^AWS_'

Explanation:
Lists AWS-related environment variables currently set in the shell.

Example:
env | grep '^AWS_'

Security Note:
Do not share the output if it contains AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, or AWS_SESSION_TOKEN.

------------------------------------------------------------

Command:
echo $AWS_REGION

Explanation:
Prints the currently configured AWS region from environment variable.

Example:
echo $AWS_REGION

------------------------------------------------------------

Command:
echo $AWS_PROFILE

Explanation:
Prints the currently selected AWS profile from environment variable.

Example:
echo $AWS_PROFILE

------------------------------------------------------------

Command:
echo $SOURCE_PROFILE

Explanation:
Prints the custom SOURCE_PROFILE variable used by the Python AssumeRole script.

Example:
echo $SOURCE_PROFILE


============================================================
35.5 SET AWS REGION AND PROFILE
============================================================

Command:
export AWS_REGION=<aws-region>

Explanation:
Sets AWS region for the current shell session.

Example:
export AWS_REGION=eu-west-1

------------------------------------------------------------

Command:
export AWS_PROFILE=<profile-name>

Explanation:
Sets AWS CLI profile for the current shell session.

Example:
export AWS_PROFILE=dev-profile

------------------------------------------------------------

Command:
export SOURCE_PROFILE=<source-profile-name>

Explanation:
Sets source profile for the Python script that assumes a target IAM role.

Example:
export SOURCE_PROFILE=dev-profile


============================================================
35.6 CLEAR AWS ENVIRONMENT VARIABLES
============================================================

Command:
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset AWS_SESSION_TOKEN
unset AWS_PROFILE
unset AWS_REGION
unset SOURCE_PROFILE
unset TARGET_ROLE_ARN
unset ROLE_SESSION_NAME
unset EXTERNAL_ID

Explanation:
Clears AWS-related environment variables from the current shell session.

Example:
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset AWS_SESSION_TOKEN
unset AWS_PROFILE
unset AWS_REGION
unset SOURCE_PROFILE
unset TARGET_ROLE_ARN
unset ROLE_SESSION_NAME
unset EXTERNAL_ID


============================================================
35.7 AWS SSO LOGIN COMMANDS
============================================================

Command:
aws sso login --profile <profile-name>

Explanation:
Logs in to AWS using SSO for the selected profile.

Example:
aws sso login --profile dev-profile

------------------------------------------------------------

Command:
aws sts get-caller-identity --profile <profile-name>

Explanation:
Checks the AWS identity for a specific profile.

Example:
aws sts get-caller-identity --profile dev-profile

------------------------------------------------------------

Command:
aws sso logout

Explanation:
Logs out from AWS SSO cached sessions.

Example:
aws sso logout


============================================================
35.8 VERIFY CURRENT AWS IDENTITY
============================================================

Command:
aws sts get-caller-identity

Explanation:
Shows the AWS account, ARN, and user ID of the currently active credentials.

Example:
aws sts get-caller-identity

------------------------------------------------------------

Command:
aws sts get-caller-identity --query Account --output text

Explanation:
Prints only the AWS account ID of the current identity.

Example:
aws sts get-caller-identity --query Account --output text

------------------------------------------------------------

Command:
aws sts get-caller-identity --query Arn --output text

Explanation:
Prints only the ARN of the current AWS identity.

Example:
aws sts get-caller-identity --query Arn --output text


============================================================
35.9 SAFE ASSUME ROLE TEST WITHOUT PRINTING CREDENTIALS
============================================================

Command:
aws sts assume-role \
  --role-arn "arn:aws:iam::<target-account-id>:role/<target-role-name>" \
  --role-session-name "<role-session-name>" \
  --external-id "<external-id>" \
  --query 'AssumedRoleUser.Arn' \
  --output text

Explanation:
Safely tests whether AssumeRole works and prints only the assumed role ARN. It does not print SecretAccessKey or SessionToken.

Example:
aws sts assume-role \
  --role-arn "arn:aws:iam::065620475321:role/RIDY_AWS_RSSR86_APPADMV1" \
  --role-session-name "RIDY_AWS_RSSR86_APPADMV1" \
  --external-id "12345" \
  --query 'AssumedRoleUser.Arn' \
  --output text

Expected output example:
arn:aws:sts::065620475321:assumed-role/RIDY_AWS_RSSR86_APPADMV1/RIDY_AWS_RSSR86_APPADMV1


============================================================
35.10 ASSUME ROLE TEST WITHOUT EXTERNAL ID
============================================================

Command:
aws sts assume-role \
  --role-arn "arn:aws:iam::<target-account-id>:role/<target-role-name>" \
  --role-session-name "<role-session-name>" \
  --query 'AssumedRoleUser.Arn' \
  --output text

Explanation:
Tests AssumeRole when the target role trust policy does not require ExternalId.

Example:
aws sts assume-role \
  --role-arn "arn:aws:iam::065620475321:role/RIDY_AWS_RSSR86_APPADMV1" \
  --role-session-name "RIDY_AWS_RSSR86_APPADMV1" \
  --query 'AssumedRoleUser.Arn' \
  --output text


============================================================
35.11 CHECK IAM ROLE TRUST POLICY
============================================================

Command:
aws iam get-role \
  --role-name <role-name> \
  --query 'Role.AssumeRolePolicyDocument' \
  --output json

Explanation:
Shows the trust policy of an IAM role. This helps confirm which source identities are allowed to assume the role.

Example:
aws iam get-role \
  --role-name RIDY_AWS_RSSR86_APPADMV1 \
  --query 'Role.AssumeRolePolicyDocument' \
  --output json

Important:
This command requires IAM read permission.


============================================================
35.12 CHECK IAM ROLE BASIC DETAILS
============================================================

Command:
aws iam get-role --role-name <role-name>

Explanation:
Shows IAM role details such as role ID, ARN, path, trust policy, and creation date.

Example:
aws iam get-role --role-name RIDY_AWS_RSSR86_APPADMV1


============================================================
35.13 LIST POLICIES ATTACHED TO IAM ROLE
============================================================

Command:
aws iam list-attached-role-policies --role-name <role-name>

Explanation:
Lists managed IAM policies attached to a role.

Example:
aws iam list-attached-role-policies --role-name RIDY_AWS_RSSR86_APPADMV1

------------------------------------------------------------

Command:
aws iam list-role-policies --role-name <role-name>

Explanation:
Lists inline policies attached to a role.

Example:
aws iam list-role-policies --role-name RIDY_AWS_RSSR86_APPADMV1


============================================================
35.14 GET INLINE ROLE POLICY DOCUMENT
============================================================

Command:
aws iam get-role-policy \
  --role-name <role-name> \
  --policy-name <policy-name>

Explanation:
Shows the JSON document of an inline IAM role policy.

Example:
aws iam get-role-policy \
  --role-name RIDY_AWS_RSSR86_APPADMV1 \
  --policy-name InlinePolicyName


============================================================
35.15 SIMULATE WHETHER SOURCE CAN ASSUME TARGET ROLE
============================================================

Command:
aws iam simulate-principal-policy \
  --policy-source-arn <source-principal-arn> \
  --action-names sts:AssumeRole \
  --resource-arns <target-role-arn>

Explanation:
Simulates whether the source identity has permission to call sts:AssumeRole on the target role.

Example:
aws iam simulate-principal-policy \
  --policy-source-arn arn:aws:iam::<source-account-id>:role/<source-role-name> \
  --action-names sts:AssumeRole \
  --resource-arns arn:aws:iam::<target-account-id>:role/<target-role-name>

Important:
This checks identity-based policy permission. The target role trust policy must also allow the source identity.


============================================================
35.16 DECODE AWS AUTHORIZATION FAILURE MESSAGE
============================================================

Command:
aws sts decode-authorization-message \
  --encoded-message <encoded-message>

Explanation:
Decodes an encoded authorization failure message returned by some AWS AccessDenied errors.

Example:
aws sts decode-authorization-message \
  --encoded-message <encoded-message>

Important:
This requires permission for sts:DecodeAuthorizationMessage.


============================================================
35.17 CHECK AWS REGIONS
============================================================

Command:
aws ec2 describe-regions \
  --query "Regions[].RegionName" \
  --output table

Explanation:
Lists available AWS regions.

Example:
aws ec2 describe-regions \
  --query "Regions[].RegionName" \
  --output table

------------------------------------------------------------

Command:
aws configure get region

Explanation:
Shows the configured default region.

Example:
aws configure get region

Important:
Use valid AWS regions such as eu-west-1 or us-east-1. Invalid region names cause AWS service calls to fail.


============================================================
35.18 ECR LOGIN COMMANDS
============================================================

Command:
aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <account-id>.dkr.ecr.<region>.amazonaws.com

Explanation:
Logs Docker into AWS ECR using the currently active AWS identity.

Example:
aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin <account-id>.dkr.ecr.eu-west-1.amazonaws.com

------------------------------------------------------------

Command:
docker logout <account-id>.dkr.ecr.<region>.amazonaws.com

Explanation:
Logs Docker out from the ECR registry.

Example:
docker logout <account-id>.dkr.ecr.eu-west-1.amazonaws.com


============================================================
35.19 ECR REPOSITORY CHECK COMMANDS
============================================================

Command:
aws ecr describe-repositories --region <region>

Explanation:
Lists ECR repositories in the selected region.

Example:
aws ecr describe-repositories --region eu-west-1

------------------------------------------------------------

Command:
aws ecr describe-repositories \
  --repository-names <repository-name> \
  --region <region>

Explanation:
Checks whether a specific ECR repository exists.

Example:
aws ecr describe-repositories \
  --repository-names search_server \
  --region eu-west-1

------------------------------------------------------------

Command:
aws ecr list-images \
  --repository-name <repository-name> \
  --region <region>

Explanation:
Lists image IDs available in an ECR repository.

Example:
aws ecr list-images \
  --repository-name search_server \
  --region eu-west-1

------------------------------------------------------------

Command:
aws ecr describe-images \
  --repository-name <repository-name> \
  --region <region>

Explanation:
Shows image tags, image digests, push time, and image size.

Example:
aws ecr describe-images \
  --repository-name search_server \
  --region eu-west-1

------------------------------------------------------------

Command:
aws ecr describe-images \
  --repository-name <repository-name> \
  --image-ids imageTag=<tag> \
  --region <region>

Explanation:
Checks whether a specific image tag exists in ECR.

Example:
aws ecr describe-images \
  --repository-name search_server \
  --image-ids imageTag=latest \
  --region eu-west-1


============================================================
35.20 CREATE ECR REPOSITORY IF MISSING
============================================================

Command:
aws ecr create-repository \
  --repository-name <repository-name> \
  --region <region>

Explanation:
Creates a new ECR repository if it does not already exist.

Example:
aws ecr create-repository \
  --repository-name search_server \
  --region eu-west-1

Important:
Run this only if you have approval and repository creation permission.


============================================================
35.21 DOCKER BUILD, TAG, PUSH, AND PULL COMMANDS
============================================================

Command:
docker build -t <local-image-name>:<tag> -f Dockerfile .

Explanation:
Builds a local Docker image from a Dockerfile.

Example:
docker build -t search_server:latest -f Dockerfile .

------------------------------------------------------------

Command:
docker tag <local-image-name>:<tag> <account-id>.dkr.ecr.<region>.amazonaws.com/<repository-name>:<tag>

Explanation:
Tags a local Docker image for AWS ECR.

Example:
docker tag search_server:latest <account-id>.dkr.ecr.eu-west-1.amazonaws.com/search_server:latest

------------------------------------------------------------

Command:
docker push <account-id>.dkr.ecr.<region>.amazonaws.com/<repository-name>:<tag>

Explanation:
Pushes a Docker image to AWS ECR.

Example:
docker push <account-id>.dkr.ecr.eu-west-1.amazonaws.com/search_server:latest

------------------------------------------------------------

Command:
docker pull <account-id>.dkr.ecr.<region>.amazonaws.com/<repository-name>:<tag>

Explanation:
Pulls a Docker image from AWS ECR to validate image availability and Docker authentication.

Example:
docker pull <account-id>.dkr.ecr.eu-west-1.amazonaws.com/search_server:latest

------------------------------------------------------------

Command:
docker images | grep <repository-name>

Explanation:
Checks whether the image exists locally.

Example:
docker images | grep search_server

------------------------------------------------------------

Command:
docker inspect <image-name>:<tag>

Explanation:
Shows detailed metadata for a Docker image.

Example:
docker inspect search_server:latest


============================================================
35.22 DOCKER CLEANUP COMMANDS
============================================================

Command:
docker system df

Explanation:
Shows Docker disk usage.

Example:
docker system df

------------------------------------------------------------

Command:
docker image prune

Explanation:
Removes dangling Docker images.

Example:
docker image prune

------------------------------------------------------------

Command:
docker image prune -a

Explanation:
Removes unused Docker images. Use carefully because it may remove images not currently used by containers.

Example:
docker image prune -a

------------------------------------------------------------

Command:
docker rmi <image-id>

Explanation:
Removes a specific local Docker image.

Example:
docker rmi <image-id>


============================================================
35.23 SAFE BOTO3 IDENTITY TEST SCRIPT
============================================================

File name:
aws_identity_check.py

Command:
cat > aws_identity_check.py <<'EOF'
#!/usr/bin/env python3

import boto3
from botocore.exceptions import ClientError, NoCredentialsError

try:
    session = boto3.Session()
    sts = session.client("sts")
    identity = sts.get_caller_identity()

    print("AWS identity check successful")
    print("Account:", identity.get("Account"))
    print("Arn:    ", identity.get("Arn"))
    print("UserId: ", identity.get("UserId"))

except NoCredentialsError:
    print("ERROR: No AWS credentials found")

except ClientError as error:
    print("AWS ClientError")
    print("Code:", error.response.get("Error", {}).get("Code"))
    print("Message:", error.response.get("Error", {}).get("Message"))
EOF

Explanation:
Creates a safe Python script to check the current AWS identity without printing any secrets.

Run command:
python3 aws_identity_check.py


============================================================
35.24 SAFE BOTO3 ECR CHECK SCRIPT
============================================================

File name:
ecr_check.py

Command:
cat > ecr_check.py <<'EOF'
#!/usr/bin/env python3

import os
import boto3
from botocore.exceptions import ClientError, NoCredentialsError

region = os.environ.get("AWS_REGION", "eu-west-1")

try:
    session = boto3.Session(region_name=region)
    ecr = session.client("ecr", region_name=region)

    response = ecr.describe_repositories(maxResults=10)

    print("ECR access successful")
    print("Region:", region)
    print("Repositories visible:", len(response.get("repositories", [])))

    for repo in response.get("repositories", []):
        print("-", repo.get("repositoryName"))

except NoCredentialsError:
    print("ERROR: No AWS credentials found")

except ClientError as error:
    print("ECR access failed")
    print("Code:", error.response.get("Error", {}).get("Code"))
    print("Message:", error.response.get("Error", {}).get("Message"))
EOF

Explanation:
Creates a safe Python script to test ECR access using the active AWS identity. It does not print credentials.

Run command:
python3 ecr_check.py


============================================================
35.25 SAFE BOTO3 ASSUME ROLE TEST WITHOUT PRINTING SECRETS
============================================================

File name:
safe_assume_role_test.py

Command:
cat > safe_assume_role_test.py <<'EOF'
#!/usr/bin/env python3

import os
import boto3
from botocore.exceptions import ClientError, NoCredentialsError

target_role_arn = os.environ.get("TARGET_ROLE_ARN")
role_session_name = os.environ.get("ROLE_SESSION_NAME", "safe-assume-role-test")
external_id = os.environ.get("EXTERNAL_ID")
region = os.environ.get("AWS_REGION", "eu-west-1")

if not target_role_arn:
    print("ERROR: TARGET_ROLE_ARN is not set")
    raise SystemExit(1)

try:
    session = boto3.Session(region_name=region)
    sts = session.client("sts")

    params = {
        "RoleArn": target_role_arn,
        "RoleSessionName": role_session_name
    }

    if external_id:
        params["ExternalId"] = external_id

    response = sts.assume_role(**params)

    print("AssumeRole successful")
    print("AssumedRoleArn:", response.get("AssumedRoleUser", {}).get("Arn"))
    print("AccessKeyId prefix:", response["Credentials"]["AccessKeyId"][:8] + "********")
    print("Expiration:", response["Credentials"]["Expiration"])

except NoCredentialsError:
    print("ERROR: No AWS credentials found")

except ClientError as error:
    print("AssumeRole failed")
    print("Code:", error.response.get("Error", {}).get("Code"))
    print("Message:", error.response.get("Error", {}).get("Message"))
EOF

Explanation:
Creates a safe AssumeRole test script. It validates role assumption but does not print SecretAccessKey or SessionToken.

Run command:
export TARGET_ROLE_ARN="arn:aws:iam::<target-account-id>:role/<target-role-name>"
export ROLE_SESSION_NAME="<role-session-name>"
export EXTERNAL_ID="<external-id>"
export AWS_REGION="<region>"
python3 safe_assume_role_test.py

Example:
export TARGET_ROLE_ARN="arn:aws:iam::065620475321:role/RIDY_AWS_RSSR86_APPADMV1"
export ROLE_SESSION_NAME="RIDY_AWS_RSSR86_APPADMV1"
export EXTERNAL_ID="12345"
export AWS_REGION="eu-west-1"
python3 safe_assume_role_test.py


============================================================
35.26 AWS CLI DEBUG COMMANDS
============================================================

Command:
aws sts get-caller-identity --debug

Explanation:
Runs the identity check with detailed debug logs. Use this only for local troubleshooting.

Example:
aws sts get-caller-identity --debug

Security Note:
Debug logs may contain sensitive request metadata. Do not share debug logs without reviewing and redacting them.

------------------------------------------------------------

Command:
aws ecr describe-repositories --region <region> --debug

Explanation:
Runs ECR repository listing with debug logs.

Example:
aws ecr describe-repositories --region eu-west-1 --debug

Security Note:
Do not paste full debug output into tickets or chats without redaction.


============================================================
35.27 CLOUDTRAIL LOOKUP FOR ASSUME ROLE EVENTS
============================================================

Command:
aws cloudtrail lookup-events \
  --lookup-attributes AttributeKey=EventName,AttributeValue=AssumeRole \
  --max-results 10

Explanation:
Searches recent CloudTrail events for AssumeRole activity.

Example:
aws cloudtrail lookup-events \
  --lookup-attributes AttributeKey=EventName,AttributeValue=AssumeRole \
  --max-results 10

Important:
This requires CloudTrail lookup permission.

------------------------------------------------------------

Command:
aws cloudtrail lookup-events \
  --lookup-attributes AttributeKey=Username,AttributeValue=<role-session-name> \
  --max-results 10

Explanation:
Searches CloudTrail events for a specific username or role session name.

Example:
aws cloudtrail lookup-events \
  --lookup-attributes AttributeKey=Username,AttributeValue=RIDY_AWS_RSSR86_APPADMV1 \
  --max-results 10


============================================================
35.28 JQ COMMANDS FOR AWS JSON OUTPUT
============================================================

Command:
aws sts get-caller-identity | jq .

Explanation:
Formats AWS identity output using jq.

Example:
aws sts get-caller-identity | jq .

------------------------------------------------------------

Command:
aws ecr describe-repositories --region <region> | jq '.repositories[].repositoryName'

Explanation:
Prints only ECR repository names.

Example:
aws ecr describe-repositories --region eu-west-1 | jq '.repositories[].repositoryName'

------------------------------------------------------------

Command:
aws ecr describe-images --repository-name <repository-name> --region <region> | jq '.imageDetails[].imageTags'

Explanation:
Prints image tags from an ECR repository.

Example:
aws ecr describe-images --repository-name search_server --region eu-west-1 | jq '.imageDetails[].imageTags'


============================================================
35.29 NETWORK AND PROXY CHECKS FOR AWS CLI
============================================================

Command:
env | grep -i proxy

Explanation:
Checks whether proxy environment variables are set.

Example:
env | grep -i proxy

------------------------------------------------------------

Command:
curl -I https://sts.amazonaws.com

Explanation:
Checks basic connectivity to AWS STS global endpoint.

Example:
curl -I https://sts.amazonaws.com

------------------------------------------------------------

Command:
curl -I https://ecr.<region>.amazonaws.com

Explanation:
Checks basic connectivity to the regional ECR endpoint.

Example:
curl -I https://ecr.eu-west-1.amazonaws.com

------------------------------------------------------------

Command:
export HTTPS_PROXY=<proxy-url>
export HTTP_PROXY=<proxy-url>
export NO_PROXY=<comma-separated-hosts>

Explanation:
Sets proxy variables if your environment requires a corporate proxy.

Example:
export HTTPS_PROXY=http://proxy.example.com:8080
export HTTP_PROXY=http://proxy.example.com:8080
export NO_PROXY=localhost,127.0.0.1


============================================================
35.30 COMMON AWS ASSUME ROLE TROUBLESHOOTING COMMAND FLOW
============================================================

Step 1: Check AWS CLI version.

Command:
aws --version

Step 2: Check current AWS configuration.

Command:
aws configure list

Step 3: Check available profiles.

Command:
aws configure list-profiles

Step 4: Set source profile if required.

Command:
export SOURCE_PROFILE=<source-profile-name>

Step 5: Set AWS region.

Command:
export AWS_REGION=<region>

Step 6: Confirm current identity.

Command:
aws sts get-caller-identity

Step 7: Safely test AssumeRole without printing credentials.

Command:
aws sts assume-role \
  --role-arn "arn:aws:iam::<target-account-id>:role/<target-role-name>" \
  --role-session-name "<role-session-name>" \
  --external-id "<external-id>" \
  --query 'AssumedRoleUser.Arn' \
  --output text

Step 8: Run Python AssumeRole validation script.

Command:
python3 assume_role_validate.py

Step 9: Validate ECR access.

Command:
aws ecr describe-repositories --region <region> --max-results 10

Step 10: Login to ECR.

Command:
aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <account-id>.dkr.ecr.<region>.amazonaws.com

Step 11: Build Docker image.

Command:
docker build -t <local-image-name>:<tag> -f Dockerfile .

Step 12: Tag Docker image.

Command:
docker tag <local-image-name>:<tag> <account-id>.dkr.ecr.<region>.amazonaws.com/<repository-name>:<tag>

Step 13: Push Docker image.

Command:
docker push <account-id>.dkr.ecr.<region>.amazonaws.com/<repository-name>:<tag>

Step 14: Verify image exists in ECR.

Command:
aws ecr describe-images \
  --repository-name <repository-name> \
  --image-ids imageTag=<tag> \
  --region <region>

Step 15: Clear temporary variables.

Command:
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset AWS_SESSION_TOKEN
unset AWS_PROFILE
unset AWS_REGION
unset SOURCE_PROFILE
unset TARGET_ROLE_ARN
unset ROLE_SESSION_NAME
unset EXTERNAL_ID


============================================================
35.31 COMMON ERRORS AND FIXES
============================================================

Error:
Unable to locate credentials

Meaning:
AWS CLI or boto3 cannot find credentials.

Fix commands:
aws configure list
aws configure list-profiles
aws sso login --profile <profile-name>
export AWS_PROFILE=<profile-name>
aws sts get-caller-identity

------------------------------------------------------------

Error:
ExpiredToken

Meaning:
Temporary AWS credentials expired.

Fix commands:
aws sso login --profile <profile-name>
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset AWS_SESSION_TOKEN
aws sts get-caller-identity

------------------------------------------------------------

Error:
AccessDenied when calling AssumeRole

Meaning:
The source identity does not have sts:AssumeRole permission or the target role trust policy does not trust the source identity.

Check commands:
aws sts get-caller-identity
aws iam get-role --role-name <target-role-name> --query 'Role.AssumeRolePolicyDocument' --output json
aws iam simulate-principal-policy --policy-source-arn <source-principal-arn> --action-names sts:AssumeRole --resource-arns <target-role-arn>

------------------------------------------------------------

Error:
InvalidClientTokenId

Meaning:
AWS credentials are invalid or incorrectly copied.

Fix commands:
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset AWS_SESSION_TOKEN
aws sso login --profile <profile-name>
aws sts get-caller-identity

------------------------------------------------------------

Error:
The security token included in the request is expired

Meaning:
The session token is expired.

Fix commands:
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset AWS_SESSION_TOKEN
aws sso login --profile <profile-name>

------------------------------------------------------------

Error:
ProfileNotFound

Meaning:
The selected AWS profile does not exist locally.

Fix commands:
aws configure list-profiles
export AWS_PROFILE=<valid-profile-name>

------------------------------------------------------------

Error:
Cannot perform an interactive login from a non TTY device

Meaning:
AWS SSO login was attempted in a non-interactive environment such as Jenkins.

Fix:
Use Jenkins credentials binding, instance role, OIDC, or a non-interactive approved authentication method.

------------------------------------------------------------

Error:
no basic auth credentials during docker push

Meaning:
Docker is not logged into ECR.

Fix command:
aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <account-id>.dkr.ecr.<region>.amazonaws.com

------------------------------------------------------------

Error:
repository does not exist or may require authorization

Meaning:
The ECR repository does not exist, region is wrong, account ID is wrong, or the role does not have permission.

Check commands:
aws ecr describe-repositories --region <region>
aws ecr describe-repositories --repository-names <repository-name> --region <region>
aws sts get-caller-identity

------------------------------------------------------------

Error:
denied: User is not authorized to perform ecr:PutImage

Meaning:
The current role does not have permission to push images to ECR.

Required permissions usually include:
ecr:GetAuthorizationToken
ecr:BatchCheckLayerAvailability
ecr:InitiateLayerUpload
ecr:UploadLayerPart
ecr:CompleteLayerUpload
ecr:PutImage

Check with your AWS administrator before modifying IAM permissions.


============================================================
35.32 MINIMUM ECR PUSH PERMISSIONS
============================================================

Purpose:
The IAM role used for Docker push to ECR usually needs the following permissions.

Required actions:
ecr:GetAuthorizationToken
ecr:BatchCheckLayerAvailability
ecr:InitiateLayerUpload
ecr:UploadLayerPart
ecr:CompleteLayerUpload
ecr:PutImage
ecr:DescribeRepositories
ecr:DescribeImages

Explanation:
These permissions allow Docker to authenticate to ECR, check existing layers, upload missing layers, and publish the image tag.

Important:
IAM permission changes should be handled by the authorized AWS or cloud operations team.


============================================================
35.33 MINIMUM ECR PULL PERMISSIONS
============================================================

Purpose:
The IAM role used for Docker pull from ECR usually needs the following permissions.

Required actions:
ecr:GetAuthorizationToken
ecr:BatchGetImage
ecr:GetDownloadUrlForLayer
ecr:DescribeRepositories
ecr:DescribeImages

Explanation:
These permissions allow Docker or Kubernetes nodes to pull container images from ECR.

Important:
IAM permission changes should be handled by the authorized AWS or cloud operations team.


============================================================
35.34 SAFE JENKINS COMMAND CHECKS FOR AWS BUILDS
============================================================

Command:
whoami

Explanation:
Shows the user running inside the Jenkins build agent.

Example:
whoami

------------------------------------------------------------

Command:
pwd

Explanation:
Shows the current Jenkins workspace directory.

Example:
pwd

------------------------------------------------------------

Command:
aws --version

Explanation:
Checks whether AWS CLI is available in the Jenkins agent.

Example:
aws --version

------------------------------------------------------------

Command:
docker --version

Explanation:
Checks whether Docker is available in the Jenkins agent.

Example:
docker --version

------------------------------------------------------------

Command:
aws sts get-caller-identity

Explanation:
Checks which AWS identity Jenkins is using.

Example:
aws sts get-caller-identity

------------------------------------------------------------

Command:
env | grep '^AWS_'

Explanation:
Checks AWS environment variables in Jenkins.

Example:
env | grep '^AWS_'

Security Note:
Do not print full secrets in Jenkins logs. Mask credentials using Jenkins credential bindings.


============================================================
35.35 SAFE END TO END AWS ECR PUSH EXAMPLE
============================================================

Step 1: Set region.

Command:
export AWS_REGION=eu-west-1

Step 2: Confirm AWS identity.

Command:
aws sts get-caller-identity

Step 3: Safely test AssumeRole.

Command:
aws sts assume-role \
  --role-arn "arn:aws:iam::<target-account-id>:role/<target-role-name>" \
  --role-session-name "<role-session-name>" \
  --external-id "<external-id>" \
  --query 'AssumedRoleUser.Arn' \
  --output text

Step 4: Login to ECR.

Command:
aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin <account-id>.dkr.ecr.eu-west-1.amazonaws.com

Step 5: Build image.

Command:
docker build -t search_server:latest -f Dockerfile .

Step 6: Tag image.

Command:
docker tag search_server:latest <account-id>.dkr.ecr.eu-west-1.amazonaws.com/search_server:latest

Step 7: Push image.

Command:
docker push <account-id>.dkr.ecr.eu-west-1.amazonaws.com/search_server:latest

Step 8: Verify image in ECR.

Command:
aws ecr describe-images \
  --repository-name search_server \
  --image-ids imageTag=latest \
  --region eu-west-1

Step 9: Logout from ECR if needed.

Command:
docker logout <account-id>.dkr.ecr.eu-west-1.amazonaws.com

Step 10: Clear temporary variables.

Command:
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset AWS_SESSION_TOKEN
unset AWS_PROFILE
unset AWS_REGION
unset SOURCE_PROFILE
unset TARGET_ROLE_ARN
unset ROLE_SESSION_NAME
unset EXTERNAL_ID

END ADDITIONAL UPDATED SECTION

START UPDATED LINUX GIT K8S TROUBLESHOOTING SECTION

============================================================
36. LINUX BASIC SYSTEM COMMANDS
============================================================

Purpose:
This section contains useful Linux commands for checking system details, files, folders, disk usage, memory, CPU, processes, permissions, networking, logs, and troubleshooting.

Important Security Note:
Do not print or share files that contain passwords, tokens, certificates, private keys, kubeconfig files, AWS credentials, API keys, database passwords, or storage keys.

============================================================
36.1 CHECK CURRENT USER AND SYSTEM DETAILS
============================================================

Command:
whoami

Explanation:
Shows the current logged-in user.

Example:
whoami

------------------------------------------------------------

Command:
id

Explanation:
Shows user ID, group ID, and group membership for the current user.

Example:
id

------------------------------------------------------------

Command:
hostname

Explanation:
Shows the system hostname.

Example:
hostname

------------------------------------------------------------

Command:
hostname -i

Explanation:
Shows the IP address assigned to the hostname.

Example:
hostname -i

------------------------------------------------------------

Command:
uname -a

Explanation:
Shows Linux kernel and operating system information.

Example:
uname -a

------------------------------------------------------------

Command:
cat /etc/os-release

Explanation:
Shows Linux distribution details such as Ubuntu, Debian, Red Hat, Alpine, or CentOS.

Example:
cat /etc/os-release

------------------------------------------------------------

Command:
date

Explanation:
Shows current system date and time.

Example:
date

------------------------------------------------------------

Command:
uptime

Explanation:
Shows how long the system has been running and current load average.

Example:
uptime


============================================================
36.2 FILE AND DIRECTORY COMMANDS
============================================================

Command:
pwd

Explanation:
Shows the current working directory.

Example:
pwd

------------------------------------------------------------

Command:
ls

Explanation:
Lists files and folders in the current directory.

Example:
ls

------------------------------------------------------------

Command:
ls -lah

Explanation:
Lists files and folders with permissions, owner, size, and hidden files.

Example:
ls -lah

------------------------------------------------------------

Command:
cd <directory-path>

Explanation:
Changes the current directory.

Example:
cd /var/log

------------------------------------------------------------

Command:
mkdir <directory-name>

Explanation:
Creates a new directory.

Example:
mkdir backup

------------------------------------------------------------

Command:
mkdir -p <directory-path>

Explanation:
Creates a full directory path if it does not already exist.

Example:
mkdir -p /tmp/app/logs

------------------------------------------------------------

Command:
touch <file-name>

Explanation:
Creates an empty file or updates the timestamp of an existing file.

Example:
touch test.txt

------------------------------------------------------------

Command:
cp <source-file> <destination-file>

Explanation:
Copies a file from source to destination.

Example:
cp app.log app.log.bak

------------------------------------------------------------

Command:
cp -r <source-directory> <destination-directory>

Explanation:
Copies a directory recursively.

Example:
cp -r config config-backup

------------------------------------------------------------

Command:
mv <source> <destination>

Explanation:
Moves or renames a file or directory.

Example:
mv old-name.txt new-name.txt

------------------------------------------------------------

Command:
rm <file-name>

Explanation:
Deletes a file.

Example:
rm old.log

------------------------------------------------------------

Command:
rm -rf <directory-path>

Explanation:
Deletes a directory and all files under it. Use carefully.

Example:
rm -rf /tmp/old-cache

Warning:
Do not run rm -rf on system paths such as /, /etc, /var, /usr, or application data paths unless you are fully authorized and have a backup.


============================================================
36.3 VIEW FILE CONTENT
============================================================

Command:
cat <file-name>

Explanation:
Prints the full file content.

Example:
cat app.log

------------------------------------------------------------

Command:
less <file-name>

Explanation:
Opens a file page by page.

Example:
less app.log

------------------------------------------------------------

Command:
head <file-name>

Explanation:
Shows the first 10 lines of a file.

Example:
head app.log

------------------------------------------------------------

Command:
head -n 50 <file-name>

Explanation:
Shows the first 50 lines of a file.

Example:
head -n 50 app.log

------------------------------------------------------------

Command:
tail <file-name>

Explanation:
Shows the last 10 lines of a file.

Example:
tail app.log

------------------------------------------------------------

Command:
tail -n 100 <file-name>

Explanation:
Shows the last 100 lines of a file.

Example:
tail -n 100 app.log

------------------------------------------------------------

Command:
tail -f <file-name>

Explanation:
Continuously follows a log file.

Example:
tail -f application.log

------------------------------------------------------------

Command:
tail -f <file-name> | grep "<search-text>"

Explanation:
Continuously follows a log file and filters matching lines.

Example:
tail -f application.log | grep "ERROR"


============================================================
36.4 SEARCH FILES AND TEXT
============================================================

Command:
find . -name "<file-pattern>"

Explanation:
Searches for files by name under the current directory.

Example:
find . -name "app*.log"

------------------------------------------------------------

Command:
find /path -type f -name "<file-name>"

Explanation:
Searches for a file under a specific path.

Example:
find /var/log -type f -name "application.log"

------------------------------------------------------------

Command:
grep "<text>" <file-name>

Explanation:
Searches for text inside a file.

Example:
grep "ERROR" application.log

------------------------------------------------------------

Command:
grep -i "<text>" <file-name>

Explanation:
Searches text case-insensitively.

Example:
grep -i "error" application.log

------------------------------------------------------------

Command:
grep -R "<text>" <directory-path>

Explanation:
Searches text recursively inside all files under a directory.

Example:
grep -R "database connection" /var/log/app

------------------------------------------------------------

Command:
grep -n "<text>" <file-name>

Explanation:
Shows matching lines with line numbers.

Example:
grep -n "ERROR" application.log

------------------------------------------------------------

Command:
egrep "<pattern1>|<pattern2>" <file-name>

Explanation:
Searches multiple patterns in a file.

Example:
egrep "ERROR|WARN|FAILED" application.log


============================================================
36.5 DISK AND STORAGE COMMANDS
============================================================

Command:
df -h

Explanation:
Shows mounted filesystem disk usage in human-readable format.

Example:
df -h

------------------------------------------------------------

Command:
du -sh <path>

Explanation:
Shows total size of a file or directory.

Example:
du -sh /var/log

------------------------------------------------------------

Command:
du -ah <path> | sort -hr | head -20

Explanation:
Shows the top 20 largest files and folders under a path.

Example:
du -ah /var/lib/clickhouse | sort -hr | head -20

------------------------------------------------------------

Command:
lsblk

Explanation:
Lists block devices and mounted disks.

Example:
lsblk

------------------------------------------------------------

Command:
mount

Explanation:
Shows mounted filesystems.

Example:
mount

------------------------------------------------------------

Command:
find <path> -type f -size +100M

Explanation:
Finds files larger than 100 MB.

Example:
find /var/log -type f -size +100M


============================================================
36.6 MEMORY AND CPU COMMANDS
============================================================

Command:
free -h

Explanation:
Shows memory usage in human-readable format.

Example:
free -h

------------------------------------------------------------

Command:
top

Explanation:
Shows real-time CPU and memory usage.

Example:
top

------------------------------------------------------------

Command:
htop

Explanation:
Shows interactive process monitoring if htop is installed.

Example:
htop

------------------------------------------------------------

Command:
ps aux

Explanation:
Shows all running processes.

Example:
ps aux

------------------------------------------------------------

Command:
ps aux | sort -rk 3,3 | head -n 10

Explanation:
Shows the top 10 CPU-consuming processes.

Example:
ps aux | sort -rk 3,3 | head -n 10

------------------------------------------------------------

Command:
ps aux | sort -rk 4,4 | head -n 10

Explanation:
Shows the top 10 memory-consuming processes.

Example:
ps aux | sort -rk 4,4 | head -n 10

------------------------------------------------------------

Command:
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -20

Explanation:
Shows top memory-consuming processes with PID, parent PID, command, memory, and CPU percentage.

Example:
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -20


============================================================
36.7 PROCESS MANAGEMENT COMMANDS
============================================================

Command:
pgrep <process-name>

Explanation:
Finds process IDs by process name.

Example:
pgrep python

------------------------------------------------------------

Command:
ps -ef | grep <process-name>

Explanation:
Searches running processes by name.

Example:
ps -ef | grep python

------------------------------------------------------------

Command:
kill <pid>

Explanation:
Stops a process using its process ID.

Example:
kill 12345

------------------------------------------------------------

Command:
kill -9 <pid>

Explanation:
Force kills a process. Use only if normal kill does not work.

Example:
kill -9 12345

Warning:
Force killing application processes can interrupt service. Use only when approved.


============================================================
36.8 PERMISSION COMMANDS
============================================================

Command:
ls -l <file-name>

Explanation:
Shows file permissions, owner, group, and size.

Example:
ls -l app.sh

------------------------------------------------------------

Command:
chmod +x <file-name>

Explanation:
Adds execute permission to a file.

Example:
chmod +x script.sh

------------------------------------------------------------

Command:
chmod 600 <file-name>

Explanation:
Allows only the file owner to read and write the file. Commonly used for private keys.

Example:
chmod 600 private-key.pem

------------------------------------------------------------

Command:
chown <user>:<group> <file-name>

Explanation:
Changes file owner and group.

Example:
chown appuser:appgroup app.log

------------------------------------------------------------

Command:
chown -R <user>:<group> <directory-path>

Explanation:
Changes ownership recursively for a directory.

Example:
chown -R appuser:appgroup /data/app


============================================================
36.9 NETWORK COMMANDS
============================================================

Command:
ip addr

Explanation:
Shows network interfaces and IP addresses.

Example:
ip addr

------------------------------------------------------------

Command:
ip route

Explanation:
Shows routing table.

Example:
ip route

------------------------------------------------------------

Command:
nslookup <hostname>

Explanation:
Checks DNS resolution.

Example:
nslookup google.com

------------------------------------------------------------

Command:
getent hosts <hostname>

Explanation:
Checks hostname resolution using system resolver.

Example:
getent hosts google.com

------------------------------------------------------------

Command:
curl -I <url>

Explanation:
Checks HTTP or HTTPS response headers.

Example:
curl -I https://example.com

------------------------------------------------------------

Command:
curl -v <url>

Explanation:
Tests HTTP or HTTPS connectivity with verbose output.

Example:
curl -v https://example.com

------------------------------------------------------------

Command:
nc -zv <hostname> <port>

Explanation:
Tests TCP connectivity to a host and port.

Example:
nc -zv example.com 443

------------------------------------------------------------

Command:
netstat -tuln

Explanation:
Shows listening TCP and UDP ports if netstat is available.

Example:
netstat -tuln

------------------------------------------------------------

Command:
ss -tuln

Explanation:
Shows listening TCP and UDP ports. This is a modern replacement for netstat.

Example:
ss -tuln

------------------------------------------------------------

Command:
traceroute <hostname>

Explanation:
Shows network route to a hostname if traceroute is installed.

Example:
traceroute example.com


============================================================
36.10 ARCHIVE AND COMPRESSION COMMANDS
============================================================

Command:
tar -czf <archive-name>.tar.gz <directory-path>

Explanation:
Creates a compressed tar archive.

Example:
tar -czf logs-backup.tar.gz /var/log/app

------------------------------------------------------------

Command:
tar -xzf <archive-name>.tar.gz

Explanation:
Extracts a compressed tar archive.

Example:
tar -xzf logs-backup.tar.gz

------------------------------------------------------------

Command:
zip -r <archive-name>.zip <directory-path>

Explanation:
Creates a zip archive.

Example:
zip -r app-config.zip config

------------------------------------------------------------

Command:
unzip <archive-name>.zip

Explanation:
Extracts a zip archive.

Example:
unzip app-config.zip


============================================================
37. GIT COMMANDS AND TROUBLESHOOTING
============================================================

Purpose:
This section contains Git commands for configuration, branch management, pull, fetch, merge, rebase, stash, commit, push, rollback, conflict resolution, logs, and troubleshooting.

Important Security Note:
Do not commit passwords, tokens, kubeconfig files, AWS credentials, private keys, certificates, storage keys, or .env files into Git.

============================================================
37.1 GIT CONFIGURATION COMMANDS
============================================================

Command:
git config --global user.name "<name>"

Explanation:
Sets global Git username.

Example:
git config --global user.name "User Name"

------------------------------------------------------------

Command:
git config --global user.email "<email>"

Explanation:
Sets global Git email.

Example:
git config --global user.email "user@example.com"

------------------------------------------------------------

Command:
git config --global --list

Explanation:
Shows global Git configuration.

Example:
git config --global --list

------------------------------------------------------------

Command:
git config --list

Explanation:
Shows Git configuration applied to the current repository.

Example:
git config --list


============================================================
37.2 GIT REPOSITORY STATUS COMMANDS
============================================================

Command:
git status

Explanation:
Shows current branch, modified files, staged files, and untracked files.

Example:
git status

------------------------------------------------------------

Command:
git branch

Explanation:
Lists local branches.

Example:
git branch

------------------------------------------------------------

Command:
git branch -a

Explanation:
Lists local and remote branches.

Example:
git branch -a

------------------------------------------------------------

Command:
git remote -v

Explanation:
Shows remote repository URLs.

Example:
git remote -v

------------------------------------------------------------

Command:
git log --oneline -10

Explanation:
Shows the last 10 commits in short format.

Example:
git log --oneline -10

------------------------------------------------------------

Command:
git log --graph --oneline --decorate --all

Explanation:
Shows commit history as a graph.

Example:
git log --graph --oneline --decorate --all


============================================================
37.3 GIT CLONE, FETCH, PULL, AND CHECKOUT
============================================================

Command:
git clone <repository-url>

Explanation:
Clones a Git repository to your local machine.

Example:
git clone https://github.com/example/repo.git

------------------------------------------------------------

Command:
git fetch origin

Explanation:
Downloads latest branch and commit information from the remote repository without merging.

Example:
git fetch origin

------------------------------------------------------------

Command:
git checkout <branch-name>

Explanation:
Switches to an existing branch.

Example:
git checkout preprod_jenkinsfile

------------------------------------------------------------

Command:
git checkout -b <new-branch-name>

Explanation:
Creates and switches to a new branch.

Example:
git checkout -b feature/update-deployment

------------------------------------------------------------

Command:
git pull origin <branch-name>

Explanation:
Pulls and merges latest changes from a remote branch.

Example:
git pull origin main

------------------------------------------------------------

Command:
git pull --rebase origin <branch-name>

Explanation:
Pulls latest changes and rebases local commits on top of remote changes.

Example:
git pull --rebase origin main


============================================================
37.4 GIT ADD, COMMIT, AND PUSH
============================================================

Command:
git add <file-name>

Explanation:
Stages a specific file for commit.

Example:
git add deployment.yml

------------------------------------------------------------

Command:
git add .

Explanation:
Stages all changed files.

Example:
git add .

------------------------------------------------------------

Command:
git commit -m "<commit-message>"

Explanation:
Creates a commit with a message.

Example:
git commit -m "Updated Kubernetes deployment configuration"

------------------------------------------------------------

Command:
git push origin <branch-name>

Explanation:
Pushes local branch commits to remote repository.

Example:
git push origin feature/update-deployment

------------------------------------------------------------

Command:
git push -u origin <branch-name>

Explanation:
Pushes a new branch and sets upstream tracking.

Example:
git push -u origin feature/update-deployment


============================================================
37.5 GIT DIFF COMMANDS
============================================================

Command:
git diff

Explanation:
Shows unstaged file changes.

Example:
git diff

------------------------------------------------------------

Command:
git diff --staged

Explanation:
Shows staged changes before commit.

Example:
git diff --staged

------------------------------------------------------------

Command:
git diff <branch1>..<branch2>

Explanation:
Shows differences between two branches.

Example:
git diff main..feature/update-deployment


============================================================
37.6 GIT STASH COMMANDS
============================================================

Command:
git stash

Explanation:
Temporarily saves uncommitted changes.

Example:
git stash

------------------------------------------------------------

Command:
git stash list

Explanation:
Lists saved stashes.

Example:
git stash list

------------------------------------------------------------

Command:
git stash pop

Explanation:
Applies the latest stash and removes it from stash list.

Example:
git stash pop

------------------------------------------------------------

Command:
git stash apply

Explanation:
Applies the latest stash but keeps it in stash list.

Example:
git stash apply


============================================================
37.7 GIT MERGE AND CONFLICT RESOLUTION
============================================================

Command:
git merge origin/main

Explanation:
Merges latest remote main branch into current branch.

Example:
git merge origin/main

------------------------------------------------------------

Command:
git status

Explanation:
Shows files with merge conflicts.

Example:
git status

------------------------------------------------------------

Command:
git add <resolved-file>

Explanation:
Stages a file after resolving merge conflict.

Example:
git add deployment.yml

------------------------------------------------------------

Command:
git commit

Explanation:
Completes the merge commit after resolving conflicts.

Example:
git commit

------------------------------------------------------------

Command:
git merge --abort

Explanation:
Cancels an active merge and returns to previous state.

Example:
git merge --abort


============================================================
37.8 GIT REBASE COMMANDS
============================================================

Command:
git rebase origin/main

Explanation:
Replays current branch commits on top of latest origin main.

Example:
git rebase origin/main

------------------------------------------------------------

Command:
git rebase --continue

Explanation:
Continues rebase after resolving conflicts.

Example:
git rebase --continue

------------------------------------------------------------

Command:
git rebase --abort

Explanation:
Cancels active rebase.

Example:
git rebase --abort


============================================================
37.9 GIT RESET AND RESTORE COMMANDS
============================================================

Command:
git restore <file-name>

Explanation:
Discards unstaged changes in a file.

Example:
git restore deployment.yml

------------------------------------------------------------

Command:
git restore --staged <file-name>

Explanation:
Unstages a staged file but keeps local changes.

Example:
git restore --staged deployment.yml

------------------------------------------------------------

Command:
git reset --soft HEAD~1

Explanation:
Undoes the last commit but keeps changes staged.

Example:
git reset --soft HEAD~1

------------------------------------------------------------

Command:
git reset --hard HEAD~1

Explanation:
Deletes the last commit and local changes. Use carefully.

Example:
git reset --hard HEAD~1

Warning:
git reset --hard permanently removes local changes. Use only when you are sure.


============================================================
37.10 GIT TAG COMMANDS
============================================================

Command:
git tag

Explanation:
Lists Git tags.

Example:
git tag

------------------------------------------------------------

Command:
git tag <tag-name>

Explanation:
Creates a tag on the current commit.

Example:
git tag v1.0.0

------------------------------------------------------------

Command:
git push origin <tag-name>

Explanation:
Pushes a tag to remote repository.

Example:
git push origin v1.0.0


============================================================
37.11 GIT TROUBLESHOOTING COMMANDS
============================================================

Command:
git remote show origin

Explanation:
Shows detailed information about the remote origin.

Example:
git remote show origin

------------------------------------------------------------

Command:
git fsck

Explanation:
Checks repository integrity.

Example:
git fsck

------------------------------------------------------------

Command:
git clean -fd

Explanation:
Deletes untracked files and directories. Use carefully.

Example:
git clean -fd

Warning:
This permanently deletes untracked files.

------------------------------------------------------------

Command:
git reflog

Explanation:
Shows history of HEAD movements, useful for recovering lost commits.

Example:
git reflog

------------------------------------------------------------

Command:
git checkout <commit-id>

Explanation:
Checks out a specific commit in detached HEAD mode.

Example:
git checkout abc1234

------------------------------------------------------------

Command:
git cherry-pick <commit-id>

Explanation:
Applies a specific commit from another branch onto the current branch.

Example:
git cherry-pick abc1234


============================================================
38. ADDITIONAL KUBERNETES COMMANDS
============================================================

Purpose:
This section contains additional Kubernetes commands for cluster inspection, namespace operations, deployments, rollouts, services, logs, events, labels, annotations, RBAC, service accounts, nodes, scheduling, probes, resources, and troubleshooting.

Important Security Note:
Do not print or share Kubernetes secret values, kubeconfig files, service account tokens, private keys, or TLS keys.
Use describe secret for metadata only. Avoid decoding secret values unless you are authorized and working in a secure environment.

============================================================
38.1 CLUSTER AND CONTEXT COMMANDS
============================================================

Command:
kubectl version

Explanation:
Shows client and server Kubernetes versions.

Example:
kubectl version

------------------------------------------------------------

Command:
kubectl cluster-info

Explanation:
Shows Kubernetes control plane and DNS service information.

Example:
kubectl cluster-info

------------------------------------------------------------

Command:
kubectl config get-contexts

Explanation:
Lists available Kubernetes contexts.

Example:
kubectl config get-contexts

------------------------------------------------------------

Command:
kubectl config current-context

Explanation:
Shows the current active context.

Example:
kubectl config current-context

------------------------------------------------------------

Command:
kubectl config use-context <context-name>

Explanation:
Switches to a specific Kubernetes context.

Example:
kubectl config use-context aks-dev-context

------------------------------------------------------------

Command:
kubectl config set-context --current --namespace=<namespace>

Explanation:
Sets the default namespace for the current context.

Example:
kubectl config set-context --current --namespace=dev-gain-core


============================================================
38.2 API RESOURCE DISCOVERY COMMANDS
============================================================

Command:
kubectl api-resources

Explanation:
Lists all resource types supported by the cluster.

Example:
kubectl api-resources

------------------------------------------------------------

Command:
kubectl api-resources | grep <resource-name>

Explanation:
Searches for a specific Kubernetes resource type.

Example:
kubectl api-resources | grep ingress

------------------------------------------------------------

Command:
kubectl explain <resource-name>

Explanation:
Shows documentation for a Kubernetes resource.

Example:
kubectl explain deployment

------------------------------------------------------------

Command:
kubectl explain deployment.spec

Explanation:
Shows documentation for a specific field.

Example:
kubectl explain deployment.spec


============================================================
38.3 NAMESPACE COMMANDS
============================================================

Command:
kubectl get ns

Explanation:
Lists all namespaces.

Example:
kubectl get ns

------------------------------------------------------------

Command:
kubectl create namespace <namespace>

Explanation:
Creates a namespace.

Example:
kubectl create namespace dev-gain-core

------------------------------------------------------------

Command:
kubectl describe namespace <namespace>

Explanation:
Shows details of a namespace.

Example:
kubectl describe namespace dev-gain-core

------------------------------------------------------------

Command:
kubectl delete namespace <namespace>

Explanation:
Deletes a namespace and all resources inside it. Use carefully.

Example:
kubectl delete namespace test-namespace

Warning:
Deleting a namespace deletes all resources inside it.


============================================================
38.4 POD COMMANDS
============================================================

Command:
kubectl get pods -n <namespace>

Explanation:
Lists pods in a namespace.

Example:
kubectl get pods -n dev-gain-core

------------------------------------------------------------

Command:
kubectl get pods -n <namespace> -o wide

Explanation:
Lists pods with node name, pod IP, and additional details.

Example:
kubectl get pods -n dev-gain-core -o wide

------------------------------------------------------------

Command:
kubectl describe pod <pod-name> -n <namespace>

Explanation:
Shows detailed pod information, events, volumes, probes, and container status.

Example:
kubectl describe pod api-deployment-xxxxx -n dev-gain-core

------------------------------------------------------------

Command:
kubectl get pod <pod-name> -n <namespace> -o yaml

Explanation:
Shows pod manifest in YAML format.

Example:
kubectl get pod api-deployment-xxxxx -n dev-gain-core -o yaml

------------------------------------------------------------

Command:
kubectl get pod <pod-name> -n <namespace> -o jsonpath='{.status.podIP}{"\n"}'

Explanation:
Prints the pod IP address.

Example:
kubectl get pod api-deployment-xxxxx -n dev-gain-core -o jsonpath='{.status.podIP}{"\n"}'

------------------------------------------------------------

Command:
kubectl delete pod <pod-name> -n <namespace>

Explanation:
Deletes a pod. If managed by deployment, it will be recreated automatically.

Example:
kubectl delete pod api-deployment-xxxxx -n dev-gain-core


============================================================
38.5 DEPLOYMENT COMMANDS
============================================================

Command:
kubectl get deploy -n <namespace>

Explanation:
Lists deployments in a namespace.

Example:
kubectl get deploy -n dev-gain-core

------------------------------------------------------------

Command:
kubectl describe deployment <deployment-name> -n <namespace>

Explanation:
Shows detailed deployment information.

Example:
kubectl describe deployment api-deployment -n dev-gain-core

------------------------------------------------------------

Command:
kubectl get deployment <deployment-name> -n <namespace> -o yaml

Explanation:
Shows deployment YAML.

Example:
kubectl get deployment api-deployment -n dev-gain-core -o yaml

------------------------------------------------------------

Command:
kubectl rollout status deployment/<deployment-name> -n <namespace>

Explanation:
Checks rollout status of a deployment.

Example:
kubectl rollout status deployment/api-deployment -n dev-gain-core

------------------------------------------------------------

Command:
kubectl rollout history deployment/<deployment-name> -n <namespace>

Explanation:
Shows rollout revision history.

Example:
kubectl rollout history deployment/api-deployment -n dev-gain-core

------------------------------------------------------------

Command:
kubectl rollout undo deployment/<deployment-name> -n <namespace>

Explanation:
Rolls back deployment to the previous revision.

Example:
kubectl rollout undo deployment/api-deployment -n dev-gain-core

------------------------------------------------------------

Command:
kubectl rollout restart deployment/<deployment-name> -n <namespace>

Explanation:
Restarts all pods under a deployment.

Example:
kubectl rollout restart deployment/api-deployment -n dev-gain-core

------------------------------------------------------------

Command:
kubectl scale deployment <deployment-name> --replicas=<count> -n <namespace>

Explanation:
Scales deployment replicas.

Example:
kubectl scale deployment api-deployment --replicas=3 -n dev-gain-core

------------------------------------------------------------

Command:
kubectl set image deployment/<deployment-name> <container-name>=<image-name>:<tag> -n <namespace>

Explanation:
Updates container image in a deployment.

Example:
kubectl set image deployment/api-deployment api=repo.example.com/api:latest -n dev-gain-core


============================================================
38.6 SERVICE COMMANDS
============================================================

Command:
kubectl get svc -n <namespace>

Explanation:
Lists services in a namespace.

Example:
kubectl get svc -n dev-gain-core

------------------------------------------------------------

Command:
kubectl describe svc <service-name> -n <namespace>

Explanation:
Shows service selectors, ports, target ports, and endpoints.

Example:
kubectl describe svc api-service -n dev-gain-core

------------------------------------------------------------

Command:
kubectl get endpoints <service-name> -n <namespace> -o wide

Explanation:
Shows backend pod IPs attached to a service.

Example:
kubectl get endpoints api-service -n dev-gain-core -o wide

------------------------------------------------------------

Command:
kubectl get endpointslice -n <namespace> -l kubernetes.io/service-name=<service-name> -o wide

Explanation:
Shows EndpointSlice details for a service.

Example:
kubectl get endpointslice -n dev-gain-core -l kubernetes.io/service-name=api-service -o wide

------------------------------------------------------------

Command:
kubectl port-forward svc/<service-name> <local-port>:<service-port> -n <namespace>

Explanation:
Forwards local port to a Kubernetes service.

Example:
kubectl port-forward svc/api-service 8080:5001 -n dev-gain-core


============================================================
38.7 INGRESS COMMANDS
============================================================

Command:
kubectl get ingress -n <namespace>

Explanation:
Lists ingress resources.

Example:
kubectl get ingress -n dev-gain-core

------------------------------------------------------------

Command:
kubectl describe ingress <ingress-name> -n <namespace>

Explanation:
Shows ingress host, paths, TLS, annotations, and events.

Example:
kubectl describe ingress dev-api-ingress -n dev-gain-core

------------------------------------------------------------

Command:
kubectl get ingress <ingress-name> -n <namespace> -o yaml

Explanation:
Shows ingress YAML.

Example:
kubectl get ingress dev-api-ingress -n dev-gain-core -o yaml


============================================================
38.8 CONFIGMAP COMMANDS
============================================================

Command:
kubectl get cm -n <namespace>

Explanation:
Lists ConfigMaps in a namespace.

Example:
kubectl get cm -n dev-gain-core

------------------------------------------------------------

Command:
kubectl describe cm <configmap-name> -n <namespace>

Explanation:
Shows ConfigMap metadata and content.

Example:
kubectl describe cm app-config -n dev-gain-core

------------------------------------------------------------

Command:
kubectl get cm <configmap-name> -n <namespace> -o yaml

Explanation:
Shows ConfigMap YAML.

Example:
kubectl get cm app-config -n dev-gain-core -o yaml

------------------------------------------------------------

Command:
kubectl create configmap <configmap-name> --from-file=<file-path> -n <namespace>

Explanation:
Creates ConfigMap from a file.

Example:
kubectl create configmap app-config --from-file=config.json -n dev-gain-core


============================================================
38.9 SECRET SAFE INSPECTION COMMANDS
============================================================

Command:
kubectl get secrets -n <namespace>

Explanation:
Lists secrets in a namespace.

Example:
kubectl get secrets -n dev-gain-core

------------------------------------------------------------

Command:
kubectl describe secret <secret-name> -n <namespace>

Explanation:
Shows secret metadata without printing decoded secret values.

Example:
kubectl describe secret app-secret -n dev-gain-core

------------------------------------------------------------

Command:
kubectl get secret <secret-name> -n <namespace> -o jsonpath='{.type}{"\n"}'

Explanation:
Shows the secret type.

Example:
kubectl get secret app-secret -n dev-gain-core -o jsonpath='{.type}{"\n"}'

------------------------------------------------------------

Command:
kubectl get secret <secret-name> -n <namespace> -o jsonpath='{.metadata.name}{"\n"}'

Explanation:
Shows the secret name only.

Example:
kubectl get secret app-secret -n dev-gain-core -o jsonpath='{.metadata.name}{"\n"}'

------------------------------------------------------------

Command:
kubectl get secret <tls-secret-name> -n <namespace> -o jsonpath='{.data.tls\.crt}' | base64 -d | openssl x509 -noout -dates

Explanation:
Checks TLS certificate validity dates from a Kubernetes TLS secret. This decodes only the public certificate, not the private key.

Example:
kubectl get secret gain-dev-tls -n dev-gain-core -o jsonpath='{.data.tls\.crt}' | base64 -d | openssl x509 -noout -dates

Warning:
Do not decode or print private keys or secret values unless authorized and working in a secure terminal.


============================================================
38.10 LOG COMMANDS
============================================================

Command:
kubectl logs <pod-name> -n <namespace>

Explanation:
Shows logs from a pod.

Example:
kubectl logs api-deployment-xxxxx -n dev-gain-core

------------------------------------------------------------

Command:
kubectl logs -f <pod-name> -n <namespace>

Explanation:
Follows pod logs in real time.

Example:
kubectl logs -f api-deployment-xxxxx -n dev-gain-core

------------------------------------------------------------

Command:
kubectl logs <pod-name> -n <namespace> -c <container-name>

Explanation:
Shows logs for a specific container in a multi-container pod.

Example:
kubectl logs app-pod-xxxxx -n dev-gain-core -c app-container

------------------------------------------------------------

Command:
kubectl logs deploy/<deployment-name> -n <namespace> --tail=200

Explanation:
Shows last 200 log lines from deployment pods.

Example:
kubectl logs deploy/api-deployment -n dev-gain-core --tail=200

------------------------------------------------------------

Command:
kubectl logs -l app=<label-value> -n <namespace> --tail=200

Explanation:
Shows logs from pods matching a label.

Example:
kubectl logs -l app=api -n dev-gain-core --tail=200


============================================================
38.11 EVENTS COMMANDS
============================================================

Command:
kubectl get events -n <namespace>

Explanation:
Shows Kubernetes events in a namespace.

Example:
kubectl get events -n dev-gain-core

------------------------------------------------------------

Command:
kubectl get events -n <namespace> --sort-by=.metadata.creationTimestamp

Explanation:
Shows namespace events sorted by time.

Example:
kubectl get events -n dev-gain-core --sort-by=.metadata.creationTimestamp

------------------------------------------------------------

Command:
kubectl get events -A --sort-by=.metadata.creationTimestamp

Explanation:
Shows cluster-wide events sorted by time.

Example:
kubectl get events -A --sort-by=.metadata.creationTimestamp


============================================================
38.12 LABEL AND ANNOTATION COMMANDS
============================================================

Command:
kubectl get pods -n <namespace> --show-labels

Explanation:
Lists pods with labels.

Example:
kubectl get pods -n dev-gain-core --show-labels

------------------------------------------------------------

Command:
kubectl get pods -n <namespace> -l <label-key>=<label-value>

Explanation:
Lists pods matching a label selector.

Example:
kubectl get pods -n dev-gain-core -l app=api

------------------------------------------------------------

Command:
kubectl label pod <pod-name> <key>=<value> -n <namespace>

Explanation:
Adds or updates a label on a pod.

Example:
kubectl label pod api-pod-xxxxx environment=dev -n dev-gain-core

------------------------------------------------------------

Command:
kubectl annotate pod <pod-name> <key>=<value> -n <namespace>

Explanation:
Adds or updates an annotation on a pod.

Example:
kubectl annotate pod api-pod-xxxxx owner=platform-team -n dev-gain-core


============================================================
38.13 NODE COMMANDS
============================================================

Command:
kubectl get nodes

Explanation:
Lists cluster nodes.

Example:
kubectl get nodes

------------------------------------------------------------

Command:
kubectl get nodes -o wide

Explanation:
Lists nodes with OS, kernel, container runtime, and internal IP details.

Example:
kubectl get nodes -o wide

------------------------------------------------------------

Command:
kubectl describe node <node-name>

Explanation:
Shows node capacity, allocatable resources, labels, taints, conditions, and events.

Example:
kubectl describe node aks-nodepool-xxxxx

------------------------------------------------------------

Command:
kubectl top nodes

Explanation:
Shows CPU and memory usage of nodes.

Example:
kubectl top nodes

------------------------------------------------------------

Command:
kubectl cordon <node-name>

Explanation:
Marks a node unschedulable so new pods are not scheduled on it.

Example:
kubectl cordon aks-nodepool-xxxxx

------------------------------------------------------------

Command:
kubectl uncordon <node-name>

Explanation:
Marks a node schedulable again.

Example:
kubectl uncordon aks-nodepool-xxxxx

------------------------------------------------------------

Command:
kubectl drain <node-name> --ignore-daemonsets --delete-emptydir-data

Explanation:
Evicts pods from a node for maintenance. Use carefully.

Example:
kubectl drain aks-nodepool-xxxxx --ignore-daemonsets --delete-emptydir-data

Warning:
Drain can disrupt workloads. Use only during approved maintenance.


============================================================
38.14 RBAC AND PERMISSION CHECK COMMANDS
============================================================

Command:
kubectl auth can-i get pods -n <namespace>

Explanation:
Checks if current user can get pods in a namespace.

Example:
kubectl auth can-i get pods -n dev-gain-core

------------------------------------------------------------

Command:
kubectl auth can-i create deployment -n <namespace>

Explanation:
Checks if current user can create deployments.

Example:
kubectl auth can-i create deployment -n dev-gain-core

------------------------------------------------------------

Command:
kubectl auth can-i '*' '*' -n <namespace>

Explanation:
Checks if current user has all permissions in a namespace.

Example:
kubectl auth can-i '*' '*' -n dev-gain-core

------------------------------------------------------------

Command:
kubectl get role,rolebinding -n <namespace>

Explanation:
Lists namespace roles and role bindings.

Example:
kubectl get role,rolebinding -n dev-gain-core

------------------------------------------------------------

Command:
kubectl get clusterrole,clusterrolebinding

Explanation:
Lists cluster roles and cluster role bindings.

Example:
kubectl get clusterrole,clusterrolebinding


============================================================
38.15 SERVICE ACCOUNT COMMANDS
============================================================

Command:
kubectl get sa -n <namespace>

Explanation:
Lists service accounts in a namespace.

Example:
kubectl get sa -n dev-gain-core

------------------------------------------------------------

Command:
kubectl describe sa <serviceaccount-name> -n <namespace>

Explanation:
Shows service account details.

Example:
kubectl describe sa workload-identity-sa -n dev-gain-core

------------------------------------------------------------

Command:
kubectl get sa <serviceaccount-name> -n <namespace> -o yaml

Explanation:
Shows service account YAML.

Example:
kubectl get sa workload-identity-sa -n dev-gain-core -o yaml


============================================================
38.16 RESOURCE USAGE AND LIMIT COMMANDS
============================================================

Command:
kubectl top pods -n <namespace>

Explanation:
Shows CPU and memory usage of pods.

Example:
kubectl top pods -n dev-gain-core

------------------------------------------------------------

Command:
kubectl top pod <pod-name> -n <namespace>

Explanation:
Shows CPU and memory usage of a specific pod.

Example:
kubectl top pod api-pod-xxxxx -n dev-gain-core

------------------------------------------------------------

Command:
kubectl describe hpa <hpa-name> -n <namespace>

Explanation:
Shows Horizontal Pod Autoscaler status and scaling metrics.

Example:
kubectl describe hpa api-hpa -n dev-gain-core

------------------------------------------------------------

Command:
kubectl get resourcequota -n <namespace>

Explanation:
Lists resource quotas for a namespace.

Example:
kubectl get resourcequota -n dev-gain-core

------------------------------------------------------------

Command:
kubectl describe resourcequota <quota-name> -n <namespace>

Explanation:
Shows quota limits and current usage.

Example:
kubectl describe resourcequota compute-quota -n dev-gain-core


============================================================
38.17 PVC AND STORAGE COMMANDS
============================================================

Command:
kubectl get pvc -n <namespace>

Explanation:
Lists persistent volume claims.

Example:
kubectl get pvc -n dev-gain-core

------------------------------------------------------------

Command:
kubectl describe pvc <pvc-name> -n <namespace>

Explanation:
Shows PVC details, capacity, storage class, and events.

Example:
kubectl describe pvc data-pvc -n dev-gain-core

------------------------------------------------------------

Command:
kubectl get pv

Explanation:
Lists persistent volumes.

Example:
kubectl get pv

------------------------------------------------------------

Command:
kubectl describe pv <pv-name>

Explanation:
Shows persistent volume details.

Example:
kubectl describe pv pvc-xxxxx

------------------------------------------------------------

Command:
kubectl get storageclass

Explanation:
Lists storage classes in the cluster.

Example:
kubectl get storageclass


============================================================
38.18 JOB AND CRONJOB COMMANDS
============================================================

Command:
kubectl get jobs -n <namespace>

Explanation:
Lists jobs.

Example:
kubectl get jobs -n dev-gain-core

------------------------------------------------------------

Command:
kubectl describe job <job-name> -n <namespace>

Explanation:
Shows job details and events.

Example:
kubectl describe job backup-job -n dev-gain-core

------------------------------------------------------------

Command:
kubectl logs job/<job-name> -n <namespace>

Explanation:
Shows logs from a job.

Example:
kubectl logs job/backup-job -n dev-gain-core

------------------------------------------------------------

Command:
kubectl get cronjob -n <namespace>

Explanation:
Lists CronJobs.

Example:
kubectl get cronjob -n dev-gain-core

------------------------------------------------------------

Command:
kubectl describe cronjob <cronjob-name> -n <namespace>

Explanation:
Shows CronJob schedule and history.

Example:
kubectl describe cronjob daily-job -n dev-gain-core


============================================================
38.19 TEMPORARY DEBUG POD COMMANDS
============================================================

Command:
kubectl run debug-shell --rm -it --image=busybox -n <namespace> -- sh

Explanation:
Starts a temporary BusyBox pod for debugging and removes it after exit.

Example:
kubectl run debug-shell --rm -it --image=busybox -n dev-gain-core -- sh

------------------------------------------------------------

Command:
kubectl run curl-test --rm -it --image=curlimages/curl -n <namespace> -- sh

Explanation:
Starts a temporary curl pod for HTTP testing and removes it after exit.

Example:
kubectl run curl-test --rm -it --image=curlimages/curl -n dev-gain-core -- sh

------------------------------------------------------------

Command:
kubectl create deploy netshoot --image=<netshoot-image> -n <namespace> -- sleep 3600

Explanation:
Creates a temporary network troubleshooting deployment.

Example:
kubectl create deploy netshoot --image=docker-repo.example.com/nirmata/netshoot:latest -n dev-gain-core -- sleep 3600

------------------------------------------------------------

Command:
kubectl exec -it deploy/netshoot -n <namespace> -- bash

Explanation:
Opens shell inside the netshoot pod.

Example:
kubectl exec -it deploy/netshoot -n dev-gain-core -- bash

------------------------------------------------------------

Command:
kubectl delete deploy netshoot -n <namespace>

Explanation:
Deletes the temporary troubleshooting deployment.

Example:
kubectl delete deploy netshoot -n dev-gain-core


============================================================
38.20 KUBECTL OUTPUT FILTERING COMMANDS
============================================================

Command:
kubectl get pods -n <namespace> -o name

Explanation:
Shows pod names only.

Example:
kubectl get pods -n dev-gain-core -o name

------------------------------------------------------------

Command:
kubectl get pods -n <namespace> --no-headers

Explanation:
Shows pod list without headers.

Example:
kubectl get pods -n dev-gain-core --no-headers

------------------------------------------------------------

Command:
kubectl get pods -n <namespace> --sort-by=.metadata.creationTimestamp

Explanation:
Shows pods sorted by creation time.

Example:
kubectl get pods -n dev-gain-core --sort-by=.metadata.creationTimestamp

------------------------------------------------------------

Command:
kubectl get pods -n <namespace> -o jsonpath='{range .items[*]}{.metadata.name}{" "}{.status.phase}{"\n"}{end}'

Explanation:
Shows pod names and pod phases using jsonpath.

Example:
kubectl get pods -n dev-gain-core -o jsonpath='{range .items[*]}{.metadata.name}{" "}{.status.phase}{"\n"}{end}'


============================================================
39. KUBERNETES TROUBLESHOOTING GUIDE
============================================================

Purpose:
This section contains common Kubernetes issue types, symptoms, commands to check, and possible causes.

============================================================
39.1 POD STUCK IN PENDING
============================================================

Symptoms:
Pod status shows Pending.

Check commands:
kubectl describe pod <pod-name> -n <namespace>
kubectl get events -n <namespace> --sort-by=.metadata.creationTimestamp
kubectl describe nodes
kubectl get pvc -n <namespace>

Possible causes:
- Not enough CPU or memory available
- PVC not bound
- Node selector does not match any node
- Taints and tolerations issue
- Image pull secret missing
- Resource quota exceeded

Example:
kubectl describe pod api-pod-xxxxx -n dev-gain-core


============================================================
39.2 POD IN CRASHLOOPBACKOFF
============================================================

Symptoms:
Pod repeatedly starts and crashes.

Check commands:
kubectl logs <pod-name> -n <namespace> --previous
kubectl logs <pod-name> -n <namespace> --tail=200
kubectl describe pod <pod-name> -n <namespace>
kubectl get events -n <namespace> --sort-by=.metadata.creationTimestamp

Possible causes:
- Application startup error
- Missing environment variable
- Wrong command or entrypoint
- Secret or ConfigMap missing
- Database or dependency unavailable
- Permission issue
- Liveness probe too strict

Example:
kubectl logs api-pod-xxxxx -n dev-gain-core --previous


============================================================
39.3 IMAGEPULLBACKOFF OR ERRIMAGEPULL
============================================================

Symptoms:
Pod cannot pull container image.

Check commands:
kubectl describe pod <pod-name> -n <namespace>
kubectl get secret -n <namespace>
kubectl get events -n <namespace> --sort-by=.metadata.creationTimestamp

Possible causes:
- Image name is wrong
- Image tag does not exist
- Registry authentication failed
- Image pull secret missing
- Network issue to registry
- ACR or ECR permission issue

Example:
kubectl describe pod api-pod-xxxxx -n dev-gain-core


============================================================
39.4 SERVICE HAS NO ENDPOINTS
============================================================

Symptoms:
Service exists but traffic does not reach pods.

Check commands:
kubectl describe svc <service-name> -n <namespace>
kubectl get endpoints <service-name> -n <namespace> -o wide
kubectl get pods -n <namespace> --show-labels
kubectl get endpointslice -n <namespace> -l kubernetes.io/service-name=<service-name> -o wide

Possible causes:
- Service selector does not match pod labels
- Pods are not ready
- Readiness probe failing
- Pods are in another namespace
- Target port mismatch

Example:
kubectl get endpoints api-service -n dev-gain-core -o wide


============================================================
39.5 INGRESS NOT WORKING
============================================================

Symptoms:
Application is not reachable through hostname.

Check commands:
kubectl get ingress -n <namespace>
kubectl describe ingress <ingress-name> -n <namespace>
kubectl get svc -n <namespace>
kubectl get endpoints <service-name> -n <namespace> -o wide
nslookup <hostname>
curl -vk https://<hostname>

Possible causes:
- DNS record missing or wrong
- Ingress host mismatch
- TLS secret missing or invalid
- Backend service has no endpoints
- Ingress controller issue
- Firewall or proxy blocking access

Example:
kubectl describe ingress dev-api-ingress -n dev-gain-core


============================================================
39.6 TLS CERTIFICATE ISSUE
============================================================

Symptoms:
Browser shows certificate error or TLS handshake fails.

Check commands:
kubectl get secret <tls-secret-name> -n <namespace>
kubectl describe secret <tls-secret-name> -n <namespace>
kubectl get secret <tls-secret-name> -n <namespace> -o jsonpath='{.data.tls\.crt}' | base64 -d | openssl x509 -noout -dates
openssl s_client -connect <hostname>:443 -servername <hostname>

Possible causes:
- Expired certificate
- Wrong certificate common name or SAN
- TLS secret missing
- Ingress points to wrong TLS secret
- Certificate chain issue

Example:
kubectl get secret gain-dev-tls -n dev-gain-core -o jsonpath='{.data.tls\.crt}' | base64 -d | openssl x509 -noout -dates


============================================================
39.7 DNS RESOLUTION ISSUE INSIDE POD
============================================================

Symptoms:
Application cannot resolve service name or external hostname.

Check commands:
kubectl exec -it <pod-name> -n <namespace> -- nslookup <hostname>
kubectl exec -it <pod-name> -n <namespace> -- cat /etc/resolv.conf
kubectl get svc kube-dns -n kube-system
kubectl get pods -n kube-system | grep dns

Possible causes:
- CoreDNS issue
- Wrong service name
- Wrong namespace
- Network policy blocking DNS
- Custom DNS configuration issue

Example:
kubectl exec -it api-pod-xxxxx -n dev-gain-core -- nslookup api-service


============================================================
39.8 NETWORK CONNECTIVITY ISSUE INSIDE POD
============================================================

Symptoms:
Application cannot connect to database, Redis, API, or service.

Check commands:
kubectl exec -it <pod-name> -n <namespace> -- sh
nslookup <hostname>
nc -zv <hostname> <port>
curl -v <url>
env | grep -i proxy

Possible causes:
- DNS issue
- Network policy blocking traffic
- Firewall blocking traffic
- Private endpoint issue
- Proxy missing or misconfigured
- Service port mismatch
- Target service down

Example:
nc -zv postgres.example.com 5432


============================================================
39.9 PVC MOUNT ISSUE
============================================================

Symptoms:
Pod fails because volume cannot mount.

Check commands:
kubectl describe pod <pod-name> -n <namespace>
kubectl get pvc -n <namespace>
kubectl describe pvc <pvc-name> -n <namespace>
kubectl get pv
kubectl get events -n <namespace> --sort-by=.metadata.creationTimestamp

Possible causes:
- PVC not bound
- StorageClass issue
- Azure Disk or Azure File issue
- Volume already attached to another node
- Permission issue
- CSI driver issue

Example:
kubectl describe pvc data-pvc -n dev-gain-core


============================================================
39.10 HIGH MEMORY OR CPU USAGE
============================================================

Symptoms:
Pod is slow, restarting, or OOMKilled.

Check commands:
kubectl top pod <pod-name> -n <namespace>
kubectl top pods -n <namespace>
kubectl describe pod <pod-name> -n <namespace>
kubectl exec -it <pod-name> -n <namespace> -- ps aux | sort -rk 4,4 | head -10
kubectl exec -it <pod-name> -n <namespace> -- free -h

Possible causes:
- Memory leak
- CPU saturation
- Resource limits too low
- Too many worker processes
- Large file or cache usage
- Inefficient query or job

Example:
kubectl top pods -n gain-prod


============================================================
39.11 OOMKILLED POD
============================================================

Symptoms:
Pod restarts and previous state shows OOMKilled.

Check commands:
kubectl describe pod <pod-name> -n <namespace>
kubectl logs <pod-name> -n <namespace> --previous
kubectl top pod <pod-name> -n <namespace>

Possible causes:
- Container exceeded memory limit
- Memory limit too low
- Application memory leak
- Large workload spike

Example:
kubectl describe pod api-pod-xxxxx -n dev-gain-core


============================================================
39.12 READINESS PROBE FAILURE
============================================================

Symptoms:
Pod is running but service does not send traffic to it.

Check commands:
kubectl describe pod <pod-name> -n <namespace>
kubectl logs <pod-name> -n <namespace>
kubectl exec -it <pod-name> -n <namespace> -- curl -v http://localhost:<port>/<health-path>

Possible causes:
- Health endpoint wrong
- Application not ready
- Port mismatch
- Startup delay too short
- Dependency unavailable

Example:
kubectl exec -it api-pod-xxxxx -n dev-gain-core -- curl -v http://localhost:5001/health


============================================================
39.13 LIVENESS PROBE FAILURE
============================================================

Symptoms:
Pod keeps restarting.

Check commands:
kubectl describe pod <pod-name> -n <namespace>
kubectl logs <pod-name> -n <namespace> --previous
kubectl get events -n <namespace> --sort-by=.metadata.creationTimestamp

Possible causes:
- Liveness probe path wrong
- Application startup takes too long
- Application deadlock
- Port mismatch
- Probe timeout too low

Example:
kubectl describe pod api-pod-xxxxx -n dev-gain-core


============================================================
39.14 NODE ISSUE
============================================================

Symptoms:
Pods on one node fail or stay pending.

Check commands:
kubectl get nodes
kubectl describe node <node-name>
kubectl top nodes
kubectl get pods -A --field-selector spec.nodeName=<node-name>
kubectl get events -A --sort-by=.metadata.creationTimestamp

Possible causes:
- Node memory pressure
- Node disk pressure
- Node not ready
- CNI issue
- CSI volume attach issue
- Taints preventing scheduling

Example:
kubectl describe node aks-nodepool-xxxxx


============================================================
39.15 RBAC PERMISSION ISSUE
============================================================

Symptoms:
User or service account gets Forbidden error.

Check commands:
kubectl auth can-i get pods -n <namespace>
kubectl auth can-i create deployment -n <namespace>
kubectl get role,rolebinding -n <namespace>
kubectl get clusterrole,clusterrolebinding

Possible causes:
- Missing RoleBinding
- Missing ClusterRoleBinding
- Wrong namespace
- Service account lacks permission
- User lacks permission

Example:
kubectl auth can-i get pods -n dev-gain-core


============================================================
39.16 WORKLOAD IDENTITY ISSUE
============================================================

Symptoms:
Application cannot access Azure Key Vault or Azure resources.

Check commands:
kubectl get sa <serviceaccount-name> -n <namespace> -o yaml
kubectl get pod <pod-name> -n <namespace> -o jsonpath='{.spec.serviceAccountName}{"\n"}'
kubectl get pod <pod-name> -n <namespace> -o jsonpath='{.metadata.labels.azure\.workload\.identity/use}{"\n"}'
kubectl exec -it <pod-name> -n <namespace> -- sh -c 'env | egrep "AZURE_TENANT_ID|AZURE_CLIENT_ID|AZURE_FEDERATED_TOKEN_FILE" | sort'
kubectl describe pod <pod-name> -n <namespace>

Possible causes:
- Pod missing workload identity label
- Service account missing client ID annotation
- Federated credential missing in Azure
- Managed identity lacks Key Vault permission
- Wrong Key Vault URL
- SecretProviderClass misconfigured

Example:
kubectl exec -it app-pod-xxxxx -n dev-gain-core -- sh -c 'env | egrep "AZURE_TENANT_ID|AZURE_CLIENT_ID|AZURE_FEDERATED_TOKEN_FILE" | sort'


============================================================
39.17 IMAGE UPDATE NOT REFLECTING
============================================================

Symptoms:
New image was pushed but pod still runs old image.

Check commands:
kubectl describe deployment <deployment-name> -n <namespace>
kubectl get pods -n <namespace> -o wide
kubectl rollout status deployment/<deployment-name> -n <namespace>
kubectl rollout restart deployment/<deployment-name> -n <namespace>

Possible causes:
- Same image tag reused
- imagePullPolicy is IfNotPresent
- Deployment not restarted
- Wrong namespace
- Wrong deployment updated

Example:
kubectl rollout restart deployment/api-deployment -n dev-gain-core


============================================================
39.18 FULL KUBERNETES TROUBLESHOOTING FLOW
============================================================

Step 1: Confirm context.

Command:
kubectl config current-context

Step 2: Confirm namespace.

Command:
kubectl config set-context --current --namespace=<namespace>

Step 3: Check pods.

Command:
kubectl get pods -n <namespace> -o wide

Step 4: Describe failing pod.

Command:
kubectl describe pod <pod-name> -n <namespace>

Step 5: Check logs.

Command:
kubectl logs <pod-name> -n <namespace> --tail=200

Step 6: Check previous logs if pod restarted.

Command:
kubectl logs <pod-name> -n <namespace> --previous

Step 7: Check events.

Command:
kubectl get events -n <namespace> --sort-by=.metadata.creationTimestamp

Step 8: Check service.

Command:
kubectl describe svc <service-name> -n <namespace>

Step 9: Check endpoints.

Command:
kubectl get endpoints <service-name> -n <namespace> -o wide

Step 10: Check ingress.

Command:
kubectl describe ingress <ingress-name> -n <namespace>

Step 11: Exec into pod.

Command:
kubectl exec -it <pod-name> -n <namespace> -- sh

Step 12: Check DNS inside pod.

Command:
nslookup <hostname>

Step 13: Check port connectivity.

Command:
nc -zv <hostname> <port>

Step 14: Check HTTP endpoint.

Command:
curl -vk <url>

Step 15: Check CPU and memory.

Command:
kubectl top pod <pod-name> -n <namespace>

Step 16: Restart deployment if required.

Command:
kubectl rollout restart deployment/<deployment-name> -n <namespace>

Step 17: Watch rollout status.

Command:
kubectl rollout status deployment/<deployment-name> -n <namespace>


============================================================
40. QUICK DAILY COMMAND CHEAT SHEET
============================================================

Purpose:
This section contains commonly used daily commands.

Kubernetes daily commands:
kubectl config current-context
kubectl get ns
kubectl get pods -n <namespace> -o wide
kubectl get deploy,svc,ingress -n <namespace>
kubectl describe pod <pod-name> -n <namespace>
kubectl logs <pod-name> -n <namespace> --tail=200
kubectl get events -n <namespace> --sort-by=.metadata.creationTimestamp
kubectl top pods -n <namespace>
kubectl rollout restart deployment/<deployment-name> -n <namespace>

Linux daily commands:
pwd
ls -lah
df -h
free -h
top
ps aux | sort -rk 3,3 | head -10
ps aux | sort -rk 4,4 | head -10
tail -f application.log
grep -i "error" application.log
nslookup <hostname>
nc -zv <hostname> <port>
curl -vk <url>

Git daily commands:
git status
git branch -a
git fetch origin
git checkout <branch-name>
git pull origin <branch-name>
git diff
git add .
git commit -m "<message>"
git push origin <branch-name>
git log --oneline -10

Troubleshooting daily commands:
kubectl describe pod <pod-name> -n <namespace>
kubectl logs <pod-name> -n <namespace> --previous
kubectl get endpoints <service-name> -n <namespace> -o wide
kubectl describe ingress <ingress-name> -n <namespace>
kubectl exec -it <pod-name> -n <namespace> -- sh
kubectl top pods -n <namespace>
kubectl get events -n <namespace> --sort-by=.metadata.creationTimestamp

END UPDATED LINUX GIT K8S TROUBLESHOOTING SECTIONSTART UPDATED DOCKER HELM MONITORING DEVOPS CPU SECTION

============================================================
41. DOCKER COMMANDS
============================================================

Purpose:
This section contains commonly used Docker commands for image build, run, tag, push, pull, inspect, logs, cleanup, and troubleshooting.

Important Security Note:
Do not hardcode passwords, tokens, registry credentials, or API keys in Dockerfiles, shell scripts, build commands, or documentation.
Use secret managers, CI CD variables, Docker secrets, Kubernetes Secrets, or approved enterprise credential stores.

============================================================
41.1 CHECK DOCKER INSTALLATION
============================================================

Command:
docker --version

Explanation:
Checks whether Docker is installed and shows the Docker client version.

Example:
docker --version

------------------------------------------------------------

Command:
docker info

Explanation:
Shows Docker engine details, storage driver, runtime, operating system, registry configuration, and resource information.

Example:
docker info


============================================================
41.2 LIST DOCKER IMAGES AND CONTAINERS
============================================================

Command:
docker images

Explanation:
Lists Docker images available locally.

Example:
docker images

------------------------------------------------------------

Command:
docker ps

Explanation:
Lists running containers.

Example:
docker ps

------------------------------------------------------------

Command:
docker ps -a

Explanation:
Lists all containers, including stopped containers.

Example:
docker ps -a


============================================================
41.3 BUILD DOCKER IMAGE
============================================================

Command:
docker build -t <image-name>:<tag> -f Dockerfile .

Explanation:
Builds a Docker image from the Dockerfile in the current directory.

Example:
docker build -t search_server:latest -f Dockerfile .

------------------------------------------------------------

Command:
docker build --no-cache -t <image-name>:<tag> -f Dockerfile .

Explanation:
Builds an image without using Docker cache. Useful when dependencies or base images changed.

Example:
docker build --no-cache -t search_server:latest -f Dockerfile .


============================================================
41.4 RUN DOCKER CONTAINER
============================================================

Command:
docker run -d --name <container-name> -p <host-port>:<container-port> <image-name>:<tag>

Explanation:
Runs a container in detached mode and maps a host port to a container port.

Example:
docker run -d --name termite -p 9090:9090 scibite/termite:6.6.3-dicts

------------------------------------------------------------

Command:
docker run -it --rm <image-name>:<tag> sh

Explanation:
Runs a temporary interactive container and removes it after exit.

Example:
docker run -it --rm busybox sh

------------------------------------------------------------

Command:
docker run -d --restart unless-stopped --name <container-name> -p <host-port>:<container-port> <image-name>:<tag>

Explanation:
Runs a container and automatically restarts it unless it is manually stopped.

Example:
docker run -d --restart unless-stopped --name termite -p 9090:9090 scibite/termite:6.6.3-dicts


============================================================
41.5 RUN DOCKER CONTAINER WITH VOLUMES AND ENV VARIABLES
============================================================

Command:
docker run -d \
  --restart unless-stopped \
  --name <container-name> \
  -p <host-port>:<container-port> \
  -v <host-path>:<container-path> \
  -e <ENV_NAME>=<env-value> \
  <image-name>:<tag>

Explanation:
Runs a container with port mapping, volume mount, and environment variable.

Example:
docker run -d \
  --restart unless-stopped \
  --name termite \
  -p 9090:9090 \
  -v /data/termite_work_dir:/data/termite_work_dir \
  -e JAVA_OPTS="-Xmx16g -Xms16g" \
  scibite/termite:6.6.3-dicts


============================================================
41.6 DOCKER LOGS AND EXEC
============================================================

Command:
docker logs <container-name>

Explanation:
Shows logs from a container.

Example:
docker logs termite

------------------------------------------------------------

Command:
docker logs -f <container-name>

Explanation:
Streams live logs from a container.

Example:
docker logs -f termite

------------------------------------------------------------

Command:
docker exec -it <container-name> sh

Explanation:
Opens an interactive shell inside a running container.

Example:
docker exec -it termite sh

------------------------------------------------------------

Command:
docker exec -it <container-name> bash

Explanation:
Opens bash shell inside a running container if bash is available.

Example:
docker exec -it termite bash


============================================================
41.7 DOCKER STOP, START, RESTART, REMOVE
============================================================

Command:
docker stop <container-name>

Explanation:
Stops a running container.

Example:
docker stop termite

------------------------------------------------------------

Command:
docker start <container-name>

Explanation:
Starts a stopped container.

Example:
docker start termite

------------------------------------------------------------

Command:
docker restart <container-name>

Explanation:
Restarts a container.

Example:
docker restart termite

------------------------------------------------------------

Command:
docker rm <container-name>

Explanation:
Removes a stopped container.

Example:
docker rm termite

------------------------------------------------------------

Command:
docker rm -f <container-name>

Explanation:
Force removes a running container.

Example:
docker rm -f termite


============================================================
41.8 DOCKER TAG, PUSH, AND PULL
============================================================

Command:
docker tag <local-image>:<tag> <registry-url>/<repository>:<tag>

Explanation:
Tags a local image for a remote registry.

Example:
docker tag search_server:latest <account-id>.dkr.ecr.eu-west-1.amazonaws.com/search_server:latest

------------------------------------------------------------

Command:
docker push <registry-url>/<repository>:<tag>

Explanation:
Pushes a Docker image to a remote registry.

Example:
docker push <account-id>.dkr.ecr.eu-west-1.amazonaws.com/search_server:latest

------------------------------------------------------------

Command:
docker pull <registry-url>/<repository>:<tag>

Explanation:
Pulls an image from a remote registry.

Example:
docker pull <account-id>.dkr.ecr.eu-west-1.amazonaws.com/search_server:latest


============================================================
41.9 DOCKER INSPECT AND RESOURCE CHECKS
============================================================

Command:
docker inspect <container-name>

Explanation:
Shows detailed metadata about a container.

Example:
docker inspect termite

------------------------------------------------------------

Command:
docker inspect <image-name>:<tag>

Explanation:
Shows detailed metadata about an image.

Example:
docker inspect search_server:latest

------------------------------------------------------------

Command:
docker stats

Explanation:
Shows live CPU, memory, network, and disk usage for running containers.

Example:
docker stats

------------------------------------------------------------

Command:
docker stats <container-name>

Explanation:
Shows live resource usage for one container.

Example:
docker stats termite


============================================================
41.10 DOCKER DISK CLEANUP
============================================================

Command:
docker system df

Explanation:
Shows Docker disk usage.

Example:
docker system df

------------------------------------------------------------

Command:
docker image prune

Explanation:
Removes dangling images.

Example:
docker image prune

------------------------------------------------------------

Command:
docker image prune -a

Explanation:
Removes unused images. Use carefully.

Example:
docker image prune -a

------------------------------------------------------------

Command:
docker container prune

Explanation:
Removes stopped containers.

Example:
docker container prune

------------------------------------------------------------

Command:
docker system prune

Explanation:
Removes unused containers, networks, images, and build cache.

Example:
docker system prune

Warning:
Cleanup commands can remove images and containers needed later. Use carefully.


============================================================
41.11 DOCKER TROUBLESHOOTING
============================================================

Issue:
Docker push fails with no basic auth credentials.

Check:
docker login <registry-url>

Fix for AWS ECR:
aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <account-id>.dkr.ecr.<region>.amazonaws.com

------------------------------------------------------------

Issue:
Image not found.

Check:
docker images
docker pull <image-name>:<tag>

Possible causes:
- Wrong image name
- Wrong tag
- Wrong registry URL
- Missing registry permission

------------------------------------------------------------

Issue:
Container exits immediately.

Check:
docker ps -a
docker logs <container-name>
docker inspect <container-name>

Possible causes:
- Application startup error
- Missing environment variable
- Invalid command
- Permission issue
- Missing mounted file


============================================================
42. HELM COMMANDS
============================================================

Purpose:
This section contains Helm commands for creating charts, validating charts, installing releases, upgrading releases, rollback, uninstall, templating, values management, and troubleshooting.

============================================================
42.1 CHECK HELM VERSION
============================================================

Command:
helm version

Explanation:
Shows Helm client version.

Example:
helm version


============================================================
42.2 CREATE AND VALIDATE HELM CHART
============================================================

Command:
helm create <chart-name>

Explanation:
Creates a new Helm chart folder structure.

Example:
helm create admin-ui

------------------------------------------------------------

Command:
helm lint <chart-path>

Explanation:
Validates Helm chart syntax and common issues.

Example:
helm lint ./admin-ui

------------------------------------------------------------

Command:
helm dependency update <chart-path>

Explanation:
Downloads and updates chart dependencies listed in Chart.yaml.

Example:
helm dependency update ./admin-ui


============================================================
42.3 RENDER HELM TEMPLATES WITHOUT INSTALLING
============================================================

Command:
helm template <release-name> <chart-path> -f <values-file> --namespace <namespace>

Explanation:
Renders Kubernetes YAML locally without applying it to the cluster.

Example:
helm template gain-api ./gain-api -f ./gain-api/values-dev.yaml --namespace dev-gain-core

------------------------------------------------------------

Command:
helm template <release-name> <chart-path> -f <values-file> --namespace <namespace> --debug

Explanation:
Renders Helm templates with debug output.

Example:
helm template gain-api ./gain-api -f ./gain-api/values-dev.yaml --namespace dev-gain-core --debug


============================================================
42.4 INSTALL OR UPGRADE HELM RELEASE
============================================================

Command:
helm install <release-name> <chart-path> -n <namespace> --create-namespace -f <values-file>

Explanation:
Installs a Helm chart as a new release.

Example:
helm install admin-api-dev ./admin-api -n dev-gain --create-namespace -f admin-api/values.dev.yaml

------------------------------------------------------------

Command:
helm upgrade --install <release-name> <chart-path> -f <values-file> --namespace <namespace> --create-namespace

Explanation:
Installs the release if missing or upgrades it if it already exists.

Example:
helm upgrade --install gain-api-dev ./gain-api \
  -f gain-api/values-dev.yaml \
  --namespace dev-gain-core \
  --create-namespace


============================================================
42.5 HELM RELEASE CHECK COMMANDS
============================================================

Command:
helm list -n <namespace>

Explanation:
Lists Helm releases in a namespace.

Example:
helm list -n dev-gain-core

------------------------------------------------------------

Command:
helm list -A

Explanation:
Lists Helm releases across all namespaces.

Example:
helm list -A

------------------------------------------------------------

Command:
helm status <release-name> -n <namespace>

Explanation:
Shows status of a Helm release.

Example:
helm status gain-api-dev -n dev-gain-core

------------------------------------------------------------

Command:
helm get values <release-name> -n <namespace>

Explanation:
Shows custom values used for a Helm release.

Example:
helm get values gain-api-dev -n dev-gain-core

------------------------------------------------------------

Command:
helm get manifest <release-name> -n <namespace>

Explanation:
Shows rendered Kubernetes manifests installed by Helm.

Example:
helm get manifest gain-api-dev -n dev-gain-core

------------------------------------------------------------

Command:
helm history <release-name> -n <namespace>

Explanation:
Shows release revision history.

Example:
helm history gain-api-dev -n dev-gain-core


============================================================
42.6 HELM ROLLBACK AND UNINSTALL
============================================================

Command:
helm rollback <release-name> <revision-number> -n <namespace>

Explanation:
Rolls back a Helm release to a previous revision.

Example:
helm rollback gain-api-dev 2 -n dev-gain-core

------------------------------------------------------------

Command:
helm uninstall <release-name> -n <namespace>

Explanation:
Uninstalls a Helm release.

Example:
helm uninstall gain-api-dev -n dev-gain-core


============================================================
42.7 HELM DRY RUN
============================================================

Command:
helm upgrade --install <release-name> <chart-path> -f <values-file> --namespace <namespace> --dry-run --debug

Explanation:
Simulates Helm install or upgrade and prints debug output without applying changes.

Example:
helm upgrade --install gain-api-dev ./gain-api \
  -f gain-api/values-dev.yaml \
  --namespace dev-gain-core \
  --dry-run \
  --debug


============================================================
42.8 HELM TROUBLESHOOTING
============================================================

Issue:
Helm template fails.

Check:
helm lint <chart-path>
helm template <release-name> <chart-path> -f <values-file> --debug

Possible causes:
- YAML indentation issue
- Missing value in values.yaml
- Wrong template syntax
- Invalid Kubernetes API version

------------------------------------------------------------

Issue:
Helm upgrade succeeds but pod fails.

Check:
helm status <release-name> -n <namespace>
kubectl get pods -n <namespace>
kubectl describe pod <pod-name> -n <namespace>
kubectl logs <pod-name> -n <namespace>

Possible causes:
- Bad image
- Missing secret
- Wrong configmap
- Readiness or liveness probe failure
- Resource limit issue


============================================================
43. MONITORING AND RESOURCE USAGE COMMANDS
============================================================

Purpose:
This section contains commands to monitor CPU, memory, disk, pod usage, node usage, container usage, logs, events, and application health.

============================================================
43.1 KUBERNETES CPU AND MEMORY MONITORING
============================================================

Command:
kubectl top nodes

Explanation:
Shows CPU and memory usage for Kubernetes nodes.

Example:
kubectl top nodes

------------------------------------------------------------

Command:
kubectl top pods -n <namespace>

Explanation:
Shows CPU and memory usage for pods in a namespace.

Example:
kubectl top pods -n gain-prod

------------------------------------------------------------

Command:
kubectl top pods -A

Explanation:
Shows CPU and memory usage for pods across all namespaces.

Example:
kubectl top pods -A

------------------------------------------------------------

Command:
kubectl top pod <pod-name> -n <namespace>

Explanation:
Shows CPU and memory usage for one pod.

Example:
kubectl top pod api-deployment-xxxxx -n dev-gain-core

------------------------------------------------------------

Command:
kubectl top pod --all-namespaces -o wide

Explanation:
Shows pod resource usage across namespaces with node mapping.

Example:
kubectl top pod --all-namespaces -o wide


============================================================
43.2 CHECK RESOURCE REQUESTS AND LIMITS
============================================================

Command:
kubectl describe pod <pod-name> -n <namespace>

Explanation:
Shows CPU and memory requests and limits configured for each container.

Example:
kubectl describe pod api-deployment-xxxxx -n dev-gain-core

------------------------------------------------------------

Command:
kubectl get pod <pod-name> -n <namespace> -o jsonpath='{range .spec.containers[*]}{.name}{" requests="}{.resources.requests}{" limits="}{.resources.limits}{"\n"}{end}'

Explanation:
Prints container resource requests and limits using jsonpath.

Example:
kubectl get pod api-deployment-xxxxx -n dev-gain-core -o jsonpath='{range .spec.containers[*]}{.name}{" requests="}{.resources.requests}{" limits="}{.resources.limits}{"\n"}{end}'

------------------------------------------------------------

Command:
kubectl -n <namespace> set resources deployment/<deployment-name> --containers=<container-name> --requests=cpu=<cpu>,memory=<memory> --limits=cpu=<cpu>,memory=<memory>

Explanation:
Updates CPU and memory requests and limits for a deployment.

Example:
kubectl -n dev-gain-core set resources deployment/api-deployment \
  --containers=api \
  --requests=cpu=600m,memory=1024Mi \
  --limits=cpu=1000m,memory=2048Mi


============================================================
43.3 BASIC LINUX CPU COMMANDS
============================================================

Command:
lscpu

Explanation:
Shows CPU architecture, number of CPUs, sockets, cores, and threads.

Example:
lscpu

------------------------------------------------------------

Command:
nproc

Explanation:
Shows number of available CPU cores.

Example:
nproc

------------------------------------------------------------

Command:
top

Explanation:
Shows real-time CPU and memory usage.

Example:
top

------------------------------------------------------------

Command:
uptime

Explanation:
Shows system uptime and load average.

Example:
uptime

------------------------------------------------------------

Command:
cat /proc/loadavg

Explanation:
Shows system load average.

Example:
cat /proc/loadavg

------------------------------------------------------------

Command:
ps aux | sort -rk 3,3 | head -n 10

Explanation:
Shows top 10 CPU-consuming processes.

Example:
ps aux | sort -rk 3,3 | head -n 10

------------------------------------------------------------

Command:
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -20

Explanation:
Shows top CPU-consuming processes with PID, parent PID, command, memory, and CPU.

Example:
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -20

------------------------------------------------------------

Command:
mpstat 1 5

Explanation:
Shows CPU usage every 1 second for 5 times. Requires sysstat package.

Example:
mpstat 1 5


============================================================
43.4 BASIC LINUX MEMORY COMMANDS
============================================================

Command:
free -h

Explanation:
Shows memory usage in human-readable format.

Example:
free -h

------------------------------------------------------------

Command:
cat /proc/meminfo | head

Explanation:
Shows memory details from proc filesystem.

Example:
cat /proc/meminfo | head

------------------------------------------------------------

Command:
ps aux | sort -rk 4,4 | head -n 10

Explanation:
Shows top 10 memory-consuming processes.

Example:
ps aux | sort -rk 4,4 | head -n 10

------------------------------------------------------------

Command:
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -20

Explanation:
Shows top memory-consuming processes.

Example:
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -20


============================================================
43.5 BASIC DISK MONITORING COMMANDS
============================================================

Command:
df -h

Explanation:
Shows filesystem disk usage.

Example:
df -h

------------------------------------------------------------

Command:
du -sh <path>

Explanation:
Shows total size of a directory or file.

Example:
du -sh /var/log

------------------------------------------------------------

Command:
du -ah <path> | sort -hr | head -20

Explanation:
Shows largest files and folders under a path.

Example:
du -ah /var/lib/clickhouse | sort -hr | head -20

------------------------------------------------------------

Command:
find <path> -type f -size +100M

Explanation:
Finds files larger than 100 MB.

Example:
find /var/log -type f -size +100M


============================================================
43.6 KUBERNETES EVENTS AND LOG MONITORING
============================================================

Command:
kubectl get events -n <namespace> --sort-by=.metadata.creationTimestamp

Explanation:
Shows namespace events sorted by time.

Example:
kubectl get events -n dev-gain-core --sort-by=.metadata.creationTimestamp

------------------------------------------------------------

Command:
kubectl get events -A --sort-by=.metadata.creationTimestamp

Explanation:
Shows cluster-wide events sorted by time.

Example:
kubectl get events -A --sort-by=.metadata.creationTimestamp

------------------------------------------------------------

Command:
kubectl logs <pod-name> -n <namespace> --tail=200

Explanation:
Shows last 200 log lines from a pod.

Example:
kubectl logs api-deployment-xxxxx -n dev-gain-core --tail=200

------------------------------------------------------------

Command:
kubectl logs -f <pod-name> -n <namespace>

Explanation:
Streams live logs from a pod.

Example:
kubectl logs -f api-deployment-xxxxx -n dev-gain-core

------------------------------------------------------------

Command:
kubectl logs deploy/<deployment-name> -n <namespace> --tail=200 -f

Explanation:
Streams logs from pods managed by a deployment.

Example:
kubectl logs deploy/api-deployment -n dev-gain-core --tail=200 -f


============================================================
43.7 MONITORING HEALTH ENDPOINTS
============================================================

Command:
curl -I <url>

Explanation:
Checks HTTP headers from a URL.

Example:
curl -I https://gain-qa.example.com

------------------------------------------------------------

Command:
curl -vk <url>

Explanation:
Checks HTTPS connectivity with verbose output and ignores certificate verification for troubleshooting.

Example:
curl -vk https://dev-milvus.example.com/api/v1/healthy

------------------------------------------------------------

Command:
curl -sS -o /dev/null -w "HTTP=%{http_code} TIME=%{time_total}\n" <url>

Explanation:
Checks HTTP status code and response time.

Example:
curl -sS -o /dev/null -w "HTTP=%{http_code} TIME=%{time_total}\n" https://example.com/health


============================================================
43.8 SIMPLE POD USAGE SCRIPT
============================================================

File name:
pod_usage_check.sh

Command:
cat > pod_usage_check.sh <<'EOF'
#!/bin/bash

echo "Namespace: gain-preprod"
kubectl top pods -n gain-preprod

echo "--------------------------------"

echo "Namespace: gain-prod"
kubectl top pods -n gain-prod
EOF

chmod +x pod_usage_check.sh
./pod_usage_check.sh

Explanation:
Creates and runs a simple script to check pod CPU and memory usage in preprod and prod namespaces.

Security Note:
This script does not expose secret values.


============================================================
44. DEVOPS AND CI CD COMMANDS
============================================================

Purpose:
This section contains commonly used DevOps commands for Git, Jenkins, Azure DevOps agents, pipeline validation, environment checks, and safe troubleshooting.

============================================================
44.1 GIT DAILY WORKFLOW
============================================================

Command:
git status

Explanation:
Shows current branch and local changes.

Example:
git status

------------------------------------------------------------

Command:
git fetch origin

Explanation:
Fetches latest branch information from remote.

Example:
git fetch origin

------------------------------------------------------------

Command:
git checkout <branch-name>

Explanation:
Switches to a branch.

Example:
git checkout preprod_jenkinsfile

------------------------------------------------------------

Command:
git pull origin <branch-name>

Explanation:
Pulls latest changes from remote branch.

Example:
git pull origin preprod_jenkinsfile

------------------------------------------------------------

Command:
git merge origin/main

Explanation:
Merges latest origin main into current branch.

Example:
git merge origin/main

------------------------------------------------------------

Command:
git add .

Explanation:
Stages all local changes.

Example:
git add .

------------------------------------------------------------

Command:
git commit -m "<message>"

Explanation:
Commits staged changes.

Example:
git commit -m "Updated deployment configuration"

------------------------------------------------------------

Command:
git push origin <branch-name>

Explanation:
Pushes local commits to remote branch.

Example:
git push origin preprod_jenkinsfile


============================================================
44.2 GIT TROUBLESHOOTING
============================================================

Command:
git log --oneline -10

Explanation:
Shows last 10 commits.

Example:
git log --oneline -10

------------------------------------------------------------

Command:
git diff

Explanation:
Shows unstaged local changes.

Example:
git diff

------------------------------------------------------------

Command:
git diff --staged

Explanation:
Shows staged changes.

Example:
git diff --staged

------------------------------------------------------------

Command:
git stash

Explanation:
Temporarily saves local uncommitted changes.

Example:
git stash

------------------------------------------------------------

Command:
git stash pop

Explanation:
Restores latest stash and removes it from stash list.

Example:
git stash pop

------------------------------------------------------------

Command:
git merge --abort

Explanation:
Cancels an active merge.

Example:
git merge --abort

------------------------------------------------------------

Command:
git rebase --abort

Explanation:
Cancels an active rebase.

Example:
git rebase --abort

------------------------------------------------------------

Command:
git reflog

Explanation:
Shows history of HEAD movement. Useful to recover lost commits.

Example:
git reflog


============================================================
44.3 JENKINS BRANCH FILTER REGEX
============================================================

Use case:
Trigger Jenkins job for one branch only.

Regular expression:
^jenkinsfile$

Explanation:
Triggers job only for the branch named jenkinsfile.

------------------------------------------------------------

Use case:
Trigger Jenkins job for multiple branches.

Regular expression:
^(jenkins-backend|jenkinsfile)$

Explanation:
Triggers job for jenkins-backend or jenkinsfile branches.

------------------------------------------------------------

Use case:
Trigger Jenkins job for QA pipeline branches.

Regular expression:
^(jenkinspipelineqa|jenkinsfile|main)$

Explanation:
Triggers job for jenkinspipelineqa, jenkinsfile, or main branches.


============================================================
44.4 JENKINS AGENT BASIC CHECKS
============================================================

Command:
whoami

Explanation:
Shows user running the Jenkins build.

Example:
whoami

------------------------------------------------------------

Command:
pwd

Explanation:
Shows current Jenkins workspace directory.

Example:
pwd

------------------------------------------------------------

Command:
env | sort

Explanation:
Shows environment variables. Avoid printing secrets in shared logs.

Example:
env | sort

------------------------------------------------------------

Command:
docker --version

Explanation:
Checks Docker availability on Jenkins agent.

Example:
docker --version

------------------------------------------------------------

Command:
kubectl version --client

Explanation:
Checks kubectl client availability.

Example:
kubectl version --client

------------------------------------------------------------

Command:
helm version

Explanation:
Checks Helm availability.

Example:
helm version

------------------------------------------------------------

Command:
aws --version

Explanation:
Checks AWS CLI availability.

Example:
aws --version

------------------------------------------------------------

Command:
az version

Explanation:
Checks Azure CLI availability.

Example:
az version


============================================================
44.5 AZURE DEVOPS AGENT VALIDATION
============================================================

Command:
kubectl get pods -n <agent-namespace>

Explanation:
Lists Azure DevOps agent pods.

Example:
kubectl get pods -n aksagent-dev

------------------------------------------------------------

Command:
kubectl describe pod <pod-name> -n <agent-namespace>

Explanation:
Shows pod events and container status for the agent pod.

Example:
kubectl describe pod azdo-agent-xxxxx -n aksagent-dev

------------------------------------------------------------

Command:
kubectl logs <pod-name> -n <agent-namespace>

Explanation:
Shows Azure DevOps agent pod logs.

Example:
kubectl logs azdo-agent-xxxxx -n aksagent-dev

------------------------------------------------------------

Command:
kubectl exec -it <pod-name> -n <agent-namespace> -- sh

Explanation:
Execs into the Azure DevOps agent pod.

Example:
kubectl exec -it azdo-agent-xxxxx -n aksagent-dev -- sh

Inside pod checks:
whoami
id
pwd
node --version
npm --version
docker --version
kubectl version --client
helm version


============================================================
44.6 SAFE PIPELINE VALIDATION STEPS
============================================================

Purpose:
Use these steps in a pipeline to validate tools without exposing secrets.

Pipeline check commands:
whoami
id
pwd
node --version
npm --version
python3 --version
docker --version
kubectl version --client
helm version
aws --version
az version

Explanation:
These commands verify tool availability on a build agent.

Important:
Avoid commands that print secret variables. Mask credentials in Jenkins or Azure DevOps.


============================================================
45. AWS ECR DEVOPS COMMANDS
============================================================

Purpose:
This section contains safe AWS ECR commands for login, build, push, and verification.

============================================================
45.1 CHECK AWS IDENTITY
============================================================

Command:
aws sts get-caller-identity

Explanation:
Shows active AWS account and role identity.

Example:
aws sts get-caller-identity

Security Note:
This does not print secret keys.


============================================================
45.2 ASSUME ROLE SAFELY
============================================================

Command:
aws sts assume-role \
  --role-arn "arn:aws:iam::<account-id>:role/<role-name>" \
  --role-session-name "<session-name>" \
  --external-id "<external-id>" \
  --query 'AssumedRoleUser.Arn' \
  --output text

Explanation:
Tests role assumption and prints only the assumed role ARN, not credentials.

Example:
aws sts assume-role \
  --role-arn "arn:aws:iam::<account-id>:role/<role-name>" \
  --role-session-name "<session-name>" \
  --external-id "<external-id>" \
  --query 'AssumedRoleUser.Arn' \
  --output text


============================================================
45.3 ECR LOGIN
============================================================

Command:
aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <account-id>.dkr.ecr.<region>.amazonaws.com

Explanation:
Logs Docker into AWS ECR using active AWS credentials.

Example:
aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin <account-id>.dkr.ecr.eu-west-1.amazonaws.com


============================================================
45.4 BUILD AND PUSH IMAGE TO ECR
============================================================

Command:
docker build -t <repository-name>:<tag> -f Dockerfile .

Explanation:
Builds local Docker image.

Example:
docker build -t search_server:latest -f Dockerfile .

------------------------------------------------------------

Command:
docker tag <repository-name>:<tag> <account-id>.dkr.ecr.<region>.amazonaws.com/<repository-name>:<tag>

Explanation:
Tags local image for ECR.

Example:
docker tag search_server:latest <account-id>.dkr.ecr.eu-west-1.amazonaws.com/search_server:latest

------------------------------------------------------------

Command:
docker push <account-id>.dkr.ecr.<region>.amazonaws.com/<repository-name>:<tag>

Explanation:
Pushes image to ECR.

Example:
docker push <account-id>.dkr.ecr.eu-west-1.amazonaws.com/search_server:latest


============================================================
45.5 VERIFY IMAGE IN ECR
============================================================

Command:
aws ecr describe-repositories --region <region>

Explanation:
Lists ECR repositories.

Example:
aws ecr describe-repositories --region eu-west-1

------------------------------------------------------------

Command:
aws ecr describe-images --repository-name <repository-name> --region <region>

Explanation:
Lists images in an ECR repository.

Example:
aws ecr describe-images --repository-name search_server --region eu-west-1

------------------------------------------------------------

Command:
aws ecr describe-images \
  --repository-name <repository-name> \
  --image-ids imageTag=<tag> \
  --region <region>

Explanation:
Checks whether a specific image tag exists.

Example:
aws ecr describe-images \
  --repository-name search_server \
  --image-ids imageTag=latest \
  --region eu-west-1


============================================================
46. KUBERNETES STORAGE, BLOBFUSE, AND CSI TROUBLESHOOTING
============================================================

Purpose:
This section contains commands for checking PVC, PV, storage class, Azure File CSI, BlobFuse resources, and volume mount issues.

============================================================
46.1 CHECK STORAGE CLASSES
============================================================

Command:
kubectl get storageclass

Explanation:
Lists available storage classes in the cluster.

Example:
kubectl get storageclass


============================================================
46.2 CHECK PVC AND PV
============================================================

Command:
kubectl get pvc -n <namespace>

Explanation:
Lists PVCs in a namespace.

Example:
kubectl get pvc -n dev-gain-core

------------------------------------------------------------

Command:
kubectl describe pvc <pvc-name> -n <namespace>

Explanation:
Shows PVC details and events.

Example:
kubectl describe pvc data-pvc -n dev-gain-core

------------------------------------------------------------

Command:
kubectl get pv

Explanation:
Lists persistent volumes.

Example:
kubectl get pv

------------------------------------------------------------

Command:
kubectl describe pv <pv-name>

Explanation:
Shows PV details.

Example:
kubectl describe pv pvc-xxxxx


============================================================
46.3 RETAIN PV AFTER PVC DELETE
============================================================

Command:
kubectl patch pv <pv-name> -p '{"spec":{"persistentVolumeReclaimPolicy":"Retain"}}'

Explanation:
Changes PV reclaim policy to Retain so data is not deleted when PVC is deleted.

Example:
kubectl patch pv pvc-xxxxx -p '{"spec":{"persistentVolumeReclaimPolicy":"Retain"}}'


============================================================
46.4 EXPAND PVC SIZE
============================================================

Command:
kubectl patch pvc <pvc-name> -n <namespace> -p '{"spec":{"resources":{"requests":{"storage":"50Gi"}}}}'

Explanation:
Expands PVC storage request to 50Gi. StorageClass must allow expansion.

Example:
kubectl patch pvc data-pvc -n gain-prod -p '{"spec":{"resources":{"requests":{"storage":"50Gi"}}}}'


============================================================
46.5 AZURE FILE CSI DRIVER CHECKS
============================================================

Command:
kubectl get pods -n kube-system | grep azurefile

Explanation:
Lists Azure File CSI driver pods.

Example:
kubectl get pods -n kube-system | grep azurefile

------------------------------------------------------------

Command:
kubectl logs <azurefile-csi-pod-name> -n kube-system -c azurefile

Explanation:
Checks Azure File CSI driver logs.

Example:
kubectl logs csi-azurefile-node-xxxxx -n kube-system -c azurefile

------------------------------------------------------------

Command:
kubectl logs <azurefile-csi-pod-name> -n kube-system -c node-driver-registrar

Explanation:
Checks node driver registrar logs for CSI.

Example:
kubectl logs csi-azurefile-node-xxxxx -n kube-system -c node-driver-registrar


============================================================
46.6 BLOBFUSE RESOURCE CHECKS
============================================================

Command:
kubectl get pv | grep blobfuse

Explanation:
Lists BlobFuse related persistent volumes.

Example:
kubectl get pv | grep blobfuse

------------------------------------------------------------

Command:
kubectl get pvc -n <namespace> | grep blobfuse

Explanation:
Lists BlobFuse related PVCs in a namespace.

Example:
kubectl get pvc -n gain-preprod | grep blobfuse

------------------------------------------------------------

Command:
kubectl describe pv <blobfuse-pv-name>

Explanation:
Shows BlobFuse PV details.

Example:
kubectl describe pv blobfuse-pv-blob

------------------------------------------------------------

Command:
kubectl describe pvc <blobfuse-pvc-name> -n <namespace>

Explanation:
Shows BlobFuse PVC details.

Example:
kubectl describe pvc blobfuse-pvc-blob -n gain-preprod


============================================================
47. CERTIFICATE AND TLS COMMANDS
============================================================

Purpose:
This section contains commands to generate private keys, CSRs, TLS secrets, and validate certificate dates.

Important Security Note:
Private keys must be protected. Do not paste private key contents into chat, tickets, Git, Word, or Notepad.

============================================================
47.1 GENERATE RSA PRIVATE KEY
============================================================

Command:
openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -out <name>.key

Explanation:
Generates a 2048-bit RSA private key.

Example:
openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -out realtime.key


============================================================
47.2 GENERATE CSR USING EXISTING KEY
============================================================

Command:
openssl req -new -key <name>.key -out <name>.csr -config <openssl-config.cnf>

Explanation:
Generates a certificate signing request using an existing private key.

Example:
openssl req -new -key realtime.key -out realtime.csr -config openssl-realtime.cnf


============================================================
47.3 GENERATE KEY AND CSR TOGETHER
============================================================

Command:
openssl req -out <name>.csr -newkey rsa:2048 -nodes -keyout <name>.key -config <openssl-config.cnf>

Explanation:
Generates a private key and CSR in one command.

Example:
openssl req -out realtime.csr -newkey rsa:2048 -nodes -keyout realtime.key -config openssl-realtime.cnf


============================================================
47.4 CREATE KUBERNETES TLS SECRET
============================================================

Command:
kubectl create secret tls <secret-name> --cert=<cert-file.pem> --key=<key-file.key> -n <namespace>

Explanation:
Creates a Kubernetes TLS secret using certificate and private key files.

Example:
kubectl create secret tls gain-dev-tls --cert=cert_gain-dev.pem --key=gain-dev.key -n dev-gain-core


============================================================
47.5 CHECK CERTIFICATE VALIDITY FROM FILE
============================================================

Command:
openssl x509 -in <cert-file.pem> -noout -dates

Explanation:
Shows certificate start and expiry dates.

Example:
openssl x509 -in cert_gain-dev.pem -noout -dates


============================================================
47.6 CHECK CERTIFICATE VALIDITY FROM KUBERNETES TLS SECRET
============================================================

Command:
kubectl get secret <tls-secret-name> -n <namespace> -o jsonpath='{.data.tls\.crt}' | base64 -d | openssl x509 -noout -dates

Explanation:
Checks expiry date of the public certificate stored inside a Kubernetes TLS secret.

Example:
kubectl get secret gain-dev-tls -n dev-gain-core -o jsonpath='{.data.tls\.crt}' | base64 -d | openssl x509 -noout -dates


============================================================
47.7 CHECK REMOTE SERVER CERTIFICATE
============================================================

Command:
openssl s_client -connect <hostname>:443 -servername <hostname> </dev/null 2>/dev/null | openssl x509 -noout -dates

Explanation:
Checks certificate validity dates from a remote HTTPS endpoint.

Example:
openssl s_client -connect example.com:443 -servername example.com </dev/null 2>/dev/null | openssl x509 -noout -dates


============================================================
48. API, CURL, PROXY, AND CONNECTIVITY COMMANDS
============================================================

Purpose:
This section contains safe commands for checking API endpoints, proxies, DNS, and HTTP connectivity.

Important Security Note:
Do not paste real x-api-key values in documents or chat. Use <api-key> placeholder.

============================================================
48.1 CURL GET REQUEST WITH API KEY PLACEHOLDER
============================================================

Command:
curl -X GET "<api-url>" \
  -H "accept: application/json" \
  -H "x-api-key: <api-key>"

Explanation:
Sends a GET request to an API endpoint with an API key header.

Example:
curl -X GET "https://example.com/fastapi/credentials/get-credentials" \
  -H "accept: application/json" \
  -H "x-api-key: <api-key>"


============================================================
48.2 CHECK PROXY ENVIRONMENT VARIABLES
============================================================

Command:
env | grep -i proxy

Explanation:
Shows proxy environment variables.

Example:
env | grep -i proxy

------------------------------------------------------------

Command:
export NO_PROXY="$NO_PROXY,<hostname>"

Explanation:
Adds a hostname to the NO_PROXY list.

Example:
export NO_PROXY="$NO_PROXY,internal.example.com"

------------------------------------------------------------

Command:
export no_proxy="$no_proxy,<hostname>"

Explanation:
Adds a hostname to lowercase no_proxy variable.

Example:
export no_proxy="$no_proxy,internal.example.com"


============================================================
48.3 CHECK DNS AND HTTP CONNECTIVITY
============================================================

Command:
nslookup <hostname>

Explanation:
Checks DNS resolution.

Example:
nslookup api-service

------------------------------------------------------------

Command:
getent hosts <hostname>

Explanation:
Checks hostname resolution using system resolver.

Example:
getent hosts postgres.example.com

------------------------------------------------------------

Command:
curl -v <url>

Explanation:
Tests HTTP or HTTPS connectivity with verbose output.

Example:
curl -v https://example.com

------------------------------------------------------------

Command:
curl -I <url>

Explanation:
Checks HTTP response headers.

Example:
curl -I https://example.com

------------------------------------------------------------

Command:
curl -vk <url>

Explanation:
Checks HTTPS connectivity and skips TLS verification for troubleshooting.

Example:
curl -vk https://example.com/health


============================================================
49. REDIS CONNECTIVITY COMMANDS
============================================================

Purpose:
Redis is not HTTP, so use DNS and TCP connectivity checks instead of normal curl.

============================================================
49.1 REDIS ENVIRONMENT CHECK
============================================================

Command:
env | grep -i redis

Explanation:
Shows Redis-related environment variables.

Example:
env | grep -i redis


============================================================
49.2 REDIS DNS CHECK
============================================================

Command:
nslookup <redis-hostname>

Explanation:
Checks Redis hostname DNS resolution.

Example:
nslookup redis.example.cache.windows.net


============================================================
49.3 REDIS TCP PORT CHECK
============================================================

Command:
nc -zv <redis-hostname> 6380

Explanation:
Checks TCP connectivity to Redis TLS port.

Example:
nc -zv redis.example.cache.windows.net 6380

------------------------------------------------------------

Command:
bash -lc 'echo > /dev/tcp/<redis-hostname>/6380 && echo CONNECTED || echo FAILED'

Explanation:
Checks Redis TCP connectivity when netcat is unavailable.

Example:
bash -lc 'echo > /dev/tcp/redis.example.cache.windows.net/6380 && echo CONNECTED || echo FAILED'

------------------------------------------------------------

Command:
curl -vk telnet://<redis-hostname>:6380

Explanation:
Checks whether the Redis port is reachable. This does not validate Redis authentication.

Example:
curl -vk telnet://redis.example.cache.windows.net:6380


============================================================
50. CLICKHOUSE STORAGE AND LOG CLEANUP
============================================================

Purpose:
This section contains commands for checking ClickHouse storage usage and cleaning system logs only when approved.

Warning:
Do not delete database data without approval and backup. The rm -rf commands below should be used only for known ClickHouse system log folders and only after approval.

============================================================
50.1 CHECK CLICKHOUSE DISK USAGE
============================================================

Command:
df -h

Explanation:
Shows filesystem usage.

Example:
df -h

------------------------------------------------------------

Command:
du -ah /var/lib/clickhouse | sort -hr | head -20

Explanation:
Shows largest ClickHouse folders and files.

Example:
du -ah /var/lib/clickhouse | sort -hr | head -20


============================================================
50.2 CLICKHOUSE SYSTEM LOG CLEANUP
============================================================

Command:
rm -rf /var/lib/clickhouse/data/system/text_log/

Explanation:
Removes ClickHouse text log data.

------------------------------------------------------------

Command:
rm -rf /var/lib/clickhouse/data/system/trace_log/

Explanation:
Removes ClickHouse trace log data.

------------------------------------------------------------

Command:
rm -rf /var/lib/clickhouse/data/system/metric_log/

Explanation:
Removes ClickHouse metric log data.

------------------------------------------------------------

Command:
rm -rf /var/lib/clickhouse/data/system/asynchronous_metric_log/

Explanation:
Removes ClickHouse asynchronous metric log data.

------------------------------------------------------------

Command:
rm -rf /var/lib/clickhouse/data/system/opentelemetry_span_log/

Explanation:
Removes ClickHouse OpenTelemetry span log data.

------------------------------------------------------------

Command:
rm -rf /var/lib/clickhouse/data/system/query_log/

Explanation:
Removes ClickHouse query log data.

------------------------------------------------------------

Command:
rm -rf /var/lib/clickhouse/data/system/processors_profile_log/

Explanation:
Removes ClickHouse processor profile log data.

------------------------------------------------------------

Command:
rm -rf /var/lib/clickhouse/data/system/part_log/

Explanation:
Removes ClickHouse part log data.


============================================================
51. KUBERNETES BACKUP AND RESTORE COMMANDS
============================================================

Purpose:
This section contains commands for backing up and restoring Kubernetes resources.

Important Security Note:
Backing up secrets exports sensitive values in base64 format. Base64 is not encryption.
Store secret backups securely and restrict access.

============================================================
51.1 BACKUP RESOURCES WITHOUT SECRETS
============================================================

Command:
kubectl get pvc,po,svc,cm,deploy,ingress,hpa,cronjob,sa,sts,ds,netpol,role,pdb -n <namespace> -o yaml > <backup-file>.yaml

Explanation:
Backs up common namespace resources excluding secrets.

Example:
kubectl get pvc,po,svc,cm,deploy,ingress,hpa,cronjob,sa,sts,ds,netpol,role,pdb -n termite-dev -o yaml > termite-dev-backup.yaml


============================================================
51.2 BACKUP RESOURCES INCLUDING SECRETS
============================================================

Command:
kubectl get pvc,po,svc,cm,secret,deploy,ingress,hpa,cronjob,sa,sts,ds,netpol,role,pdb -n <namespace> -o yaml > <backup-file>.yaml

Explanation:
Backs up namespace resources including secrets.

Example:
kubectl get pvc,po,svc,cm,secret,deploy,ingress,hpa,cronjob,sa,sts,ds,netpol,role,pdb -n docling-dev -o yaml > docling-dev-backup-with-secrets.yaml

Warning:
This file contains sensitive secret data. Store securely.


============================================================
51.3 RESTORE BACKUP
============================================================

Command:
kubectl create -f <backup-file>.yaml -n <namespace>

Explanation:
Creates resources from backup file if resources do not already exist.

Example:
kubectl create -f termite-dev-backup.yaml -n termite-dev

------------------------------------------------------------

Command:
kubectl apply -f <backup-file>.yaml -n <namespace>

Explanation:
Creates or updates resources from backup file.

Example:
kubectl apply -f termite-dev-backup.yaml -n termite-dev


============================================================
52. KUBERNETES DAILY OPERATIONS QUICK SHEET
============================================================

Check current context:
kubectl config current-context

Set namespace:
kubectl config set-context --current --namespace=<namespace>

List namespaces:
kubectl get ns

List pods:
kubectl get pods -n <namespace> -o wide

List deployments, services, ingress:
kubectl get deploy,svc,ingress -n <namespace>

Describe pod:
kubectl describe pod <pod-name> -n <namespace>

Check logs:
kubectl logs <pod-name> -n <namespace> --tail=200

Follow logs:
kubectl logs -f <pod-name> -n <namespace>

Check events:
kubectl get events -n <namespace> --sort-by=.metadata.creationTimestamp

Check pod resource usage:
kubectl top pods -n <namespace>

Restart deployment:
kubectl rollout restart deployment/<deployment-name> -n <namespace>

Scale deployment:
kubectl scale deployment <deployment-name> --replicas=<count> -n <namespace>

Check service endpoints:
kubectl get endpoints <service-name> -n <namespace> -o wide

Exec into pod:
kubectl exec -it <pod-name> -n <namespace> -- sh

Copy file to pod:
kubectl cp <local-file> <namespace>/<pod-name>:<target-path>

Copy file from pod:
kubectl cp <namespace>/<pod-name>:<source-path> <local-path>


============================================================
53. SAFE SECRET HANDLING COMMANDS
============================================================

Purpose:
This section shows safer patterns for secret handling.

============================================================
53.1 CREATE SECRET FROM ENV FILE
============================================================

Command:
kubectl create secret generic <secret-name> --from-env-file=<env-file> -n <namespace>

Explanation:
Creates a Kubernetes Secret from an environment file.

Example:
kubectl create secret generic backend-env-secret --from-env-file=.env -n app-dev

Security Note:
Do not commit .env files to Git.


============================================================
53.2 CREATE SECRET FROM FILE
============================================================

Command:
kubectl create secret generic <secret-name> --from-file=<key>=<file-path> -n <namespace>

Explanation:
Creates a Kubernetes Secret from a file.

Example:
kubectl create secret generic app-license --from-file=license.lic=/secure/path/license.lic -n app-dev


============================================================
53.3 CREATE TLS SECRET
============================================================

Command:
kubectl create secret tls <secret-name> --cert=<cert-file.pem> --key=<key-file.key> -n <namespace>

Explanation:
Creates a Kubernetes TLS secret.

Example:
kubectl create secret tls app-tls --cert=cert_app.pem --key=app.key -n app-dev


============================================================
53.4 INSPECT SECRET METADATA ONLY
============================================================

Command:
kubectl describe secret <secret-name> -n <namespace>

Explanation:
Shows metadata and keys without decoding secret values.

Example:
kubectl describe secret app-secret -n app-dev


============================================================
54. WINDOWS BASIC TROUBLESHOOTING
============================================================

Purpose:
This section contains basic Windows troubleshooting commands.

============================================================
54.1 OPEN TASK MANAGER
============================================================

Action:
Press Ctrl + Shift + Esc

Explanation:
Opens Task Manager directly.


============================================================
54.2 RESTART WINDOWS EXPLORER
============================================================

Command:
taskkill /f /im explorer.exe

Explanation:
Force stops Windows Explorer.

Example:
taskkill /f /im explorer.exe

------------------------------------------------------------

Command:
start explorer.exe

Explanation:
Starts Windows Explorer again.

Example:
start explorer.exe


============================================================
55. FINAL SECURITY CHECKLIST
============================================================

1. Rotate exposed PAT tokens.
2. Rotate exposed Azure Storage account keys.
3. Rotate exposed database passwords.
4. Rotate exposed API keys.
5. Rotate exposed AWS temporary credentials if still active.
6. Rotate exposed Kubernetes secrets if values were copied into documents.
7. Do not store kubeconfig files in shared folders without access control.
8. Do not store private keys in Git, Word, Notepad, screenshots, or tickets.
9. Use Azure Key Vault, AWS Secrets Manager, Kubernetes External Secrets, sealed secrets, or approved enterprise secret stores.
10. Use placeholders in documentation instead of real credentials.
11. Review access logs after any secret exposure.
12. Remove secrets from shell history if typed directly.

Command:
history | grep -i "key\|secret\|password\|token"

Explanation:
Searches shell history for possible exposed secrets.

Example:
history | grep -i "key\|secret\|password\|token"

Command:
history -c

Explanation:
Clears current shell history. Use according to your company policy.

Example:
history -c

END UPDATED DOCKER HELM MONITORING DEVOPS CPU SECTION

START UPDATED K8S CONTAINER REGISTRY LOGS AND ERROR TROUBLESHOOTING SECTION

============================================================
56. KUBERNETES LOGS COMMANDS
============================================================

Purpose:
This section contains Kubernetes log commands for pods, deployments, jobs, init containers, previous crashed containers, system components, ingress controllers, CSI drivers, and troubleshooting.

============================================================
56.1 BASIC POD LOGS
============================================================

Command:
kubectl logs <pod-name> -n <namespace>

Explanation:
Shows logs from the default container in a pod.

Example:
kubectl logs api-deployment-xxxxx -n dev-gain-core

------------------------------------------------------------

Command:
kubectl logs -f <pod-name> -n <namespace>

Explanation:
Streams live logs from a pod.

Example:
kubectl logs -f api-deployment-xxxxx -n dev-gain-core

------------------------------------------------------------

Command:
kubectl logs <pod-name> -n <namespace> --tail=200

Explanation:
Shows the last 200 lines from pod logs.

Example:
kubectl logs api-deployment-xxxxx -n dev-gain-core --tail=200

------------------------------------------------------------

Command:
kubectl logs <pod-name> -n <namespace> --since=1h

Explanation:
Shows logs from the last 1 hour.

Example:
kubectl logs api-deployment-xxxxx -n dev-gain-core --since=1h

------------------------------------------------------------

Command:
kubectl logs <pod-name> -n <namespace> --timestamps

Explanation:
Shows pod logs with timestamps.

Example:
kubectl logs api-deployment-xxxxx -n dev-gain-core --timestamps


============================================================
56.2 LOGS FOR MULTI CONTAINER PODS
============================================================

Command:
kubectl logs <pod-name> -n <namespace> -c <container-name>

Explanation:
Shows logs from a specific container in a multi-container pod.

Example:
kubectl logs app-pod-xxxxx -n dev-gain-core -c app-container

------------------------------------------------------------

Command:
kubectl logs <pod-name> -n <namespace> --all-containers=true

Explanation:
Shows logs from all containers in a pod.

Example:
kubectl logs app-pod-xxxxx -n dev-gain-core --all-containers=true

------------------------------------------------------------

Command:
kubectl logs <pod-name> -n <namespace> --all-containers=true --tail=200

Explanation:
Shows the last 200 log lines from all containers in a pod.

Example:
kubectl logs app-pod-xxxxx -n dev-gain-core --all-containers=true --tail=200


============================================================
56.3 PREVIOUS CONTAINER LOGS
============================================================

Command:
kubectl logs <pod-name> -n <namespace> --previous

Explanation:
Shows logs from the previous crashed container instance. Useful for CrashLoopBackOff issues.

Example:
kubectl logs api-deployment-xxxxx -n dev-gain-core --previous

------------------------------------------------------------

Command:
kubectl logs <pod-name> -n <namespace> -c <container-name> --previous

Explanation:
Shows previous logs for a specific container.

Example:
kubectl logs app-pod-xxxxx -n dev-gain-core -c app-container --previous


============================================================
56.4 DEPLOYMENT, STATEFULSET, DAEMONSET, AND JOB LOGS
============================================================

Command:
kubectl logs deploy/<deployment-name> -n <namespace> --tail=200

Explanation:
Shows recent logs from pods managed by a deployment.

Example:
kubectl logs deploy/api-deployment -n dev-gain-core --tail=200

------------------------------------------------------------

Command:
kubectl logs deploy/<deployment-name> -n <namespace> --tail=200 -f

Explanation:
Streams logs from pods managed by a deployment.

Example:
kubectl logs deploy/api-deployment -n dev-gain-core --tail=200 -f

------------------------------------------------------------

Command:
kubectl logs statefulset/<statefulset-name> -n <namespace> --tail=200

Explanation:
Shows logs from pods managed by a StatefulSet.

Example:
kubectl logs statefulset/clickhouse -n dev-gain-core --tail=200

------------------------------------------------------------

Command:
kubectl logs daemonset/<daemonset-name> -n <namespace> --tail=200

Explanation:
Shows logs from pods managed by a DaemonSet.

Example:
kubectl logs daemonset/node-agent -n kube-system --tail=200

------------------------------------------------------------

Command:
kubectl logs job/<job-name> -n <namespace>

Explanation:
Shows logs from a Kubernetes Job.

Example:
kubectl logs job/db-migration-job -n dev-gain-core

------------------------------------------------------------

Command:
kubectl logs cronjob/<cronjob-name> -n <namespace>

Explanation:
Shows logs from the latest job created by a CronJob if supported by kubectl version.

Example:
kubectl logs cronjob/daily-internal-api-call -n igpt-dev


============================================================
56.5 LOGS USING LABEL SELECTORS
============================================================

Command:
kubectl logs -l app=<app-label> -n <namespace>

Explanation:
Shows logs from pods matching a label.

Example:
kubectl logs -l app=api -n dev-gain-core

------------------------------------------------------------

Command:
kubectl logs -l app=<app-label> -n <namespace> --all-containers=true --tail=200

Explanation:
Shows logs from all containers in pods matching a label.

Example:
kubectl logs -l app=api -n dev-gain-core --all-containers=true --tail=200

------------------------------------------------------------

Command:
kubectl get pods -n <namespace> --show-labels

Explanation:
Shows pod labels so you can identify the correct label selector.

Example:
kubectl get pods -n dev-gain-core --show-labels


============================================================
56.6 INIT CONTAINER LOGS
============================================================

Command:
kubectl get pod <pod-name> -n <namespace> -o jsonpath='{.spec.initContainers[*].name}{"\n"}'

Explanation:
Lists init container names in a pod.

Example:
kubectl get pod app-pod-xxxxx -n dev-gain-core -o jsonpath='{.spec.initContainers[*].name}{"\n"}'

------------------------------------------------------------

Command:
kubectl logs <pod-name> -n <namespace> -c <init-container-name>

Explanation:
Shows logs from an init container.

Example:
kubectl logs app-pod-xxxxx -n dev-gain-core -c init-permissions


============================================================
56.7 KUBERNETES EVENTS AS TROUBLESHOOTING LOGS
============================================================

Command:
kubectl get events -n <namespace> --sort-by=.metadata.creationTimestamp

Explanation:
Shows namespace events sorted by time. This is one of the most useful commands for scheduling, image pull, mount, and probe issues.

Example:
kubectl get events -n dev-gain-core --sort-by=.metadata.creationTimestamp

------------------------------------------------------------

Command:
kubectl get events -A --sort-by=.metadata.creationTimestamp

Explanation:
Shows cluster-wide events sorted by time.

Example:
kubectl get events -A --sort-by=.metadata.creationTimestamp

------------------------------------------------------------

Command:
kubectl get events -A | grep -i "Failed"

Explanation:
Searches cluster events for failures.

Example:
kubectl get events -A | grep -i "Failed"

------------------------------------------------------------

Command:
kubectl get events -A | egrep -i "Failed|Error|BackOff|Unhealthy|Killing|Pulled|Pulling"

Explanation:
Filters events for common pod lifecycle and error messages.

Example:
kubectl get events -A | egrep -i "Failed|Error|BackOff|Unhealthy|Killing|Pulled|Pulling"


============================================================
56.8 KUBE SYSTEM COMPONENT LOGS
============================================================

Command:
kubectl get pods -n kube-system

Explanation:
Lists Kubernetes system pods.

Example:
kubectl get pods -n kube-system

------------------------------------------------------------

Command:
kubectl logs <kube-system-pod-name> -n kube-system --tail=200

Explanation:
Shows logs from a kube-system pod.

Example:
kubectl logs coredns-xxxxx -n kube-system --tail=200

------------------------------------------------------------

Command:
kubectl logs -n kube-system -l k8s-app=kube-dns --tail=200

Explanation:
Shows CoreDNS logs using label selector.

Example:
kubectl logs -n kube-system -l k8s-app=kube-dns --tail=200

------------------------------------------------------------

Command:
kubectl logs -n kube-system -l app.kubernetes.io/name=ingress-nginx --tail=200

Explanation:
Shows ingress-nginx controller logs if ingress-nginx is installed with this label.

Example:
kubectl logs -n kube-system -l app.kubernetes.io/name=ingress-nginx --tail=200

------------------------------------------------------------

Command:
kubectl logs -n ingress-haproxy <haproxy-pod-name> --tail=200

Explanation:
Shows HAProxy ingress controller logs if HAProxy ingress is used.

Example:
kubectl logs -n ingress-haproxy haproxy-ingress-xxxxx --tail=200

------------------------------------------------------------

Command:
kubectl logs -n kube-system <azurefile-csi-pod-name> -c azurefile --tail=200

Explanation:
Shows Azure File CSI driver logs.

Example:
kubectl logs -n kube-system csi-azurefile-node-xxxxx -c azurefile --tail=200

------------------------------------------------------------

Command:
kubectl logs -n kube-system <azurefile-csi-pod-name> -c node-driver-registrar --tail=200

Explanation:
Shows CSI node driver registrar logs.

Example:
kubectl logs -n kube-system csi-azurefile-node-xxxxx -c node-driver-registrar --tail=200


============================================================
56.9 SAVE LOGS TO FILE
============================================================

Command:
kubectl logs <pod-name> -n <namespace> --all-containers=true --tail=1000 > pod-logs.txt

Explanation:
Saves pod logs to a local file.

Example:
kubectl logs api-pod-xxxxx -n dev-gain-core --all-containers=true --tail=1000 > api-pod-logs.txt

------------------------------------------------------------

Command:
kubectl describe pod <pod-name> -n <namespace> > pod-describe.txt

Explanation:
Saves pod description and events to a local file.

Example:
kubectl describe pod api-pod-xxxxx -n dev-gain-core > api-pod-describe.txt

Security Note:
Review files before sharing because logs may contain sensitive data.


============================================================
57. NODE, KUBELET, CONTAINERD, AND CONTAINER RUNTIME LOGS
============================================================

Purpose:
Use these commands when pod logs and events are not enough. These commands help troubleshoot node level, kubelet, containerd, and image pull issues.

Important:
In managed Kubernetes such as AKS, direct node SSH may be restricted. Use kubectl debug node if permitted.

============================================================
57.1 DEBUG NODE USING KUBECTL
============================================================

Command:
kubectl debug node/<node-name> -it --image=mcr.microsoft.com/cbl-mariner/busybox:2.0

Explanation:
Starts a temporary debug container on a node. Useful for checking node files, runtime, DNS, and network.

Example:
kubectl debug node/aks-nodepool-xxxxx -it --image=mcr.microsoft.com/cbl-mariner/busybox:2.0

------------------------------------------------------------

Command:
chroot /host

Explanation:
After entering a node debug session, this changes root into the host filesystem.

Example:
chroot /host


============================================================
57.2 KUBELET LOGS ON NODE
============================================================

Command:
journalctl -u kubelet -n 200 --no-pager

Explanation:
Shows the last 200 kubelet log lines from the node.

Example:
journalctl -u kubelet -n 200 --no-pager

------------------------------------------------------------

Command:
journalctl -u kubelet -f

Explanation:
Follows live kubelet logs.

Example:
journalctl -u kubelet -f

------------------------------------------------------------

Command:
journalctl -u kubelet --since "1 hour ago" --no-pager

Explanation:
Shows kubelet logs from the last hour.

Example:
journalctl -u kubelet --since "1 hour ago" --no-pager


============================================================
57.3 CONTAINERD LOGS ON NODE
============================================================

Command:
journalctl -u containerd -n 200 --no-pager

Explanation:
Shows the last 200 containerd log lines.

Example:
journalctl -u containerd -n 200 --no-pager

------------------------------------------------------------

Command:
journalctl -u containerd -f

Explanation:
Follows live containerd logs.

Example:
journalctl -u containerd -f

------------------------------------------------------------

Command:
journalctl -u containerd --since "1 hour ago" --no-pager

Explanation:
Shows containerd logs from the last hour.

Example:
journalctl -u containerd --since "1 hour ago" --no-pager


============================================================
57.4 DOCKER DAEMON LOGS IF DOCKER RUNTIME IS USED
============================================================

Command:
journalctl -u docker -n 200 --no-pager

Explanation:
Shows Docker daemon logs if Docker is used as container runtime.

Example:
journalctl -u docker -n 200 --no-pager

------------------------------------------------------------

Command:
journalctl -u docker -f

Explanation:
Follows Docker daemon logs.

Example:
journalctl -u docker -f


============================================================
57.5 CRICTL COMMANDS ON NODE
============================================================

Command:
crictl ps

Explanation:
Lists running containers using CRI runtime.

Example:
crictl ps

------------------------------------------------------------

Command:
crictl ps -a

Explanation:
Lists all containers, including exited containers.

Example:
crictl ps -a

------------------------------------------------------------

Command:
crictl images

Explanation:
Lists container images available on the node.

Example:
crictl images

------------------------------------------------------------

Command:
crictl logs <container-id>

Explanation:
Shows logs for a container by container ID.

Example:
crictl logs <container-id>

------------------------------------------------------------

Command:
crictl inspect <container-id>

Explanation:
Shows detailed information for a container.

Example:
crictl inspect <container-id>

------------------------------------------------------------

Command:
crictl pull <image-name>:<tag>

Explanation:
Tests image pull directly from the node container runtime.

Example:
crictl pull <registry-url>/<repository>:<tag>


============================================================
58. CONTAINER REGISTRY LOGS AND TROUBLESHOOTING COMMANDS
============================================================

Purpose:
This section contains commands to troubleshoot image pull, image push, authentication, tag, manifest, registry connectivity, ACR, ECR, and Docker registry issues.

============================================================
58.1 CHECK IMAGE CONFIGURED IN DEPLOYMENT
============================================================

Command:
kubectl get deployment <deployment-name> -n <namespace> -o jsonpath='{range .spec.template.spec.containers[*]}{.name}{" -> "}{.image}{"\n"}{end}'

Explanation:
Shows container names and image names configured in a deployment.

Example:
kubectl get deployment api-deployment -n dev-gain-core -o jsonpath='{range .spec.template.spec.containers[*]}{.name}{" -> "}{.image}{"\n"}{end}'

------------------------------------------------------------

Command:
kubectl describe pod <pod-name> -n <namespace> | grep -i "Image"

Explanation:
Shows image details from pod description.

Example:
kubectl describe pod api-pod-xxxxx -n dev-gain-core | grep -i "Image"


============================================================
58.2 CHECK IMAGE PULL EVENTS
============================================================

Command:
kubectl describe pod <pod-name> -n <namespace>

Explanation:
Shows image pull events such as Pulling, Pulled, Failed, BackOff, Unauthorized, or manifest unknown.

Example:
kubectl describe pod api-pod-xxxxx -n dev-gain-core

------------------------------------------------------------

Command:
kubectl get events -n <namespace> --sort-by=.metadata.creationTimestamp | egrep -i "pull|image|backoff|unauthorized|denied|manifest"

Explanation:
Filters events related to image pull and registry issues.

Example:
kubectl get events -n dev-gain-core --sort-by=.metadata.creationTimestamp | egrep -i "pull|image|backoff|unauthorized|denied|manifest"


============================================================
58.3 CHECK IMAGE PULL SECRET
============================================================

Command:
kubectl get secret -n <namespace>

Explanation:
Lists secrets in the namespace. Look for image pull secrets.

Example:
kubectl get secret -n dev-gain-core

------------------------------------------------------------

Command:
kubectl describe secret <image-pull-secret-name> -n <namespace>

Explanation:
Shows metadata of the image pull secret without printing credentials.

Example:
kubectl describe secret acr-secret -n dev-gain-core

------------------------------------------------------------

Command:
kubectl get pod <pod-name> -n <namespace> -o jsonpath='{.spec.imagePullSecrets}{"\n"}'

Explanation:
Shows imagePullSecrets configured on a pod.

Example:
kubectl get pod api-pod-xxxxx -n dev-gain-core -o jsonpath='{.spec.imagePullSecrets}{"\n"}'

------------------------------------------------------------

Command:
kubectl get sa <serviceaccount-name> -n <namespace> -o jsonpath='{.imagePullSecrets}{"\n"}'

Explanation:
Shows imagePullSecrets configured on a service account.

Example:
kubectl get sa default -n dev-gain-core -o jsonpath='{.imagePullSecrets}{"\n"}'


============================================================
58.4 CREATE IMAGE PULL SECRET
============================================================

Command:
kubectl create secret docker-registry <secret-name> \
  --docker-server=<registry-url> \
  --docker-username=<username> \
  --docker-password=<password> \
  --docker-email=<email> \
  -n <namespace>

Explanation:
Creates a Docker registry pull secret for Kubernetes.

Example:
kubectl create secret docker-registry acr-secret \
  --docker-server=<registry-url> \
  --docker-username=<username> \
  --docker-password=<password> \
  --docker-email=<email> \
  -n dev-gain-core

Security Note:
Do not store real registry passwords in documents or shell history.

------------------------------------------------------------

Command:
kubectl patch serviceaccount default \
  -p '{"imagePullSecrets":[{"name":"<secret-name>"}]}' \
  -n <namespace>

Explanation:
Attaches an image pull secret to the default service account in a namespace.

Example:
kubectl patch serviceaccount default \
  -p '{"imagePullSecrets":[{"name":"acr-secret"}]}' \
  -n dev-gain-core


============================================================
58.5 TEST REGISTRY CONNECTIVITY FROM POD
============================================================

Command:
kubectl run registry-test --rm -it --image=curlimages/curl -n <namespace> -- sh

Explanation:
Starts a temporary curl pod for registry connectivity testing.

Example:
kubectl run registry-test --rm -it --image=curlimages/curl -n dev-gain-core -- sh

Inside pod commands:
nslookup <registry-hostname>
curl -I https://<registry-hostname>
curl -vk https://<registry-hostname>/v2/

Explanation:
These commands test DNS and HTTPS connectivity to the registry.


============================================================
58.6 DOCKER LOGIN AND PULL TEST
============================================================

Command:
docker login <registry-url>

Explanation:
Logs in to a container registry from local machine or build agent.

Example:
docker login <registry-url>

------------------------------------------------------------

Command:
docker pull <registry-url>/<repository>:<tag>

Explanation:
Tests whether the image can be pulled manually.

Example:
docker pull <registry-url>/<repository>:<tag>

------------------------------------------------------------

Command:
docker manifest inspect <registry-url>/<repository>:<tag>

Explanation:
Checks whether the image manifest and tag exist in the registry.

Example:
docker manifest inspect <registry-url>/<repository>:<tag>


============================================================
59. AZURE CONTAINER REGISTRY ACR COMMANDS
============================================================

Purpose:
This section contains Azure Container Registry commands for login, repository listing, tag checks, AKS integration, and troubleshooting.

============================================================
59.1 CHECK AZURE LOGIN
============================================================

Command:
az account show

Explanation:
Shows the current Azure subscription and logged-in account.

Example:
az account show

------------------------------------------------------------

Command:
az account set --subscription <subscription-id-or-name>

Explanation:
Sets the active Azure subscription.

Example:
az account set --subscription <subscription-id>


============================================================
59.2 ACR LOGIN AND CHECK
============================================================

Command:
az acr login --name <acr-name>

Explanation:
Logs Docker into Azure Container Registry.

Example:
az acr login --name myacr

------------------------------------------------------------

Command:
az acr show --name <acr-name> --query loginServer -o tsv

Explanation:
Shows the ACR login server.

Example:
az acr show --name myacr --query loginServer -o tsv

------------------------------------------------------------

Command:
az acr repository list --name <acr-name> -o table

Explanation:
Lists repositories in ACR.

Example:
az acr repository list --name myacr -o table

------------------------------------------------------------

Command:
az acr repository show-tags --name <acr-name> --repository <repository-name> -o table

Explanation:
Lists tags for a repository in ACR.

Example:
az acr repository show-tags --name myacr --repository api-service -o table

------------------------------------------------------------

Command:
az acr repository show-manifests --name <acr-name> --repository <repository-name> -o table

Explanation:
Shows image manifests for a repository.

Example:
az acr repository show-manifests --name myacr --repository api-service -o table


============================================================
59.3 AKS AND ACR ATTACH CHECKS
============================================================

Command:
az aks check-acr --name <aks-cluster-name> --resource-group <aks-resource-group> --acr <acr-name>.azurecr.io

Explanation:
Checks whether AKS can access ACR.

Example:
az aks check-acr --name myaks --resource-group my-rg --acr myacr.azurecr.io

------------------------------------------------------------

Command:
az aks update --name <aks-cluster-name> --resource-group <aks-resource-group> --attach-acr <acr-name>

Explanation:
Attaches ACR to AKS by granting pull permissions to the AKS identity.

Example:
az aks update --name myaks --resource-group my-rg --attach-acr myacr

Important:
Run only if approved and authorized.

------------------------------------------------------------

Command:
az role assignment list --assignee <aks-managed-identity-client-id> --scope <acr-resource-id> -o table

Explanation:
Checks role assignments for AKS identity on ACR.

Example:
az role assignment list --assignee <client-id> --scope <acr-resource-id> -o table

Expected role:
AcrPull


============================================================
59.4 ACR COMMON ERRORS AND FIXES
============================================================

Error:
ImagePullBackOff with unauthorized

Meaning:
AKS cannot authenticate to ACR.

Fix:
- Confirm AKS is attached to ACR.
- Confirm imagePullSecret exists if not using managed identity.
- Confirm AcrPull role exists.

Commands:
az aks check-acr --name <aks-cluster-name> --resource-group <resource-group> --acr <acr-name>.azurecr.io
kubectl describe pod <pod-name> -n <namespace>
kubectl get secret -n <namespace>
kubectl get sa <serviceaccount-name> -n <namespace> -o yaml

------------------------------------------------------------

Error:
manifest unknown

Meaning:
Image repository exists but the requested tag does not exist.

Fix:
Check image tags.

Command:
az acr repository show-tags --name <acr-name> --repository <repository-name> -o table

------------------------------------------------------------

Error:
repository not found

Meaning:
Repository name is wrong or image was pushed to another registry.

Fix:
List repositories.

Command:
az acr repository list --name <acr-name> -o table


============================================================
60. AWS ECR REGISTRY COMMANDS
============================================================

Purpose:
This section contains AWS Elastic Container Registry commands for login, repository checks, image checks, push, pull, and troubleshooting.

============================================================
60.1 ECR LOGIN
============================================================

Command:
aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <account-id>.dkr.ecr.<region>.amazonaws.com

Explanation:
Logs Docker into AWS ECR using the active AWS identity.

Example:
aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin <account-id>.dkr.ecr.eu-west-1.amazonaws.com


============================================================
60.2 ECR REPOSITORY CHECKS
============================================================

Command:
aws ecr describe-repositories --region <region>

Explanation:
Lists ECR repositories in a region.

Example:
aws ecr describe-repositories --region eu-west-1

------------------------------------------------------------

Command:
aws ecr describe-repositories --repository-names <repository-name> --region <region>

Explanation:
Checks whether a specific ECR repository exists.

Example:
aws ecr describe-repositories --repository-names search_server --region eu-west-1

------------------------------------------------------------

Command:
aws ecr list-images --repository-name <repository-name> --region <region>

Explanation:
Lists image IDs and tags in an ECR repository.

Example:
aws ecr list-images --repository-name search_server --region eu-west-1

------------------------------------------------------------

Command:
aws ecr describe-images --repository-name <repository-name> --region <region>

Explanation:
Shows image details such as tags, digest, size, and push time.

Example:
aws ecr describe-images --repository-name search_server --region eu-west-1

------------------------------------------------------------

Command:
aws ecr describe-images --repository-name <repository-name> --image-ids imageTag=<tag> --region <region>

Explanation:
Checks whether a specific image tag exists.

Example:
aws ecr describe-images --repository-name search_server --image-ids imageTag=latest --region eu-west-1


============================================================
60.3 ECR PUSH AND PULL
============================================================

Command:
docker build -t <repository-name>:<tag> -f Dockerfile .

Explanation:
Builds image locally.

Example:
docker build -t search_server:latest -f Dockerfile .

------------------------------------------------------------

Command:
docker tag <repository-name>:<tag> <account-id>.dkr.ecr.<region>.amazonaws.com/<repository-name>:<tag>

Explanation:
Tags image for ECR.

Example:
docker tag search_server:latest <account-id>.dkr.ecr.eu-west-1.amazonaws.com/search_server:latest

------------------------------------------------------------

Command:
docker push <account-id>.dkr.ecr.<region>.amazonaws.com/<repository-name>:<tag>

Explanation:
Pushes image to ECR.

Example:
docker push <account-id>.dkr.ecr.eu-west-1.amazonaws.com/search_server:latest

------------------------------------------------------------

Command:
docker pull <account-id>.dkr.ecr.<region>.amazonaws.com/<repository-name>:<tag>

Explanation:
Pulls image from ECR.

Example:
docker pull <account-id>.dkr.ecr.eu-west-1.amazonaws.com/search_server:latest


============================================================
60.4 ECR CLOUDTRAIL LOOKUP
============================================================

Command:
aws cloudtrail lookup-events --lookup-attributes AttributeKey=EventName,AttributeValue=GetAuthorizationToken --max-results 10

Explanation:
Looks up recent ECR authorization token events in CloudTrail.

Example:
aws cloudtrail lookup-events --lookup-attributes AttributeKey=EventName,AttributeValue=GetAuthorizationToken --max-results 10

------------------------------------------------------------

Command:
aws cloudtrail lookup-events --lookup-attributes AttributeKey=EventName,AttributeValue=PutImage --max-results 10

Explanation:
Looks up recent ECR image push events in CloudTrail.

Example:
aws cloudtrail lookup-events --lookup-attributes AttributeKey=EventName,AttributeValue=PutImage --max-results 10

------------------------------------------------------------

Command:
aws cloudtrail lookup-events --lookup-attributes AttributeKey=EventName,AttributeValue=BatchGetImage --max-results 10

Explanation:
Looks up recent ECR image pull events in CloudTrail.

Example:
aws cloudtrail lookup-events --lookup-attributes AttributeKey=EventName,AttributeValue=BatchGetImage --max-results 10


============================================================
60.5 ECR COMMON ERRORS AND FIXES
============================================================

Error:
no basic auth credentials

Meaning:
Docker is not logged in to ECR.

Fix:
Run ECR login again.

Command:
aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <account-id>.dkr.ecr.<region>.amazonaws.com

------------------------------------------------------------

Error:
repository does not exist or may require authorization

Meaning:
Repository name, account ID, region, or permission may be wrong.

Fix commands:
aws sts get-caller-identity
aws ecr describe-repositories --region <region>
aws ecr describe-repositories --repository-names <repository-name> --region <region>

------------------------------------------------------------

Error:
denied: User is not authorized to perform ecr:PutImage

Meaning:
Current AWS identity lacks ECR push permission.

Fix:
Ask AWS administrator to grant required ECR push permissions.

Common required actions:
ecr:GetAuthorizationToken
ecr:BatchCheckLayerAvailability
ecr:InitiateLayerUpload
ecr:UploadLayerPart
ecr:CompleteLayerUpload
ecr:PutImage
ecr:DescribeRepositories
ecr:DescribeImages

------------------------------------------------------------

Error:
manifest unknown

Meaning:
The requested image tag does not exist.

Fix:
Check available tags.

Command:
aws ecr list-images --repository-name <repository-name> --region <region>

------------------------------------------------------------

Error:
ExpiredToken

Meaning:
AWS temporary credentials expired.

Fix:
Refresh credentials or login again.

Commands:
aws sts get-caller-identity
aws sso login --profile <profile-name>


============================================================
61. COMMON KUBERNETES POD ERRORS AND FIXES
============================================================

Purpose:
This section explains common Kubernetes pod states, how to check them, and common fixes.

============================================================
61.1 IMAGEPULLBACKOFF OR ERRIMAGEPULL
============================================================

Symptoms:
Pod status shows ImagePullBackOff or ErrImagePull.

Check commands:
kubectl describe pod <pod-name> -n <namespace>
kubectl get events -n <namespace> --sort-by=.metadata.creationTimestamp
kubectl get pod <pod-name> -n <namespace> -o jsonpath='{.spec.imagePullSecrets}{"\n"}'
kubectl get secret -n <namespace>
docker pull <registry-url>/<repository>:<tag>

Common causes:
- Wrong image name
- Wrong image tag
- Registry authentication failure
- imagePullSecret missing
- ACR AcrPull permission missing
- ECR permission missing
- Registry network or DNS issue

Fix:
1. Confirm image exists in registry.
2. Confirm tag exists.
3. Confirm imagePullSecret or managed identity permission.
4. Restart deployment after fixing.

Commands:
kubectl rollout restart deployment/<deployment-name> -n <namespace>
kubectl rollout status deployment/<deployment-name> -n <namespace>


============================================================
61.2 CRASHLOOPBACKOFF
============================================================

Symptoms:
Pod starts and then repeatedly crashes.

Check commands:
kubectl logs <pod-name> -n <namespace> --previous
kubectl logs <pod-name> -n <namespace> --tail=200
kubectl describe pod <pod-name> -n <namespace>
kubectl get events -n <namespace> --sort-by=.metadata.creationTimestamp

Common causes:
- Application startup failure
- Missing environment variable
- Missing secret or configmap
- Wrong command or args
- Database connection failure
- Permission issue
- Liveness probe too strict

Fix:
1. Check previous logs.
2. Validate required env variables.
3. Validate secret and configmap exist.
4. Check application dependencies.
5. Adjust liveness or startup probe if application needs more startup time.


============================================================
61.3 CREATECONTAINERCONFIGERROR
============================================================

Symptoms:
Pod cannot create container configuration.

Check commands:
kubectl describe pod <pod-name> -n <namespace>
kubectl get secret -n <namespace>
kubectl get cm -n <namespace>
kubectl get events -n <namespace> --sort-by=.metadata.creationTimestamp

Common causes:
- Referenced secret does not exist
- Referenced ConfigMap does not exist
- Invalid environment variable reference
- Invalid volume reference

Fix:
1. Create missing Secret or ConfigMap.
2. Correct deployment YAML.
3. Apply corrected manifest.

Commands:
kubectl apply -f <deployment-file>.yml -n <namespace>
kubectl rollout restart deployment/<deployment-name> -n <namespace>


============================================================
61.4 CREATECONTAINERERROR OR RUNCONTAINERERROR
============================================================

Symptoms:
Container cannot be created or started.

Check commands:
kubectl describe pod <pod-name> -n <namespace>
kubectl get events -n <namespace> --sort-by=.metadata.creationTimestamp
kubectl logs <pod-name> -n <namespace> --previous

Common causes:
- Invalid command or entrypoint
- Permission denied
- Missing mounted file
- Read only filesystem issue
- Volume mount issue

Fix:
1. Check container command and args.
2. Check file permissions.
3. Check mounted volumes.
4. Validate image locally if possible.


============================================================
61.5 POD PENDING
============================================================

Symptoms:
Pod remains in Pending state.

Check commands:
kubectl describe pod <pod-name> -n <namespace>
kubectl get events -n <namespace> --sort-by=.metadata.creationTimestamp
kubectl get nodes
kubectl describe nodes
kubectl get pvc -n <namespace>
kubectl describe pvc <pvc-name> -n <namespace>

Common causes:
- Not enough CPU or memory
- PVC not bound
- Node selector mismatch
- Taints and tolerations issue
- Resource quota exceeded
- Pod affinity or anti-affinity issue

Fix:
1. Reduce resource request or add capacity.
2. Fix PVC binding.
3. Check node selector and tolerations.
4. Check namespace quota.


============================================================
61.6 CONTAINERCREATING STUCK
============================================================

Symptoms:
Pod stays in ContainerCreating.

Check commands:
kubectl describe pod <pod-name> -n <namespace>
kubectl get events -n <namespace> --sort-by=.metadata.creationTimestamp
kubectl get pvc -n <namespace>
kubectl describe pvc <pvc-name> -n <namespace>

Common causes:
- Volume mount issue
- CSI driver issue
- Image pull delay
- CNI networking issue
- Secret mount issue

Fix:
1. Check pod events.
2. Check CSI driver logs.
3. Check PVC and PV status.
4. Check image pull events.


============================================================
61.7 OOMKILLED
============================================================

Symptoms:
Pod restarts and last state shows OOMKilled.

Check commands:
kubectl describe pod <pod-name> -n <namespace>
kubectl logs <pod-name> -n <namespace> --previous
kubectl top pod <pod-name> -n <namespace>
kubectl exec -it <pod-name> -n <namespace> -- free -h

Common causes:
- Container exceeded memory limit
- Memory leak
- Large workload
- Too many workers
- Limit too low

Fix:
1. Review memory usage.
2. Increase memory limit if justified.
3. Tune application memory usage.
4. Reduce concurrency or worker count.


============================================================
61.8 READINESS PROBE FAILED
============================================================

Symptoms:
Pod is running but not receiving service traffic.

Check commands:
kubectl describe pod <pod-name> -n <namespace>
kubectl logs <pod-name> -n <namespace>
kubectl exec -it <pod-name> -n <namespace> -- curl -v http://localhost:<port>/<health-path>

Common causes:
- Wrong readiness path
- Wrong port
- App not ready
- Dependency unavailable
- Initial delay too short

Fix:
1. Correct readiness probe path and port.
2. Increase initialDelaySeconds if startup is slow.
3. Fix application dependency issue.


============================================================
61.9 LIVENESS PROBE FAILED
============================================================

Symptoms:
Pod keeps restarting.

Check commands:
kubectl describe pod <pod-name> -n <namespace>
kubectl logs <pod-name> -n <namespace> --previous
kubectl get events -n <namespace> --sort-by=.metadata.creationTimestamp

Common causes:
- Wrong liveness path
- Wrong port
- App startup takes too long
- App becomes unhealthy
- Probe timeout too low

Fix:
1. Add startupProbe for slow startup apps.
2. Increase failureThreshold or timeoutSeconds if needed.
3. Fix application health endpoint.


============================================================
61.10 SERVICE HAS NO ENDPOINTS
============================================================

Symptoms:
Service exists but traffic does not reach pods.

Check commands:
kubectl describe svc <service-name> -n <namespace>
kubectl get endpoints <service-name> -n <namespace> -o wide
kubectl get endpointslice -n <namespace> -l kubernetes.io/service-name=<service-name> -o wide
kubectl get pods -n <namespace> --show-labels

Common causes:
- Service selector does not match pod labels
- Pods are not ready
- Wrong targetPort
- Pods are in another namespace

Fix:
1. Match service selector with pod labels.
2. Fix readiness probe.
3. Correct targetPort.


============================================================
61.11 INGRESS 404 OR 503
============================================================

Symptoms:
Ingress URL returns 404 or 503.

Check commands:
kubectl describe ingress <ingress-name> -n <namespace>
kubectl get svc -n <namespace>
kubectl get endpoints <service-name> -n <namespace> -o wide
kubectl logs <ingress-controller-pod> -n <ingress-namespace> --tail=200
nslookup <hostname>
curl -vk https://<hostname>

Common causes:
- DNS points to wrong ingress
- Ingress host mismatch
- Service has no endpoints
- Wrong service port
- TLS secret issue
- Ingress controller issue

Fix:
1. Confirm DNS CNAME or A record.
2. Confirm ingress host and path.
3. Confirm service endpoints.
4. Confirm TLS secret.


============================================================
61.12 PVC MOUNT OR VOLUME ATTACH ERROR
============================================================

Symptoms:
Pod fails due to mount or volume attach error.

Check commands:
kubectl describe pod <pod-name> -n <namespace>
kubectl get pvc -n <namespace>
kubectl describe pvc <pvc-name> -n <namespace>
kubectl get pv
kubectl describe pv <pv-name>
kubectl get events -n <namespace> --sort-by=.metadata.creationTimestamp
kubectl get pods -n kube-system | grep -i csi

Common causes:
- PVC not bound
- Volume already attached to another node
- CSI driver issue
- Storage account key issue
- Permission issue
- Azure File or Azure Disk issue

Fix:
1. Check PVC and PV status.
2. Check CSI driver logs.
3. Restart affected pod after storage issue is fixed.
4. Escalate to platform or storage team if volume attachment is stuck.


============================================================
61.13 DNS RESOLUTION FAILURE
============================================================

Symptoms:
App cannot resolve service name or external hostname.

Check commands:
kubectl exec -it <pod-name> -n <namespace> -- nslookup <hostname>
kubectl exec -it <pod-name> -n <namespace> -- cat /etc/resolv.conf
kubectl get svc kube-dns -n kube-system
kubectl logs -n kube-system -l k8s-app=kube-dns --tail=200

Common causes:
- Wrong service name
- Wrong namespace
- CoreDNS issue
- Network policy issue
- Custom DNS issue

Fix:
1. Use full service DNS name.
2. Check CoreDNS pods and logs.
3. Check NetworkPolicy.
4. Validate /etc/resolv.conf.


============================================================
61.14 NETWORK CONNECTION REFUSED OR TIMEOUT
============================================================

Symptoms:
Pod cannot connect to another service or external endpoint.

Check commands:
kubectl exec -it <pod-name> -n <namespace> -- sh
nslookup <hostname>
nc -zv <hostname> <port>
curl -v <url>
env | grep -i proxy
kubectl get netpol -n <namespace>

Common causes:
- Target service down
- Wrong port
- Firewall issue
- NetworkPolicy blocking
- Proxy missing or incorrect
- Private endpoint or DNS issue

Fix:
1. Confirm DNS resolution.
2. Confirm port is reachable.
3. Check service endpoints.
4. Check proxy and no_proxy values.
5. Check NetworkPolicy.


============================================================
62. CONTAINER REGISTRY ERROR QUICK REFERENCE
============================================================

Error:
unauthorized: authentication required

Meaning:
Registry authentication failed.

Fix:
- Recreate imagePullSecret.
- Check service account imagePullSecrets.
- Check ACR AcrPull or ECR permissions.
- Confirm registry login works manually.

Commands:
kubectl describe pod <pod-name> -n <namespace>
kubectl get secret -n <namespace>
kubectl get sa <serviceaccount-name> -n <namespace> -o yaml

------------------------------------------------------------

Error:
denied: requested access to the resource is denied

Meaning:
Credentials are valid but do not have access to the repository.

Fix:
- Check repository permission.
- Check IAM or Azure role assignment.
- Confirm correct registry, account, and repository.

------------------------------------------------------------

Error:
manifest unknown

Meaning:
The image tag does not exist.

Fix:
- Check available tags.
- Push the correct tag.
- Update deployment image tag.

Commands:
docker manifest inspect <registry-url>/<repository>:<tag>
az acr repository show-tags --name <acr-name> --repository <repository-name> -o table
aws ecr list-images --repository-name <repository-name> --region <region>

------------------------------------------------------------

Error:
repository not found

Meaning:
Repository name is wrong or does not exist.

Fix:
- List repositories.
- Confirm registry URL.
- Confirm repository name.

Commands:
az acr repository list --name <acr-name> -o table
aws ecr describe-repositories --region <region>

------------------------------------------------------------

Error:
x509: certificate signed by unknown authority

Meaning:
Container runtime does not trust the registry certificate.

Fix:
- Use a trusted certificate.
- Install corporate root CA if required.
- Check registry TLS chain.
- Avoid disabling TLS verification except in approved test environments.

Commands:
openssl s_client -connect <registry-hostname>:443 -servername <registry-hostname> </dev/null 2>/dev/null | openssl x509 -noout -issuer -subject -dates

------------------------------------------------------------

Error:
TLS handshake timeout

Meaning:
Network, firewall, proxy, or registry issue.

Fix:
- Check DNS.
- Check proxy.
- Check firewall.
- Test registry from pod and node.

Commands:
nslookup <registry-hostname>
curl -vk https://<registry-hostname>/v2/
kubectl run registry-test --rm -it --image=curlimages/curl -n <namespace> -- sh

------------------------------------------------------------

Error:
toomanyrequests or rate limit exceeded

Meaning:
Registry pull rate limit reached.

Fix:
- Authenticate to registry.
- Use private registry mirror.
- Reduce repeated pulls.
- Use imagePullPolicy IfNotPresent where appropriate.

------------------------------------------------------------

Error:
no basic auth credentials

Meaning:
Docker client is not logged into registry.

Fix:
docker login <registry-url>

For ECR:
aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <account-id>.dkr.ecr.<region>.amazonaws.com

For ACR:
az acr login --name <acr-name>


============================================================
63. SAFE END TO END IMAGEPULLBACKOFF TROUBLESHOOTING FLOW
============================================================

Step 1: Check pod status.

Command:
kubectl get pods -n <namespace> -o wide

Step 2: Describe failing pod.

Command:
kubectl describe pod <pod-name> -n <namespace>

Step 3: Check image pull events.

Command:
kubectl get events -n <namespace> --sort-by=.metadata.creationTimestamp | egrep -i "pull|image|backoff|unauthorized|denied|manifest"

Step 4: Check image configured in deployment.

Command:
kubectl get deployment <deployment-name> -n <namespace> -o jsonpath='{range .spec.template.spec.containers[*]}{.name}{" -> "}{.image}{"\n"}{end}'

Step 5: Check imagePullSecrets.

Command:
kubectl get pod <pod-name> -n <namespace> -o jsonpath='{.spec.imagePullSecrets}{"\n"}'

Step 6: Check service account imagePullSecrets.

Command:
kubectl get sa <serviceaccount-name> -n <namespace> -o jsonpath='{.imagePullSecrets}{"\n"}'

Step 7: Confirm image tag exists.

For Docker:
docker manifest inspect <registry-url>/<repository>:<tag>

For ACR:
az acr repository show-tags --name <acr-name> --repository <repository-name> -o table

For ECR:
aws ecr describe-images --repository-name <repository-name> --image-ids imageTag=<tag> --region <region>

Step 8: Test registry login.

For ACR:
az acr login --name <acr-name>

For ECR:
aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <account-id>.dkr.ecr.<region>.amazonaws.com

Step 9: Test manual pull.

Command:
docker pull <registry-url>/<repository>:<tag>

Step 10: Fix deployment image if wrong.

Command:
kubectl set image deployment/<deployment-name> <container-name>=<registry-url>/<repository>:<tag> -n <namespace>

Step 11: Restart deployment.

Command:
kubectl rollout restart deployment/<deployment-name> -n <namespace>

Step 12: Watch rollout.

Command:
kubectl rollout status deployment/<deployment-name> -n <namespace>


============================================================
64. SAFE END TO END CRASHLOOPBACKOFF TROUBLESHOOTING FLOW
============================================================

Step 1: Check pod status.

Command:
kubectl get pods -n <namespace> -o wide

Step 2: Describe pod.

Command:
kubectl describe pod <pod-name> -n <namespace>

Step 3: Check current logs.

Command:
kubectl logs <pod-name> -n <namespace> --tail=200

Step 4: Check previous crashed logs.

Command:
kubectl logs <pod-name> -n <namespace> --previous --tail=200

Step 5: Check all containers.

Command:
kubectl logs <pod-name> -n <namespace> --all-containers=true --tail=200

Step 6: Check events.

Command:
kubectl get events -n <namespace> --sort-by=.metadata.creationTimestamp

Step 7: Check environment variable names without printing secret values.

Command:
kubectl describe pod <pod-name> -n <namespace>

Step 8: Check ConfigMaps and Secrets exist.

Command:
kubectl get cm -n <namespace>
kubectl get secret -n <namespace>

Step 9: Exec into pod if it stays running long enough.

Command:
kubectl exec -it <pod-name> -n <namespace> -- sh

Step 10: Check resource usage.

Command:
kubectl top pod <pod-name> -n <namespace>

Step 11: Restart after fix.

Command:
kubectl rollout restart deployment/<deployment-name> -n <namespace>


============================================================
65. FINAL NOTES FOR LOG SHARING
============================================================

Before sharing logs externally or in tickets, remove:
- Passwords
- Tokens
- API keys
- Storage account keys
- Session tokens
- Private keys
- Kubeconfig content
- Database connection strings
- Authorization headers
- Cookie headers
- Personal data

Safe log collection commands:
kubectl describe pod <pod-name> -n <namespace> > pod-describe.txt
kubectl logs <pod-name> -n <namespace> --all-containers=true --tail=1000 > pod-logs.txt
kubectl get events -n <namespace> --sort-by=.metadata.creationTimestamp > events.txt

Reminder:
Review pod-logs.txt, pod-describe.txt, and events.txt before sharing.

END UPDATED K8S CONTAINER REGISTRY LOGS AND ERROR TROUBLESHOOTING SECTION

START UPDATED TERRAFORM COMMANDS SECTION

============================================================
66. TERRAFORM COMMANDS
============================================================

Purpose:
This section contains commonly used Terraform commands for initialization, validation, formatting, planning, applying, destroying, state management, workspace management, imports, outputs, variables, modules, providers, troubleshooting, and CI CD usage.

Important Security Note:
Do not store real secrets, passwords, API keys, private keys, cloud credentials, storage account keys, database passwords, or tokens in Terraform files, tfvars files, state files, Word documents, Notepad files, Git repositories, or chat messages.

Terraform state files can contain sensitive values. Store Terraform state only in approved secure remote backends such as Azure Storage with access controls, AWS S3 with encryption and locking, Terraform Cloud, or another approved backend.

============================================================
66.1 CHECK TERRAFORM VERSION
============================================================

Command:
terraform version

Explanation:
Shows the installed Terraform version and provider information.

Example:
terraform version

------------------------------------------------------------

Command:
terraform -version

Explanation:
Alternative command to check Terraform version.

Example:
terraform -version


============================================================
66.2 TERRAFORM HELP COMMANDS
============================================================

Command:
terraform help

Explanation:
Shows Terraform command help.

Example:
terraform help

------------------------------------------------------------

Command:
terraform <command> -help

Explanation:
Shows help for a specific Terraform command.

Example:
terraform plan -help


============================================================
66.3 TERRAFORM INIT
============================================================

Command:
terraform init

Explanation:
Initializes the Terraform working directory. It downloads providers, configures backend, and prepares modules.

Example:
terraform init

------------------------------------------------------------

Command:
terraform init -upgrade

Explanation:
Initializes Terraform and upgrades provider plugins and modules to newer allowed versions.

Example:
terraform init -upgrade

------------------------------------------------------------

Command:
terraform init -reconfigure

Explanation:
Reconfigures Terraform backend settings. Useful when backend configuration changes.

Example:
terraform init -reconfigure

------------------------------------------------------------

Command:
terraform init -backend-config=<backend-config-file>

Explanation:
Initializes Terraform using a backend configuration file.

Example:
terraform init -backend-config=backend-dev.hcl

------------------------------------------------------------

Command:
terraform init -migrate-state

Explanation:
Migrates existing Terraform state to a newly configured backend.

Example:
terraform init -migrate-state

Important:
Use this carefully and confirm backend settings before approving migration.


============================================================
66.4 TERRAFORM FORMAT
============================================================

Command:
terraform fmt

Explanation:
Formats Terraform files in the current directory.

Example:
terraform fmt

------------------------------------------------------------

Command:
terraform fmt -recursive

Explanation:
Formats Terraform files recursively in current directory and subdirectories.

Example:
terraform fmt -recursive

------------------------------------------------------------

Command:
terraform fmt -check

Explanation:
Checks whether Terraform files are properly formatted without changing files.

Example:
terraform fmt -check

------------------------------------------------------------

Command:
terraform fmt -check -recursive

Explanation:
Checks formatting recursively. Useful in CI CD pipelines.

Example:
terraform fmt -check -recursive


============================================================
66.5 TERRAFORM VALIDATE
============================================================

Command:
terraform validate

Explanation:
Validates Terraform configuration syntax and internal consistency.

Example:
terraform validate

------------------------------------------------------------

Command:
terraform validate -json

Explanation:
Validates Terraform configuration and outputs result in JSON format.

Example:
terraform validate -json


============================================================
66.6 TERRAFORM PLAN
============================================================

Command:
terraform plan

Explanation:
Creates an execution plan showing what Terraform will create, update, or destroy.

Example:
terraform plan

------------------------------------------------------------

Command:
terraform plan -out=tfplan

Explanation:
Creates and saves a Terraform plan file named tfplan.

Example:
terraform plan -out=tfplan

------------------------------------------------------------

Command:
terraform plan -var-file=<variables-file>

Explanation:
Runs Terraform plan using a variable file.

Example:
terraform plan -var-file=dev.tfvars

------------------------------------------------------------

Command:
terraform plan -var="key=value"

Explanation:
Passes a single variable directly from command line.

Example:
terraform plan -var="environment=dev"

------------------------------------------------------------

Command:
terraform plan -target=<resource-address>

Explanation:
Plans changes only for a specific resource.

Example:
terraform plan -target=azurerm_resource_group.main

Warning:
Use target only for exceptional troubleshooting. Regular usage can create state drift or partial deployments.

------------------------------------------------------------

Command:
terraform plan -destroy

Explanation:
Shows what Terraform would destroy without actually destroying it.

Example:
terraform plan -destroy


============================================================
66.7 TERRAFORM APPLY
============================================================

Command:
terraform apply

Explanation:
Applies Terraform changes after showing a plan and asking for confirmation.

Example:
terraform apply

------------------------------------------------------------

Command:
terraform apply tfplan

Explanation:
Applies a previously saved Terraform plan file.

Example:
terraform apply tfplan

------------------------------------------------------------

Command:
terraform apply -var-file=<variables-file>

Explanation:
Applies Terraform using a variable file.

Example:
terraform apply -var-file=dev.tfvars

------------------------------------------------------------

Command:
terraform apply -auto-approve

Explanation:
Applies Terraform without interactive approval.

Example:
terraform apply -auto-approve

Warning:
Use auto-approve carefully, preferably only in approved CI CD pipelines with review controls.

------------------------------------------------------------

Command:
terraform apply -target=<resource-address>

Explanation:
Applies changes only to a specific resource.

Example:
terraform apply -target=azurerm_resource_group.main

Warning:
Use target only for emergency or special cases.


============================================================
66.8 TERRAFORM DESTROY
============================================================

Command:
terraform destroy

Explanation:
Destroys all resources managed by the current Terraform state.

Example:
terraform destroy

Warning:
This can delete infrastructure. Use only after approval.

------------------------------------------------------------

Command:
terraform destroy -var-file=<variables-file>

Explanation:
Destroys infrastructure using a variable file.

Example:
terraform destroy -var-file=dev.tfvars

------------------------------------------------------------

Command:
terraform destroy -target=<resource-address>

Explanation:
Destroys only a specific Terraform-managed resource.

Example:
terraform destroy -target=azurerm_resource_group.test

Warning:
Targeted destroy can cause dependency issues. Use carefully.

------------------------------------------------------------

Command:
terraform destroy -auto-approve

Explanation:
Destroys infrastructure without confirmation.

Example:
terraform destroy -auto-approve

Warning:
Avoid using this manually unless fully approved.


============================================================
66.9 TERRAFORM SHOW
============================================================

Command:
terraform show

Explanation:
Shows current Terraform state or a saved plan in human-readable format.

Example:
terraform show

------------------------------------------------------------

Command:
terraform show tfplan

Explanation:
Shows details of a saved Terraform plan file.

Example:
terraform show tfplan

------------------------------------------------------------

Command:
terraform show -json tfplan

Explanation:
Shows a saved Terraform plan in JSON format.

Example:
terraform show -json tfplan


============================================================
66.10 TERRAFORM OUTPUT
============================================================

Command:
terraform output

Explanation:
Shows all Terraform output values.

Example:
terraform output

------------------------------------------------------------

Command:
terraform output <output-name>

Explanation:
Shows a specific output value.

Example:
terraform output resource_group_name

------------------------------------------------------------

Command:
terraform output -json

Explanation:
Shows Terraform outputs in JSON format.

Example:
terraform output -json

Security Note:
Outputs may contain sensitive values. Do not share output without review.


============================================================
66.11 TERRAFORM VARIABLES
============================================================

Command:
terraform plan -var="environment=dev"

Explanation:
Passes one variable to Terraform plan.

Example:
terraform plan -var="environment=dev"

------------------------------------------------------------

Command:
terraform apply -var="environment=dev"

Explanation:
Passes one variable to Terraform apply.

Example:
terraform apply -var="environment=dev"

------------------------------------------------------------

Command:
terraform plan -var-file=dev.tfvars

Explanation:
Uses a tfvars file for variable values during plan.

Example:
terraform plan -var-file=dev.tfvars

------------------------------------------------------------

Command:
terraform apply -var-file=dev.tfvars

Explanation:
Uses a tfvars file for variable values during apply.

Example:
terraform apply -var-file=dev.tfvars

------------------------------------------------------------

Command:
export TF_VAR_<variable_name>="<value>"

Explanation:
Sets a Terraform variable using environment variable.

Example:
export TF_VAR_environment="dev"

Security Note:
Do not export secrets directly in shared terminals or logs.


============================================================
66.12 TERRAFORM WORKSPACES
============================================================

Command:
terraform workspace list

Explanation:
Lists Terraform workspaces.

Example:
terraform workspace list

------------------------------------------------------------

Command:
terraform workspace show

Explanation:
Shows the current active workspace.

Example:
terraform workspace show

------------------------------------------------------------

Command:
terraform workspace new <workspace-name>

Explanation:
Creates a new Terraform workspace.

Example:
terraform workspace new dev

------------------------------------------------------------

Command:
terraform workspace select <workspace-name>

Explanation:
Switches to an existing Terraform workspace.

Example:
terraform workspace select dev

------------------------------------------------------------

Command:
terraform workspace delete <workspace-name>

Explanation:
Deletes a Terraform workspace.

Example:
terraform workspace delete test

Warning:
Do not delete a workspace unless you understand where its state is stored and confirm resources are no longer required.


============================================================
66.13 TERRAFORM STATE COMMANDS
============================================================

Purpose:
Terraform state commands are used to inspect, move, remove, or edit resources in state.

Important:
State commands can break Terraform tracking if used incorrectly. Take a backup before making state changes.

------------------------------------------------------------

Command:
terraform state list

Explanation:
Lists all resources tracked in Terraform state.

Example:
terraform state list

------------------------------------------------------------

Command:
terraform state show <resource-address>

Explanation:
Shows details of a specific resource in state.

Example:
terraform state show azurerm_resource_group.main

------------------------------------------------------------

Command:
terraform state pull

Explanation:
Downloads and prints the current state file.

Example:
terraform state pull

Security Note:
Terraform state can contain secrets. Do not share output.

------------------------------------------------------------

Command:
terraform state pull > terraform-state-backup.json

Explanation:
Creates a local backup of the current Terraform state.

Example:
terraform state pull > terraform-state-backup.json

Security Note:
Store state backups securely.

------------------------------------------------------------

Command:
terraform state mv <source-address> <destination-address>

Explanation:
Moves a resource address within Terraform state. Useful after refactoring resource names or modules.

Example:
terraform state mv azurerm_resource_group.old azurerm_resource_group.new

------------------------------------------------------------

Command:
terraform state rm <resource-address>

Explanation:
Removes a resource from Terraform state without deleting the actual cloud resource.

Example:
terraform state rm azurerm_resource_group.main

Warning:
Terraform will stop managing this resource after removal.

------------------------------------------------------------

Command:
terraform refresh

Explanation:
Updates Terraform state to match real infrastructure.

Example:
terraform refresh

Note:
In newer Terraform workflows, prefer terraform plan because it refreshes state by default.


============================================================
66.14 TERRAFORM IMPORT
============================================================

Command:
terraform import <resource-address> <cloud-resource-id>

Explanation:
Imports an existing cloud resource into Terraform state.

Example:
terraform import azurerm_resource_group.main /subscriptions/<subscription-id>/resourceGroups/<resource-group-name>

------------------------------------------------------------

Command:
terraform plan

Explanation:
Run plan after import to compare Terraform configuration with imported resource state.

Example:
terraform plan

Important:
After import, ensure Terraform code matches the actual resource configuration.


============================================================
66.15 TERRAFORM MODULE COMMANDS
============================================================

Command:
terraform get

Explanation:
Downloads and updates modules used by Terraform configuration.

Example:
terraform get

------------------------------------------------------------

Command:
terraform get -update

Explanation:
Updates Terraform modules.

Example:
terraform get -update

------------------------------------------------------------

Command:
terraform init -upgrade

Explanation:
Updates modules and providers according to version constraints.

Example:
terraform init -upgrade


============================================================
66.16 TERRAFORM PROVIDER COMMANDS
============================================================

Command:
terraform providers

Explanation:
Lists providers required by the configuration and state.

Example:
terraform providers

------------------------------------------------------------

Command:
terraform providers lock

Explanation:
Creates or updates provider lock file.

Example:
terraform providers lock

------------------------------------------------------------

Command:
terraform providers mirror <directory>

Explanation:
Downloads provider plugins into a local mirror directory.

Example:
terraform providers mirror ./providers-mirror


============================================================
66.17 TERRAFORM GRAPH
============================================================

Command:
terraform graph

Explanation:
Creates a dependency graph in DOT format.

Example:
terraform graph

------------------------------------------------------------

Command:
terraform graph > graph.dot

Explanation:
Saves Terraform dependency graph to a file.

Example:
terraform graph > graph.dot

------------------------------------------------------------

Command:
terraform graph | dot -Tpng > graph.png

Explanation:
Creates a PNG image of Terraform resource dependencies. Requires graphviz.

Example:
terraform graph | dot -Tpng > graph.png


============================================================
66.18 TERRAFORM CONSOLE
============================================================

Command:
terraform console

Explanation:
Opens an interactive console to test expressions, variables, functions, and outputs.

Example:
terraform console

Example expression inside console:
var.environment

Exit:
exit


============================================================
66.19 TERRAFORM LOCK FILE
============================================================

File:
.terraform.lock.hcl

Explanation:
This file locks provider versions to ensure consistent Terraform runs across machines and pipelines.

Best Practice:
Commit .terraform.lock.hcl to Git unless your organization has a different standard.

Command:
git add .terraform.lock.hcl

Example:
git add .terraform.lock.hcl


============================================================
66.20 COMMON TERRAFORM FILES
============================================================

File:
main.tf

Explanation:
Main Terraform resource definitions.

------------------------------------------------------------

File:
variables.tf

Explanation:
Input variable definitions.

------------------------------------------------------------

File:
outputs.tf

Explanation:
Terraform output definitions.

------------------------------------------------------------

File:
providers.tf

Explanation:
Provider configuration and version constraints.

------------------------------------------------------------

File:
backend.tf

Explanation:
Remote backend configuration.

------------------------------------------------------------

File:
terraform.tfvars

Explanation:
Variable values file.

Security Note:
Do not store secrets in terraform.tfvars unless file is securely managed and excluded from Git.

------------------------------------------------------------

File:
dev.tfvars, qa.tfvars, prod.tfvars

Explanation:
Environment-specific variable files.

------------------------------------------------------------

File:
.terraform/

Explanation:
Local Terraform working directory created by terraform init.

Best Practice:
Do not commit .terraform directory to Git.

------------------------------------------------------------

File:
terraform.tfstate

Explanation:
Terraform state file.

Security Note:
Do not commit state files to Git.


============================================================
66.21 TERRAFORM GITIGNORE
============================================================

Recommended .gitignore entries:

.terraform/
*.tfstate
*.tfstate.*
crash.log
crash.*.log
*.tfvars
*.tfvars.json
override.tf
override.tf.json
*_override.tf
*_override.tf.json
.terraform.lock.hcl

Note:
Some teams commit .terraform.lock.hcl. Confirm your team standard before ignoring it.

Security Note:
tfvars files may contain sensitive environment-specific values. Do not commit them unless approved and sanitized.


============================================================
66.22 TERRAFORM BACKEND EXAMPLES
============================================================

Purpose:
Backends store Terraform state remotely and securely.

Security Note:
Remote state should use encryption, locking, access control, and audit logging.

------------------------------------------------------------
Azure Storage backend example:
------------------------------------------------------------

terraform {
  backend "azurerm" {
    resource_group_name  = "<resource-group-name>"
    storage_account_name = "<storage-account-name>"
    container_name       = "<container-name>"
    key                  = "<state-file-name>.tfstate"
  }
}

Explanation:
Stores Terraform state in Azure Storage.

------------------------------------------------------------
AWS S3 backend example:
------------------------------------------------------------

terraform {
  backend "s3" {
    bucket         = "<s3-bucket-name>"
    key            = "<path>/<state-file-name>.tfstate"
    region         = "<aws-region>"
    dynamodb_table = "<lock-table-name>"
    encrypt        = true
  }
}

Explanation:
Stores Terraform state in AWS S3 and uses DynamoDB for state locking.


============================================================
66.23 TERRAFORM PLAN AND APPLY SAFE WORKFLOW
============================================================

Step 1:
Check Terraform version.

Command:
terraform version

Step 2:
Format code.

Command:
terraform fmt -recursive

Step 3:
Initialize Terraform.

Command:
terraform init

Step 4:
Validate Terraform code.

Command:
terraform validate

Step 5:
Create a plan.

Command:
terraform plan -var-file=dev.tfvars -out=tfplan

Step 6:
Review the plan carefully.

Command:
terraform show tfplan

Step 7:
Apply the saved plan.

Command:
terraform apply tfplan

Step 8:
Check outputs.

Command:
terraform output

Step 9:
Check state resources.

Command:
terraform state list


============================================================
67. TERRAFORM TROUBLESHOOTING
============================================================

Purpose:
This section contains common Terraform errors, checks, and fixes.

============================================================
67.1 ERROR: TERRAFORM INIT FAILED
============================================================

Common causes:
- Backend configuration issue
- Provider download issue
- Network or proxy issue
- Invalid credentials
- Remote backend permission issue

Check commands:
terraform init
terraform init -reconfigure
terraform init -upgrade
env | grep -i proxy

Fix:
1. Confirm backend configuration.
2. Confirm cloud credentials.
3. Confirm network and proxy.
4. Run init again with reconfigure if backend changed.

Command:
terraform init -reconfigure


============================================================
67.2 ERROR: BACKEND CONFIGURATION CHANGED
============================================================

Error example:
Backend configuration changed

Meaning:
Terraform detected a change in backend configuration.

Fix command:
terraform init -reconfigure

If state must be migrated:
terraform init -migrate-state

Warning:
Use migrate-state only after confirming source and destination backend.


============================================================
67.3 ERROR: PROVIDER VERSION CONFLICT
============================================================

Common causes:
- Provider version constraint mismatch
- Old lock file
- Module requires different provider version

Check commands:
terraform providers
terraform init -upgrade

Fix:
1. Review required provider versions.
2. Update version constraints.
3. Run init upgrade.

Command:
terraform init -upgrade


============================================================
67.4 ERROR: INVALID PROVIDER CREDENTIALS
============================================================

Common causes:
- Expired cloud login
- Missing environment variables
- Wrong AWS profile
- Wrong Azure subscription
- Insufficient permissions

AWS check commands:
aws sts get-caller-identity
aws configure list
echo $AWS_PROFILE

Azure check commands:
az account show
az account list -o table

Fix:
1. Refresh cloud login.
2. Select correct subscription or profile.
3. Re-run terraform plan.


============================================================
67.5 ERROR: RESOURCE ALREADY EXISTS
============================================================

Meaning:
The resource already exists in cloud but is not tracked in Terraform state.

Fix options:
1. Import the resource into Terraform state.
2. Rename the resource if duplicate was accidental.
3. Delete manually only if approved.

Import command:
terraform import <resource-address> <cloud-resource-id>

Example:
terraform import azurerm_resource_group.main /subscriptions/<subscription-id>/resourceGroups/<resource-group-name>

After import:
terraform plan


============================================================
67.6 ERROR: STATE LOCKED
============================================================

Error example:
Error acquiring the state lock

Meaning:
Another Terraform process is using the state, or a previous run left a stale lock.

Check:
Confirm no active Terraform pipeline or user is running.

Command:
terraform force-unlock <lock-id>

Explanation:
Force unlocks Terraform state.

Example:
terraform force-unlock <lock-id>

Warning:
Use force-unlock only after confirming no active Terraform run is using the state.


============================================================
67.7 ERROR: DRIFT DETECTED
============================================================

Meaning:
Cloud resource configuration changed outside Terraform.

Check command:
terraform plan

Fix:
1. Review drift.
2. Decide whether to update Terraform code or allow Terraform to revert cloud changes.
3. Apply only after approval.

Command:
terraform plan
terraform apply


============================================================
67.8 ERROR: UNDECLARED VARIABLE
============================================================

Meaning:
A variable is used but not declared in variables.tf.

Check:
Search for variable reference.

Command:
grep -R "var.<variable-name>" .

Fix:
Add variable definition in variables.tf.

Example:
variable "environment" {
  type        = string
  description = "Environment name"
}


============================================================
67.9 ERROR: UNSUPPORTED ATTRIBUTE
============================================================

Meaning:
Terraform code references an attribute that does not exist.

Check:
terraform validate
terraform plan

Fix:
1. Check provider documentation.
2. Check resource output attributes.
3. Correct the attribute name.


============================================================
67.10 ERROR: CYCLE DEPENDENCY
============================================================

Meaning:
Terraform detected circular dependency between resources.

Check command:
terraform graph

Fix:
1. Review resource dependencies.
2. Remove unnecessary depends_on.
3. Break circular references.
4. Use data sources carefully.


============================================================
67.11 ERROR: ACCESS DENIED
============================================================

Meaning:
Cloud identity does not have required permission.

Check AWS:
aws sts get-caller-identity

Check Azure:
az account show

Fix:
1. Confirm active identity.
2. Confirm subscription or account.
3. Request required permissions.
4. Re-run terraform plan.


============================================================
67.12 ERROR: TIMEOUT CREATING RESOURCE
============================================================

Common causes:
- Cloud provider delay
- Network issue
- Quota issue
- Dependency not ready

Fix:
1. Check cloud portal or CLI.
2. Check quota.
3. Check dependent resources.
4. Re-run terraform plan.
5. Use custom timeout only if supported by resource.

Example:
resource "azurerm_resource_group" "main" {
  name     = "rg-example"
  location = "westeurope"
}


============================================================
67.13 ERROR: MODULE NOT FOUND
============================================================

Common causes:
- Wrong module source path
- Git module URL issue
- Missing access to private repo
- Module not downloaded

Fix commands:
terraform get
terraform init
terraform init -upgrade


============================================================
67.14 ERROR: VARIABLE VALUE IS SENSITIVE
============================================================

Meaning:
Terraform hides sensitive variable values in output.

Best Practice:
Mark sensitive variables as sensitive.

Example:
variable "db_password" {
  type        = string
  sensitive   = true
  description = "Database password"
}

Security Note:
Sensitive values may still be stored in Terraform state.


============================================================
68. TERRAFORM WITH AZURE
============================================================

Purpose:
This section contains useful Terraform-related Azure commands.

============================================================
68.1 AZURE LOGIN CHECKS
============================================================

Command:
az login

Explanation:
Logs in to Azure interactively.

Example:
az login

------------------------------------------------------------

Command:
az account show

Explanation:
Shows active Azure subscription.

Example:
az account show

------------------------------------------------------------

Command:
az account list -o table

Explanation:
Lists available Azure subscriptions.

Example:
az account list -o table

------------------------------------------------------------

Command:
az account set --subscription <subscription-id-or-name>

Explanation:
Sets active Azure subscription.

Example:
az account set --subscription <subscription-id>


============================================================
68.2 AZURE SERVICE PRINCIPAL ENV VARIABLES FOR TERRAFORM
============================================================

Command:
export ARM_CLIENT_ID="<client-id>"
export ARM_CLIENT_SECRET="<client-secret>"
export ARM_SUBSCRIPTION_ID="<subscription-id>"
export ARM_TENANT_ID="<tenant-id>"

Explanation:
Sets Azure service principal credentials for Terraform.

Security Note:
Do not store real values in scripts, documents, or Git. Use CI CD secret variables or workload identity where possible.


============================================================
68.3 CLEAR AZURE TERRAFORM ENV VARIABLES
============================================================

Command:
unset ARM_CLIENT_ID
unset ARM_CLIENT_SECRET
unset ARM_SUBSCRIPTION_ID
unset ARM_TENANT_ID

Explanation:
Clears Azure Terraform authentication environment variables.

Example:
unset ARM_CLIENT_ID
unset ARM_CLIENT_SECRET
unset ARM_SUBSCRIPTION_ID
unset ARM_TENANT_ID


============================================================
68.4 AZURE BACKEND STORAGE CHECKS
============================================================

Command:
az storage account show --name <storage-account-name> --resource-group <resource-group-name>

Explanation:
Checks Azure Storage account used for Terraform backend.

Example:
az storage account show --name <storage-account-name> --resource-group <resource-group-name>

------------------------------------------------------------

Command:
az storage container show --name <container-name> --account-name <storage-account-name>

Explanation:
Checks Azure Storage container used for Terraform state.

Example:
az storage container show --name tfstate --account-name <storage-account-name>


============================================================
69. TERRAFORM WITH AWS
============================================================

Purpose:
This section contains useful Terraform-related AWS commands.

============================================================
69.1 AWS IDENTITY CHECKS
============================================================

Command:
aws sts get-caller-identity

Explanation:
Shows current AWS identity used by Terraform if AWS provider uses current shell credentials.

Example:
aws sts get-caller-identity

------------------------------------------------------------

Command:
aws configure list

Explanation:
Shows AWS credential source and region.

Example:
aws configure list

------------------------------------------------------------

Command:
aws configure list-profiles

Explanation:
Lists configured AWS profiles.

Example:
aws configure list-profiles

------------------------------------------------------------

Command:
export AWS_PROFILE=<profile-name>

Explanation:
Sets AWS profile for Terraform.

Example:
export AWS_PROFILE=dev-profile

------------------------------------------------------------

Command:
export AWS_REGION=<region>

Explanation:
Sets AWS region for Terraform.

Example:
export AWS_REGION=eu-west-1


============================================================
69.2 AWS S3 BACKEND CHECKS
============================================================

Command:
aws s3 ls s3://<terraform-state-bucket>

Explanation:
Checks access to S3 backend bucket.

Example:
aws s3 ls s3://my-terraform-state-bucket

------------------------------------------------------------

Command:
aws dynamodb describe-table --table-name <lock-table-name> --region <region>

Explanation:
Checks DynamoDB lock table used by Terraform backend.

Example:
aws dynamodb describe-table --table-name terraform-locks --region eu-west-1


============================================================
69.3 CLEAR AWS TERRAFORM ENV VARIABLES
============================================================

Command:
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset AWS_SESSION_TOKEN
unset AWS_PROFILE
unset AWS_REGION

Explanation:
Clears AWS-related Terraform authentication environment variables.

Example:
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset AWS_SESSION_TOKEN
unset AWS_PROFILE
unset AWS_REGION


============================================================
70. TERRAFORM CI CD PIPELINE COMMANDS
============================================================

Purpose:
These commands are commonly used in Jenkins, Azure DevOps, GitHub Actions, or GitLab CI pipelines.

============================================================
70.1 CI VALIDATION COMMANDS
============================================================

Command:
terraform fmt -check -recursive

Explanation:
Checks formatting without changing files.

Example:
terraform fmt -check -recursive

------------------------------------------------------------

Command:
terraform init -input=false

Explanation:
Initializes Terraform without interactive input.

Example:
terraform init -input=false

------------------------------------------------------------

Command:
terraform validate

Explanation:
Validates Terraform configuration.

Example:
terraform validate

------------------------------------------------------------

Command:
terraform plan -input=false -out=tfplan

Explanation:
Creates a saved Terraform plan without interactive input.

Example:
terraform plan -input=false -out=tfplan

------------------------------------------------------------

Command:
terraform apply -input=false tfplan

Explanation:
Applies saved plan without interactive input.

Example:
terraform apply -input=false tfplan

------------------------------------------------------------

Command:
terraform apply -input=false -auto-approve

Explanation:
Applies Terraform without prompting.

Example:
terraform apply -input=false -auto-approve

Warning:
Use only in approved pipelines with controls.


============================================================
70.2 CI PIPELINE SAFE ORDER
============================================================

Step 1:
terraform fmt -check -recursive

Step 2:
terraform init -input=false

Step 3:
terraform validate

Step 4:
terraform plan -input=false -out=tfplan

Step 5:
Manual approval if production.

Step 6:
terraform apply -input=false tfplan


============================================================
71. TERRAFORM DEBUG LOGS
============================================================

Purpose:
Terraform debug logs help troubleshoot provider, backend, and API issues.

Security Note:
Terraform debug logs may contain sensitive data. Review and redact before sharing.

============================================================
71.1 ENABLE TERRAFORM DEBUG LOGS
============================================================

Command:
export TF_LOG=DEBUG

Explanation:
Enables Terraform debug logging.

Example:
export TF_LOG=DEBUG

------------------------------------------------------------

Command:
export TF_LOG=TRACE

Explanation:
Enables very detailed Terraform trace logs.

Example:
export TF_LOG=TRACE

Warning:
TRACE logs can expose sensitive information. Use only temporarily.

------------------------------------------------------------

Command:
export TF_LOG_PATH=terraform-debug.log

Explanation:
Writes Terraform logs to a file.

Example:
export TF_LOG_PATH=terraform-debug.log

------------------------------------------------------------

Command:
terraform plan

Explanation:
Run Terraform command after enabling logs.

Example:
terraform plan

------------------------------------------------------------

Command:
unset TF_LOG
unset TF_LOG_PATH

Explanation:
Disables Terraform debug logging.

Example:
unset TF_LOG
unset TF_LOG_PATH


============================================================
72. TERRAFORM COMMON DAILY COMMAND CHEAT SHEET
============================================================

Check version:
terraform version

Format files:
terraform fmt -recursive

Initialize:
terraform init

Initialize with upgrade:
terraform init -upgrade

Validate:
terraform validate

Plan:
terraform plan

Plan with variable file:
terraform plan -var-file=dev.tfvars

Save plan:
terraform plan -out=tfplan

Show saved plan:
terraform show tfplan

Apply saved plan:
terraform apply tfplan

Apply with variable file:
terraform apply -var-file=dev.tfvars

Destroy:
terraform destroy

List state:
terraform state list

Show state resource:
terraform state show <resource-address>

List workspaces:
terraform workspace list

Show current workspace:
terraform workspace show

Select workspace:
terraform workspace select <workspace-name>

Create workspace:
terraform workspace new <workspace-name>

Import resource:
terraform import <resource-address> <cloud-resource-id>

Show outputs:
terraform output

END UPDATED TERRAFORM COMMANDS SECTION

START UPDATED AZURE INFRA AZURE NETWORK AND JENKINS COMMANDS SECTION

============================================================
73. AZURE CLI BASIC COMMANDS
============================================================

Purpose:
This section contains Azure CLI commands for login, subscription selection, resource groups, resources, AKS, ACR, Key Vault, storage, networking, private endpoints, DNS, monitoring, and troubleshooting.

Important Security Note:
Do not paste or store real client secrets, storage keys, SAS tokens, connection strings, kubeconfig contents, private keys, or passwords in documents, Git, tickets, Jenkins logs, or chat messages.

============================================================
73.1 CHECK AZURE CLI VERSION
============================================================

Command:
az version

Explanation:
Shows installed Azure CLI version and extension details.

Example:
az version

------------------------------------------------------------

Command:
az --version

Explanation:
Alternative command to check Azure CLI version.

Example:
az --version


============================================================
73.2 AZURE LOGIN AND ACCOUNT CHECKS
============================================================

Command:
az login

Explanation:
Logs in to Azure interactively using a browser.

Example:
az login

------------------------------------------------------------

Command:
az login --tenant <tenant-id>

Explanation:
Logs in to a specific Azure tenant.

Example:
az login --tenant <tenant-id>

------------------------------------------------------------

Command:
az account show

Explanation:
Shows the currently active Azure subscription and tenant.

Example:
az account show

------------------------------------------------------------

Command:
az account list -o table

Explanation:
Lists available Azure subscriptions.

Example:
az account list -o table

------------------------------------------------------------

Command:
az account set --subscription <subscription-id-or-name>

Explanation:
Sets the active Azure subscription.

Example:
az account set --subscription <subscription-id>

------------------------------------------------------------

Command:
az account clear

Explanation:
Clears locally stored Azure account information.

Example:
az account clear


============================================================
73.3 AZURE RESOURCE GROUP COMMANDS
============================================================

Command:
az group list -o table

Explanation:
Lists resource groups in the active subscription.

Example:
az group list -o table

------------------------------------------------------------

Command:
az group show --name <resource-group-name>

Explanation:
Shows details of a resource group.

Example:
az group show --name rg-dev-app

------------------------------------------------------------

Command:
az group create --name <resource-group-name> --location <location>

Explanation:
Creates a new Azure resource group.

Example:
az group create --name rg-dev-app --location westeurope

------------------------------------------------------------

Command:
az group delete --name <resource-group-name>

Explanation:
Deletes a resource group and all resources inside it.

Example:
az group delete --name rg-test-app

Warning:
Deleting a resource group deletes all contained resources. Use only after approval.


============================================================
73.4 AZURE RESOURCE LISTING COMMANDS
============================================================

Command:
az resource list -o table

Explanation:
Lists Azure resources in the active subscription.

Example:
az resource list -o table

------------------------------------------------------------

Command:
az resource list --resource-group <resource-group-name> -o table

Explanation:
Lists resources inside a specific resource group.

Example:
az resource list --resource-group rg-dev-app -o table

------------------------------------------------------------

Command:
az resource show --ids <resource-id>

Explanation:
Shows details of a resource using its resource ID.

Example:
az resource show --ids <resource-id>

------------------------------------------------------------

Command:
az resource delete --ids <resource-id>

Explanation:
Deletes a resource by resource ID.

Example:
az resource delete --ids <resource-id>

Warning:
Use delete only after approval.


============================================================
73.5 AZURE REGIONS AND LOCATIONS
============================================================

Command:
az account list-locations -o table

Explanation:
Lists Azure regions available for the subscription.

Example:
az account list-locations -o table

------------------------------------------------------------

Command:
az account list-locations --query "[].{Name:name,DisplayName:displayName}" -o table

Explanation:
Shows Azure region names and display names.

Example:
az account list-locations --query "[].{Name:name,DisplayName:displayName}" -o table


============================================================
74. AZURE AKS COMMANDS
============================================================

Purpose:
This section contains AKS cluster commands for listing clusters, getting credentials, checking nodes, node pools, upgrades, identities, and troubleshooting.

============================================================
74.1 LIST AKS CLUSTERS
============================================================

Command:
az aks list -o table

Explanation:
Lists AKS clusters in the active subscription.

Example:
az aks list -o table

------------------------------------------------------------

Command:
az aks list --resource-group <resource-group-name> -o table

Explanation:
Lists AKS clusters in a specific resource group.

Example:
az aks list --resource-group rg-aks-dev -o table


============================================================
74.2 SHOW AKS CLUSTER DETAILS
============================================================

Command:
az aks show --name <aks-cluster-name> --resource-group <resource-group-name>

Explanation:
Shows detailed AKS cluster configuration.

Example:
az aks show --name aks-dev-01 --resource-group rg-aks-dev

------------------------------------------------------------

Command:
az aks show --name <aks-cluster-name> --resource-group <resource-group-name> --query identity

Explanation:
Shows AKS managed identity details.

Example:
az aks show --name aks-dev-01 --resource-group rg-aks-dev --query identity

------------------------------------------------------------

Command:
az aks show --name <aks-cluster-name> --resource-group <resource-group-name> --query networkProfile

Explanation:
Shows AKS network configuration.

Example:
az aks show --name aks-dev-01 --resource-group rg-aks-dev --query networkProfile


============================================================
74.3 GET AKS CREDENTIALS
============================================================

Command:
az aks get-credentials --name <aks-cluster-name> --resource-group <resource-group-name>

Explanation:
Downloads AKS kubeconfig credentials and merges them into local kubeconfig.

Example:
az aks get-credentials --name aks-dev-01 --resource-group rg-aks-dev

------------------------------------------------------------

Command:
az aks get-credentials --name <aks-cluster-name> --resource-group <resource-group-name> --overwrite-existing

Explanation:
Downloads AKS credentials and overwrites an existing context with the same name.

Example:
az aks get-credentials --name aks-dev-01 --resource-group rg-aks-dev --overwrite-existing

------------------------------------------------------------

Command:
kubectl config current-context

Explanation:
Confirms which Kubernetes context is active after getting AKS credentials.

Example:
kubectl config current-context


============================================================
74.4 AKS NODE POOL COMMANDS
============================================================

Command:
az aks nodepool list --cluster-name <aks-cluster-name> --resource-group <resource-group-name> -o table

Explanation:
Lists node pools in an AKS cluster.

Example:
az aks nodepool list --cluster-name aks-dev-01 --resource-group rg-aks-dev -o table

------------------------------------------------------------

Command:
az aks nodepool show --cluster-name <aks-cluster-name> --resource-group <resource-group-name> --name <nodepool-name>

Explanation:
Shows details of a specific AKS node pool.

Example:
az aks nodepool show --cluster-name aks-dev-01 --resource-group rg-aks-dev --name agentpool

------------------------------------------------------------

Command:
az aks nodepool scale --cluster-name <aks-cluster-name> --resource-group <resource-group-name> --name <nodepool-name> --node-count <count>

Explanation:
Scales an AKS node pool to a specific node count.

Example:
az aks nodepool scale --cluster-name aks-dev-01 --resource-group rg-aks-dev --name agentpool --node-count 3

Warning:
Scaling node pools can affect cost and scheduling. Use approved change process.


============================================================
74.5 AKS UPGRADE CHECKS
============================================================

Command:
az aks get-upgrades --name <aks-cluster-name> --resource-group <resource-group-name> -o table

Explanation:
Shows available Kubernetes upgrade versions for AKS.

Example:
az aks get-upgrades --name aks-dev-01 --resource-group rg-aks-dev -o table

------------------------------------------------------------

Command:
az aks upgrade --name <aks-cluster-name> --resource-group <resource-group-name> --kubernetes-version <version>

Explanation:
Upgrades AKS cluster version.

Example:
az aks upgrade --name aks-dev-01 --resource-group rg-aks-dev --kubernetes-version <version>

Warning:
Run only during approved maintenance window.


============================================================
74.6 AKS ACR INTEGRATION
============================================================

Command:
az aks check-acr --name <aks-cluster-name> --resource-group <aks-resource-group> --acr <acr-name>.azurecr.io

Explanation:
Checks whether AKS can pull images from ACR.

Example:
az aks check-acr --name aks-dev-01 --resource-group rg-aks-dev --acr myacr.azurecr.io

------------------------------------------------------------

Command:
az aks update --name <aks-cluster-name> --resource-group <aks-resource-group> --attach-acr <acr-name>

Explanation:
Grants AKS permission to pull from ACR.

Example:
az aks update --name aks-dev-01 --resource-group rg-aks-dev --attach-acr myacr

Warning:
Run only if authorized.


============================================================
75. AZURE CONTAINER REGISTRY ACR COMMANDS
============================================================

Purpose:
This section contains ACR commands for login, repository checks, tag checks, permissions, import, delete, and troubleshooting.

============================================================
75.1 ACR LOGIN
============================================================

Command:
az acr login --name <acr-name>

Explanation:
Logs Docker into Azure Container Registry.

Example:
az acr login --name myacr

------------------------------------------------------------

Command:
az acr show --name <acr-name> --query loginServer -o tsv

Explanation:
Shows ACR login server URL.

Example:
az acr show --name myacr --query loginServer -o tsv


============================================================
75.2 ACR REPOSITORY COMMANDS
============================================================

Command:
az acr repository list --name <acr-name> -o table

Explanation:
Lists repositories in ACR.

Example:
az acr repository list --name myacr -o table

------------------------------------------------------------

Command:
az acr repository show-tags --name <acr-name> --repository <repository-name> -o table

Explanation:
Lists image tags in an ACR repository.

Example:
az acr repository show-tags --name myacr --repository api-service -o table

------------------------------------------------------------

Command:
az acr repository show-manifests --name <acr-name> --repository <repository-name> -o table

Explanation:
Shows manifests for images in a repository.

Example:
az acr repository show-manifests --name myacr --repository api-service -o table

------------------------------------------------------------

Command:
az acr repository show --name <acr-name> --repository <repository-name>

Explanation:
Shows repository metadata.

Example:
az acr repository show --name myacr --repository api-service


============================================================
75.3 ACR IMAGE DELETE
============================================================

Command:
az acr repository delete --name <acr-name> --image <repository-name>:<tag>

Explanation:
Deletes a specific image tag from ACR.

Example:
az acr repository delete --name myacr --image api-service:old-tag

Warning:
Use only after approval.

------------------------------------------------------------

Command:
az acr repository delete --name <acr-name> --repository <repository-name>

Explanation:
Deletes an entire repository from ACR.

Example:
az acr repository delete --name myacr --repository api-service

Warning:
This deletes all tags under the repository.


============================================================
75.4 ACR IMPORT IMAGE
============================================================

Command:
az acr import --name <acr-name> --source <source-image> --image <target-repository>:<tag>

Explanation:
Imports an image into ACR from another registry.

Example:
az acr import --name myacr --source docker.io/library/nginx:latest --image nginx:latest


============================================================
75.5 ACR PERMISSION CHECKS
============================================================

Command:
az role assignment list --scope <acr-resource-id> -o table

Explanation:
Lists role assignments on an ACR resource.

Example:
az role assignment list --scope <acr-resource-id> -o table

------------------------------------------------------------

Command:
az role assignment list --assignee <identity-client-id-or-object-id> --scope <acr-resource-id> -o table

Explanation:
Checks ACR roles assigned to a specific identity.

Example:
az role assignment list --assignee <identity-id> --scope <acr-resource-id> -o table

Expected pull role:
AcrPull

Expected push role:
AcrPush


============================================================
76. AZURE KEY VAULT COMMANDS
============================================================

Purpose:
This section contains Key Vault commands for checking vault access, listing secrets safely, showing secret metadata, and troubleshooting.

Important Security Note:
Do not print secret values unless absolutely required and authorized.

============================================================
76.1 KEY VAULT BASIC CHECKS
============================================================

Command:
az keyvault list -o table

Explanation:
Lists Key Vaults in the subscription.

Example:
az keyvault list -o table

------------------------------------------------------------

Command:
az keyvault show --name <keyvault-name>

Explanation:
Shows Key Vault details.

Example:
az keyvault show --name kv-dev-01

------------------------------------------------------------

Command:
curl -vk https://<keyvault-name>.vault.azure.net

Explanation:
Checks network reachability to Key Vault endpoint.

Example:
curl -vk https://kv-dev-01.vault.azure.net


============================================================
76.2 KEY VAULT SECRET METADATA COMMANDS
============================================================

Command:
az keyvault secret list --vault-name <keyvault-name> -o table

Explanation:
Lists secret names and metadata without printing secret values.

Example:
az keyvault secret list --vault-name kv-dev-01 -o table

------------------------------------------------------------

Command:
az keyvault secret show --vault-name <keyvault-name> --name <secret-name> --query "attributes"

Explanation:
Shows secret attributes without printing the secret value.

Example:
az keyvault secret show --vault-name kv-dev-01 --name db-password --query "attributes"

------------------------------------------------------------

Command:
az keyvault secret show --vault-name <keyvault-name> --name <secret-name> --query "id" -o tsv

Explanation:
Shows secret ID only.

Example:
az keyvault secret show --vault-name kv-dev-01 --name db-password --query "id" -o tsv


============================================================
76.3 KEY VAULT ACCESS CHECKS
============================================================

Command:
az keyvault show --name <keyvault-name> --query properties.enableRbacAuthorization

Explanation:
Checks whether Key Vault uses Azure RBAC authorization.

Example:
az keyvault show --name kv-dev-01 --query properties.enableRbacAuthorization

------------------------------------------------------------

Command:
az role assignment list --scope <keyvault-resource-id> -o table

Explanation:
Lists RBAC role assignments on Key Vault.

Example:
az role assignment list --scope <keyvault-resource-id> -o table

------------------------------------------------------------

Command:
az keyvault show --name <keyvault-name> --query properties.networkAcls

Explanation:
Shows Key Vault firewall and network access rules.

Example:
az keyvault show --name kv-dev-01 --query properties.networkAcls


============================================================
77. AZURE STORAGE COMMANDS
============================================================

Purpose:
This section contains storage account, blob container, file share, and network rule commands.

Important Security Note:
Do not print or store storage account keys or SAS tokens in documentation.

============================================================
77.1 STORAGE ACCOUNT CHECKS
============================================================

Command:
az storage account list -o table

Explanation:
Lists storage accounts in the subscription.

Example:
az storage account list -o table

------------------------------------------------------------

Command:
az storage account show --name <storage-account-name> --resource-group <resource-group-name>

Explanation:
Shows details of a storage account.

Example:
az storage account show --name mystorageacct --resource-group rg-storage-dev

------------------------------------------------------------

Command:
az storage account show-connection-string --name <storage-account-name> --resource-group <resource-group-name>

Explanation:
Shows storage account connection string.

Example:
az storage account show-connection-string --name mystorageacct --resource-group rg-storage-dev

Security Warning:
Connection strings are sensitive. Do not share output.


============================================================
77.2 STORAGE CONTAINER COMMANDS
============================================================

Command:
az storage container list --account-name <storage-account-name> --auth-mode login -o table

Explanation:
Lists blob containers using Azure login authentication.

Example:
az storage container list --account-name mystorageacct --auth-mode login -o table

------------------------------------------------------------

Command:
az storage container show --name <container-name> --account-name <storage-account-name> --auth-mode login

Explanation:
Shows details of a blob container.

Example:
az storage container show --name tfstate --account-name mystorageacct --auth-mode login

------------------------------------------------------------

Command:
az storage blob list --container-name <container-name> --account-name <storage-account-name> --auth-mode login -o table

Explanation:
Lists blobs in a container.

Example:
az storage blob list --container-name tfstate --account-name mystorageacct --auth-mode login -o table


============================================================
77.3 AZURE FILE SHARE COMMANDS
============================================================

Command:
az storage share list --account-name <storage-account-name> --auth-mode login -o table

Explanation:
Lists Azure File shares.

Example:
az storage share list --account-name mystorageacct --auth-mode login -o table

------------------------------------------------------------

Command:
az storage share show --name <share-name> --account-name <storage-account-name> --auth-mode login

Explanation:
Shows details of an Azure File share.

Example:
az storage share show --name appfiles --account-name mystorageacct --auth-mode login


============================================================
77.4 STORAGE NETWORK RULES
============================================================

Command:
az storage account network-rule list --account-name <storage-account-name> --resource-group <resource-group-name>

Explanation:
Lists network rules for a storage account.

Example:
az storage account network-rule list --account-name mystorageacct --resource-group rg-storage-dev

------------------------------------------------------------

Command:
az storage account show --name <storage-account-name> --resource-group <resource-group-name> --query networkRuleSet

Explanation:
Shows storage account network rule set.

Example:
az storage account show --name mystorageacct --resource-group rg-storage-dev --query networkRuleSet


============================================================
78. AZURE NETWORK COMMANDS
============================================================

Purpose:
This section contains Azure networking commands for VNets, subnets, NSGs, route tables, private endpoints, private DNS zones, public IPs, load balancers, application gateways, NAT gateways, and troubleshooting.

============================================================
78.1 VNET COMMANDS
============================================================

Command:
az network vnet list -o table

Explanation:
Lists virtual networks in the active subscription.

Example:
az network vnet list -o table

------------------------------------------------------------

Command:
az network vnet list --resource-group <resource-group-name> -o table

Explanation:
Lists VNets in a specific resource group.

Example:
az network vnet list --resource-group rg-network-dev -o table

------------------------------------------------------------

Command:
az network vnet show --name <vnet-name> --resource-group <resource-group-name>

Explanation:
Shows VNet details.

Example:
az network vnet show --name vnet-dev --resource-group rg-network-dev

------------------------------------------------------------

Command:
az network vnet show --name <vnet-name> --resource-group <resource-group-name> --query addressSpace

Explanation:
Shows VNet address space.

Example:
az network vnet show --name vnet-dev --resource-group rg-network-dev --query addressSpace


============================================================
78.2 SUBNET COMMANDS
============================================================

Command:
az network vnet subnet list --vnet-name <vnet-name> --resource-group <resource-group-name> -o table

Explanation:
Lists subnets in a VNet.

Example:
az network vnet subnet list --vnet-name vnet-dev --resource-group rg-network-dev -o table

------------------------------------------------------------

Command:
az network vnet subnet show --vnet-name <vnet-name> --resource-group <resource-group-name> --name <subnet-name>

Explanation:
Shows subnet details.

Example:
az network vnet subnet show --vnet-name vnet-dev --resource-group rg-network-dev --name aks-subnet

------------------------------------------------------------

Command:
az network vnet subnet show --vnet-name <vnet-name> --resource-group <resource-group-name> --name <subnet-name> --query addressPrefix

Explanation:
Shows subnet IP range.

Example:
az network vnet subnet show --vnet-name vnet-dev --resource-group rg-network-dev --name aks-subnet --query addressPrefix


============================================================
78.3 NETWORK SECURITY GROUP NSG COMMANDS
============================================================

Command:
az network nsg list -o table

Explanation:
Lists Network Security Groups.

Example:
az network nsg list -o table

------------------------------------------------------------

Command:
az network nsg list --resource-group <resource-group-name> -o table

Explanation:
Lists NSGs in a resource group.

Example:
az network nsg list --resource-group rg-network-dev -o table

------------------------------------------------------------

Command:
az network nsg show --name <nsg-name> --resource-group <resource-group-name>

Explanation:
Shows NSG details.

Example:
az network nsg show --name nsg-aks --resource-group rg-network-dev

------------------------------------------------------------

Command:
az network nsg rule list --nsg-name <nsg-name> --resource-group <resource-group-name> -o table

Explanation:
Lists NSG rules.

Example:
az network nsg rule list --nsg-name nsg-aks --resource-group rg-network-dev -o table

------------------------------------------------------------

Command:
az network nsg rule show --nsg-name <nsg-name> --resource-group <resource-group-name> --name <rule-name>

Explanation:
Shows a specific NSG rule.

Example:
az network nsg rule show --nsg-name nsg-aks --resource-group rg-network-dev --name AllowHTTPS


============================================================
78.4 ROUTE TABLE COMMANDS
============================================================

Command:
az network route-table list -o table

Explanation:
Lists route tables.

Example:
az network route-table list -o table

------------------------------------------------------------

Command:
az network route-table list --resource-group <resource-group-name> -o table

Explanation:
Lists route tables in a resource group.

Example:
az network route-table list --resource-group rg-network-dev -o table

------------------------------------------------------------

Command:
az network route-table show --name <route-table-name> --resource-group <resource-group-name>

Explanation:
Shows route table details.

Example:
az network route-table show --name rt-aks --resource-group rg-network-dev

------------------------------------------------------------

Command:
az network route-table route list --route-table-name <route-table-name> --resource-group <resource-group-name> -o table

Explanation:
Lists routes in a route table.

Example:
az network route-table route list --route-table-name rt-aks --resource-group rg-network-dev -o table


============================================================
78.5 NETWORK INTERFACE NIC COMMANDS
============================================================

Command:
az network nic list -o table

Explanation:
Lists network interfaces.

Example:
az network nic list -o table

------------------------------------------------------------

Command:
az network nic list --resource-group <resource-group-name> -o table

Explanation:
Lists NICs in a resource group.

Example:
az network nic list --resource-group rg-app-dev -o table

------------------------------------------------------------

Command:
az network nic show --name <nic-name> --resource-group <resource-group-name>

Explanation:
Shows network interface details.

Example:
az network nic show --name nic-app-01 --resource-group rg-app-dev

------------------------------------------------------------

Command:
az network nic show-effective-nsg --name <nic-name> --resource-group <resource-group-name>

Explanation:
Shows effective NSG rules applied to a NIC.

Example:
az network nic show-effective-nsg --name nic-app-01 --resource-group rg-app-dev

------------------------------------------------------------

Command:
az network nic show-effective-route-table --name <nic-name> --resource-group <resource-group-name>

Explanation:
Shows effective routes applied to a NIC.

Example:
az network nic show-effective-route-table --name nic-app-01 --resource-group rg-app-dev


============================================================
78.6 PRIVATE ENDPOINT COMMANDS
============================================================

Command:
az network private-endpoint list -o table

Explanation:
Lists private endpoints.

Example:
az network private-endpoint list -o table

------------------------------------------------------------

Command:
az network private-endpoint list --resource-group <resource-group-name> -o table

Explanation:
Lists private endpoints in a resource group.

Example:
az network private-endpoint list --resource-group rg-network-dev -o table

------------------------------------------------------------

Command:
az network private-endpoint show --name <private-endpoint-name> --resource-group <resource-group-name>

Explanation:
Shows private endpoint details.

Example:
az network private-endpoint show --name pe-keyvault-dev --resource-group rg-network-dev

------------------------------------------------------------

Command:
az network private-endpoint-connection list --id <resource-id>

Explanation:
Lists private endpoint connections for a resource.

Example:
az network private-endpoint-connection list --id <resource-id>


============================================================
78.7 PRIVATE DNS ZONE COMMANDS
============================================================

Command:
az network private-dns zone list -o table

Explanation:
Lists private DNS zones.

Example:
az network private-dns zone list -o table

------------------------------------------------------------

Command:
az network private-dns zone show --name <private-dns-zone-name> --resource-group <resource-group-name>

Explanation:
Shows private DNS zone details.

Example:
az network private-dns zone show --name privatelink.vaultcore.azure.net --resource-group rg-dns

------------------------------------------------------------

Command:
az network private-dns record-set a list --zone-name <private-dns-zone-name> --resource-group <resource-group-name> -o table

Explanation:
Lists A records in a private DNS zone.

Example:
az network private-dns record-set a list --zone-name privatelink.vaultcore.azure.net --resource-group rg-dns -o table

------------------------------------------------------------

Command:
az network private-dns link vnet list --zone-name <private-dns-zone-name> --resource-group <resource-group-name> -o table

Explanation:
Lists VNet links for a private DNS zone.

Example:
az network private-dns link vnet list --zone-name privatelink.vaultcore.azure.net --resource-group rg-dns -o table


============================================================
78.8 PUBLIC DNS COMMANDS
============================================================

Command:
az network dns zone list -o table

Explanation:
Lists public DNS zones.

Example:
az network dns zone list -o table

------------------------------------------------------------

Command:
az network dns record-set cname list --zone-name <dns-zone-name> --resource-group <resource-group-name> -o table

Explanation:
Lists CNAME records in a public DNS zone.

Example:
az network dns record-set cname list --zone-name example.com --resource-group rg-dns -o table

------------------------------------------------------------

Command:
az network dns record-set cname set-record --zone-name <dns-zone-name> --resource-group <resource-group-name> --record-set-name <record-name> --cname <target-hostname>

Explanation:
Creates or updates a CNAME record.

Example:
az network dns record-set cname set-record --zone-name example.com --resource-group rg-dns --record-set-name dev-search-logs --cname zephyr-aksgain.example.com

Warning:
DNS changes should follow approved change process.


============================================================
78.9 PUBLIC IP COMMANDS
============================================================

Command:
az network public-ip list -o table

Explanation:
Lists public IP resources.

Example:
az network public-ip list -o table

------------------------------------------------------------

Command:
az network public-ip show --name <public-ip-name> --resource-group <resource-group-name>

Explanation:
Shows public IP details.

Example:
az network public-ip show --name pip-ingress --resource-group rg-network-dev


============================================================
78.10 LOAD BALANCER COMMANDS
============================================================

Command:
az network lb list -o table

Explanation:
Lists Azure Load Balancers.

Example:
az network lb list -o table

------------------------------------------------------------

Command:
az network lb show --name <load-balancer-name> --resource-group <resource-group-name>

Explanation:
Shows load balancer details.

Example:
az network lb show --name lb-aks --resource-group rg-network-dev

------------------------------------------------------------

Command:
az network lb rule list --lb-name <load-balancer-name> --resource-group <resource-group-name> -o table

Explanation:
Lists load balancer rules.

Example:
az network lb rule list --lb-name lb-aks --resource-group rg-network-dev -o table


============================================================
78.11 APPLICATION GATEWAY COMMANDS
============================================================

Command:
az network application-gateway list -o table

Explanation:
Lists Application Gateways.

Example:
az network application-gateway list -o table

------------------------------------------------------------

Command:
az network application-gateway show --name <appgw-name> --resource-group <resource-group-name>

Explanation:
Shows Application Gateway details.

Example:
az network application-gateway show --name appgw-dev --resource-group rg-network-dev

------------------------------------------------------------

Command:
az network application-gateway show-backend-health --name <appgw-name> --resource-group <resource-group-name>

Explanation:
Shows backend health of Application Gateway.

Example:
az network application-gateway show-backend-health --name appgw-dev --resource-group rg-network-dev


============================================================
78.12 NAT GATEWAY COMMANDS
============================================================

Command:
az network nat gateway list -o table

Explanation:
Lists NAT Gateways.

Example:
az network nat gateway list -o table

------------------------------------------------------------

Command:
az network nat gateway show --name <nat-gateway-name> --resource-group <resource-group-name>

Explanation:
Shows NAT Gateway details.

Example:
az network nat gateway show --name nat-aks --resource-group rg-network-dev


============================================================
78.13 NETWORK WATCHER COMMANDS
============================================================

Command:
az network watcher list -o table

Explanation:
Lists Network Watcher resources.

Example:
az network watcher list -o table

------------------------------------------------------------

Command:
az network watcher test-connectivity --source-resource <source-resource-id> --dest-address <destination-hostname-or-ip> --dest-port <port>

Explanation:
Tests connectivity from an Azure resource to a destination address and port.

Example:
az network watcher test-connectivity --source-resource <vm-resource-id> --dest-address example.com --dest-port 443

------------------------------------------------------------

Command:
az network watcher show-next-hop --source-resource <vm-resource-id> --dest-ip <destination-ip>

Explanation:
Shows next hop for traffic from a VM to a destination IP.

Example:
az network watcher show-next-hop --source-resource <vm-resource-id> --dest-ip 10.0.1.10

------------------------------------------------------------

Command:
az network watcher test-ip-flow --vm <vm-name> --resource-group <resource-group-name> --direction Outbound --protocol TCP --local <local-ip>:<local-port> --remote <remote-ip>:<remote-port>

Explanation:
Checks whether NSG rules allow or deny traffic.

Example:
az network watcher test-ip-flow --vm vm-dev-01 --resource-group rg-vm-dev --direction Outbound --protocol TCP --local 10.0.0.4:50000 --remote 10.0.1.10:443


============================================================
79. AZURE NETWORK TROUBLESHOOTING FLOW
============================================================

Purpose:
Use this flow when an application, pod, VM, or service cannot connect to an Azure resource.

Step 1: Check DNS resolution.

Command:
nslookup <hostname>

Step 2: Check system resolver.

Command:
getent hosts <hostname>

Step 3: Check TCP connectivity.

Command:
nc -zv <hostname> <port>

Step 4: Check HTTP or HTTPS.

Command:
curl -vk https://<hostname>

Step 5: Check VNet and subnet.

Command:
az network vnet subnet show --vnet-name <vnet-name> --resource-group <resource-group-name> --name <subnet-name>

Step 6: Check NSG rules.

Command:
az network nsg rule list --nsg-name <nsg-name> --resource-group <resource-group-name> -o table

Step 7: Check effective NSG on NIC.

Command:
az network nic show-effective-nsg --name <nic-name> --resource-group <resource-group-name>

Step 8: Check effective routes.

Command:
az network nic show-effective-route-table --name <nic-name> --resource-group <resource-group-name>

Step 9: Check private endpoint.

Command:
az network private-endpoint list --resource-group <resource-group-name> -o table

Step 10: Check private DNS record.

Command:
az network private-dns record-set a list --zone-name <private-dns-zone-name> --resource-group <resource-group-name> -o table

Step 11: Use Network Watcher connectivity test.

Command:
az network watcher test-connectivity --source-resource <source-resource-id> --dest-address <destination-hostname-or-ip> --dest-port <port>


============================================================
80. AZURE MONITORING AND LOG ANALYTICS COMMANDS
============================================================

Purpose:
This section contains Azure Monitor, Log Analytics, metrics, diagnostic settings, and activity log commands.

============================================================
80.1 ACTIVITY LOG COMMANDS
============================================================

Command:
az monitor activity-log list --max-events 20 -o table

Explanation:
Shows recent Azure Activity Log events.

Example:
az monitor activity-log list --max-events 20 -o table

------------------------------------------------------------

Command:
az monitor activity-log list --resource-group <resource-group-name> --max-events 20 -o table

Explanation:
Shows recent Activity Log events for a resource group.

Example:
az monitor activity-log list --resource-group rg-dev-app --max-events 20 -o table

------------------------------------------------------------

Command:
az monitor activity-log list --status Failed --max-events 20 -o table

Explanation:
Shows recent failed Azure Activity Log events.

Example:
az monitor activity-log list --status Failed --max-events 20 -o table


============================================================
80.2 METRICS COMMANDS
============================================================

Command:
az monitor metrics list --resource <resource-id> --metric <metric-name>

Explanation:
Shows metrics for an Azure resource.

Example:
az monitor metrics list --resource <resource-id> --metric Percentage CPU

------------------------------------------------------------

Command:
az monitor metrics list-definitions --resource <resource-id> -o table

Explanation:
Lists available metrics for an Azure resource.

Example:
az monitor metrics list-definitions --resource <resource-id> -o table


============================================================
80.3 DIAGNOSTIC SETTINGS
============================================================

Command:
az monitor diagnostic-settings list --resource <resource-id>

Explanation:
Lists diagnostic settings configured for a resource.

Example:
az monitor diagnostic-settings list --resource <resource-id>

------------------------------------------------------------

Command:
az monitor diagnostic-settings categories list --resource <resource-id>

Explanation:
Lists available diagnostic log and metric categories.

Example:
az monitor diagnostic-settings categories list --resource <resource-id>


============================================================
80.4 LOG ANALYTICS WORKSPACE COMMANDS
============================================================

Command:
az monitor log-analytics workspace list -o table

Explanation:
Lists Log Analytics workspaces.

Example:
az monitor log-analytics workspace list -o table

------------------------------------------------------------

Command:
az monitor log-analytics workspace show --resource-group <resource-group-name> --workspace-name <workspace-name>

Explanation:
Shows Log Analytics workspace details.

Example:
az monitor log-analytics workspace show --resource-group rg-monitoring --workspace-name log-dev

------------------------------------------------------------

Command:
az monitor log-analytics query --workspace <workspace-id> --analytics-query "<kql-query>"

Explanation:
Runs a Kusto query against Log Analytics.

Example:
az monitor log-analytics query --workspace <workspace-id> --analytics-query "Heartbeat | take 10"


============================================================
81. AZURE ROLE BASED ACCESS CONTROL RBAC COMMANDS
============================================================

Purpose:
This section contains Azure RBAC commands for role assignments and permission checks.

============================================================
81.1 LIST ROLE ASSIGNMENTS
============================================================

Command:
az role assignment list --assignee <user-or-identity-id> -o table

Explanation:
Lists role assignments for a user, service principal, or managed identity.

Example:
az role assignment list --assignee <identity-id> -o table

------------------------------------------------------------

Command:
az role assignment list --scope <resource-id> -o table

Explanation:
Lists role assignments for a resource scope.

Example:
az role assignment list --scope <resource-id> -o table

------------------------------------------------------------

Command:
az role definition list --name "<role-name>"

Explanation:
Shows details of a built-in or custom role.

Example:
az role definition list --name "AcrPull"


============================================================
81.2 CREATE ROLE ASSIGNMENT
============================================================

Command:
az role assignment create --assignee <identity-id> --role "<role-name>" --scope <resource-id>

Explanation:
Assigns a role to an identity at a specific scope.

Example:
az role assignment create --assignee <identity-id> --role "AcrPull" --scope <acr-resource-id>

Warning:
RBAC changes should be approved.


============================================================
81.3 DELETE ROLE ASSIGNMENT
============================================================

Command:
az role assignment delete --assignee <identity-id> --role "<role-name>" --scope <resource-id>

Explanation:
Deletes a role assignment.

Example:
az role assignment delete --assignee <identity-id> --role "AcrPull" --scope <acr-resource-id>

Warning:
Removing RBAC permissions can break workloads.


============================================================
82. JENKINS BASIC COMMANDS AND OPERATIONS
============================================================

Purpose:
This section contains Jenkins-related commands for checking agent tools, Jenkins workspace, pipelines, logs, CLI, builds, parameters, credentials safety, and troubleshooting.

Important Security Note:
Do not print Jenkins secrets, credentials, tokens, passwords, private keys, kubeconfig content, AWS keys, Azure client secrets, or API keys in console logs.
Use Jenkins Credentials Binding and mask secret values.

============================================================
82.1 JENKINS AGENT BASIC CHECKS
============================================================

Command:
whoami

Explanation:
Shows the user running the Jenkins build agent.

Example:
whoami

------------------------------------------------------------

Command:
pwd

Explanation:
Shows current Jenkins workspace directory.

Example:
pwd

------------------------------------------------------------

Command:
hostname

Explanation:
Shows Jenkins agent hostname.

Example:
hostname

------------------------------------------------------------

Command:
env | sort

Explanation:
Shows environment variables.

Example:
env | sort

Security Note:
Do not share output if it contains secrets.

------------------------------------------------------------

Command:
df -h

Explanation:
Shows disk usage on Jenkins agent.

Example:
df -h

------------------------------------------------------------

Command:
free -h

Explanation:
Shows memory usage on Linux Jenkins agent.

Example:
free -h

------------------------------------------------------------

Command:
top

Explanation:
Shows CPU and memory usage interactively.

Example:
top


============================================================
82.2 CHECK TOOL AVAILABILITY ON JENKINS AGENT
============================================================

Command:
git --version

Explanation:
Checks Git version.

Example:
git --version

------------------------------------------------------------

Command:
docker --version

Explanation:
Checks Docker version.

Example:
docker --version

------------------------------------------------------------

Command:
kubectl version --client

Explanation:
Checks kubectl client version.

Example:
kubectl version --client

------------------------------------------------------------

Command:
helm version

Explanation:
Checks Helm version.

Example:
helm version

------------------------------------------------------------

Command:
terraform version

Explanation:
Checks Terraform version.

Example:
terraform version

------------------------------------------------------------

Command:
aws --version

Explanation:
Checks AWS CLI version.

Example:
aws --version

------------------------------------------------------------

Command:
az version

Explanation:
Checks Azure CLI version.

Example:
az version

------------------------------------------------------------

Command:
python3 --version

Explanation:
Checks Python version.

Example:
python3 --version

------------------------------------------------------------

Command:
node --version

Explanation:
Checks Node.js version.

Example:
node --version

------------------------------------------------------------

Command:
npm --version

Explanation:
Checks npm version.

Example:
npm --version


============================================================
82.3 JENKINS WORKSPACE CLEANUP
============================================================

Command:
pwd

Explanation:
Confirm current workspace before cleanup.

Example:
pwd

------------------------------------------------------------

Command:
ls -lah

Explanation:
Lists workspace files.

Example:
ls -lah

------------------------------------------------------------

Command:
rm -rf <safe-folder-name>

Explanation:
Removes a specific folder from workspace.

Example:
rm -rf target

Warning:
Do not run rm -rf / or broad cleanup commands.

------------------------------------------------------------

Jenkins Pipeline Step:
cleanWs()

Explanation:
Cleans Jenkins workspace using Workspace Cleanup plugin.

Example:
cleanWs()


============================================================
82.4 JENKINS BRANCH FILTER REGEX
============================================================

Use case:
Trigger only one branch.

Regular expression:
^jenkinsfile$

Explanation:
Triggers Jenkins job only for branch named jenkinsfile.

------------------------------------------------------------

Use case:
Trigger multiple selected branches.

Regular expression:
^(jenkins-backend|jenkinsfile)$

Explanation:
Triggers Jenkins job for jenkins-backend or jenkinsfile.

------------------------------------------------------------

Use case:
Trigger QA or main branches.

Regular expression:
^(jenkinspipelineqa|jenkinsfile|main)$

Explanation:
Triggers Jenkins job for jenkinspipelineqa, jenkinsfile, or main.


============================================================
82.5 SAFE JENKINS PIPELINE TOOL VALIDATION STAGE
============================================================

Jenkinsfile Example:
pipeline {
  agent any

  stages {
    stage('Tool Check') {
      steps {
        sh '''
          whoami
          pwd
          git --version
          docker --version || true
          kubectl version --client || true
          helm version || true
          terraform version || true
          aws --version || true
          az version || true
          python3 --version || true
          node --version || true
          npm --version || true
        '''
      }
    }
  }
}

Explanation:
Checks common DevOps tools on the Jenkins agent without printing secrets.


============================================================
82.6 JENKINS PIPELINE WITH GIT CHECKOUT
============================================================

Jenkinsfile Example:
pipeline {
  agent any

  stages {
    stage('Checkout') {
      steps {
        checkout scm
        sh '''
          git status
          git branch -a
          git log --oneline -5
        '''
      }
    }
  }
}

Explanation:
Checks out source code and prints safe Git status information.


============================================================
82.7 JENKINS PIPELINE WITH DOCKER BUILD
============================================================

Jenkinsfile Example:
pipeline {
  agent any

  environment {
    IMAGE_NAME = "search_server"
    IMAGE_TAG = "latest"
  }

  stages {
    stage('Docker Build') {
      steps {
        sh '''
          docker build -t ${IMAGE_NAME}:${IMAGE_TAG} -f Dockerfile .
          docker images | grep ${IMAGE_NAME} || true
        '''
      }
    }
  }
}

Explanation:
Builds a Docker image inside Jenkins.

Security Note:
Do not pass secrets as Docker build args unless approved and protected.


============================================================
82.8 JENKINS PIPELINE WITH AWS ECR LOGIN
============================================================

Jenkinsfile Example:
pipeline {
  agent any

  environment {
    AWS_REGION = "<region>"
    ECR_REGISTRY = "<account-id>.dkr.ecr.<region>.amazonaws.com"
    IMAGE_NAME = "search_server"
    IMAGE_TAG = "latest"
  }

  stages {
    stage('AWS Identity Check') {
      steps {
        sh '''
          aws sts get-caller-identity
        '''
      }
    }

    stage('ECR Login') {
      steps {
        sh '''
          aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REGISTRY}
        '''
      }
    }

    stage('Build and Push') {
      steps {
        sh '''
          docker build -t ${IMAGE_NAME}:${IMAGE_TAG} -f Dockerfile .
          docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${ECR_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}
          docker push ${ECR_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}
        '''
      }
    }
  }
}

Explanation:
Logs into ECR, builds Docker image, tags it, and pushes it to ECR.

Security Note:
Use Jenkins credentials or agent role. Do not hardcode AWS keys.


============================================================
82.9 JENKINS PIPELINE WITH AZURE ACR LOGIN
============================================================

Jenkinsfile Example:
pipeline {
  agent any

  environment {
    ACR_NAME = "<acr-name>"
    ACR_LOGIN_SERVER = "<acr-name>.azurecr.io"
    IMAGE_NAME = "api-service"
    IMAGE_TAG = "latest"
  }

  stages {
    stage('Azure Account Check') {
      steps {
        sh '''
          az account show
        '''
      }
    }

    stage('ACR Login') {
      steps {
        sh '''
          az acr login --name ${ACR_NAME}
        '''
      }
    }

    stage('Build and Push') {
      steps {
        sh '''
          docker build -t ${IMAGE_NAME}:${IMAGE_TAG} -f Dockerfile .
          docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${ACR_LOGIN_SERVER}/${IMAGE_NAME}:${IMAGE_TAG}
          docker push ${ACR_LOGIN_SERVER}/${IMAGE_NAME}:${IMAGE_TAG}
        '''
      }
    }
  }
}

Explanation:
Logs into Azure Container Registry, builds Docker image, tags it, and pushes it.

Security Note:
Use managed identity, service connection, or Jenkins credentials. Do not hardcode secrets.


============================================================
82.10 JENKINS PIPELINE WITH KUBECTL DEPLOYMENT
============================================================

Jenkinsfile Example:
pipeline {
  agent any

  environment {
    NAMESPACE = "<namespace>"
    DEPLOYMENT_NAME = "<deployment-name>"
  }

  stages {
    stage('Kubernetes Context Check') {
      steps {
        sh '''
          kubectl config current-context
          kubectl get ns
        '''
      }
    }

    stage('Deploy') {
      steps {
        sh '''
          kubectl apply -f deployment.yml -n ${NAMESPACE}
          kubectl rollout status deployment/${DEPLOYMENT_NAME} -n ${NAMESPACE}
        '''
      }
    }
  }
}

Explanation:
Applies Kubernetes manifest and waits for rollout status.

Security Note:
Protect kubeconfig and service account tokens.


============================================================
82.11 JENKINS PIPELINE WITH HELM DEPLOYMENT
============================================================

Jenkinsfile Example:
pipeline {
  agent any

  environment {
    RELEASE_NAME = "<release-name>"
    CHART_PATH = "./chart"
    NAMESPACE = "<namespace>"
    VALUES_FILE = "values-dev.yaml"
  }

  stages {
    stage('Helm Lint') {
      steps {
        sh '''
          helm lint ${CHART_PATH}
        '''
      }
    }

    stage('Helm Template') {
      steps {
        sh '''
          helm template ${RELEASE_NAME} ${CHART_PATH} -f ${VALUES_FILE} --namespace ${NAMESPACE}
        '''
      }
    }

    stage('Helm Upgrade') {
      steps {
        sh '''
          helm upgrade --install ${RELEASE_NAME} ${CHART_PATH} \
            -f ${VALUES_FILE} \
            --namespace ${NAMESPACE} \
            --create-namespace
        '''
      }
    }
  }
}

Explanation:
Validates and deploys Helm chart from Jenkins.


============================================================
82.12 JENKINS PIPELINE WITH TERRAFORM
============================================================

Jenkinsfile Example:
pipeline {
  agent any

  stages {
    stage('Terraform Format') {
      steps {
        sh 'terraform fmt -check -recursive'
      }
    }

    stage('Terraform Init') {
      steps {
        sh 'terraform init -input=false'
      }
    }

    stage('Terraform Validate') {
      steps {
        sh 'terraform validate'
      }
    }

    stage('Terraform Plan') {
      steps {
        sh 'terraform plan -input=false -out=tfplan'
      }
    }

    stage('Terraform Apply') {
      when {
        branch 'main'
      }
      steps {
        input message: 'Approve Terraform apply?'
        sh 'terraform apply -input=false tfplan'
      }
    }
  }
}

Explanation:
Runs Terraform workflow with manual approval before apply on main branch.

Security Note:
Terraform state and plan files may contain sensitive data. Store artifacts securely.


============================================================
82.13 JENKINS LOG COMMANDS ON LINUX SERVER
============================================================

Command:
sudo systemctl status jenkins

Explanation:
Checks Jenkins service status.

Example:
sudo systemctl status jenkins

------------------------------------------------------------

Command:
sudo journalctl -u jenkins -n 200 --no-pager

Explanation:
Shows last 200 Jenkins service logs.

Example:
sudo journalctl -u jenkins -n 200 --no-pager

------------------------------------------------------------

Command:
sudo journalctl -u jenkins -f

Explanation:
Follows Jenkins service logs live.

Example:
sudo journalctl -u jenkins -f

------------------------------------------------------------

Command:
sudo tail -f /var/log/jenkins/jenkins.log

Explanation:
Follows Jenkins log file if Jenkins logs are stored under /var/log/jenkins.

Example:
sudo tail -f /var/log/jenkins/jenkins.log

------------------------------------------------------------

Command:
sudo grep -i "error" /var/log/jenkins/jenkins.log | tail -50

Explanation:
Searches Jenkins logs for recent errors.

Example:
sudo grep -i "error" /var/log/jenkins/jenkins.log | tail -50


============================================================
82.14 JENKINS SERVICE RESTART
============================================================

Command:
sudo systemctl restart jenkins

Explanation:
Restarts Jenkins service.

Example:
sudo systemctl restart jenkins

Warning:
Restarting Jenkins can interrupt running builds. Use approved process.

------------------------------------------------------------

Command:
sudo systemctl stop jenkins

Explanation:
Stops Jenkins service.

Example:
sudo systemctl stop jenkins

------------------------------------------------------------

Command:
sudo systemctl start jenkins

Explanation:
Starts Jenkins service.

Example:
sudo systemctl start jenkins


============================================================
82.15 JENKINS CLI COMMANDS
============================================================

Purpose:
Jenkins CLI allows job and build operations from terminal.

Command:
java -jar jenkins-cli.jar -s <jenkins-url> who-am-i

Explanation:
Checks Jenkins CLI authentication identity.

Example:
java -jar jenkins-cli.jar -s https://jenkins.example.com who-am-i

------------------------------------------------------------

Command:
java -jar jenkins-cli.jar -s <jenkins-url> list-jobs

Explanation:
Lists Jenkins jobs.

Example:
java -jar jenkins-cli.jar -s https://jenkins.example.com list-jobs

------------------------------------------------------------

Command:
java -jar jenkins-cli.jar -s <jenkins-url> build <job-name>

Explanation:
Triggers a Jenkins job.

Example:
java -jar jenkins-cli.jar -s https://jenkins.example.com build my-job

------------------------------------------------------------

Command:
java -jar jenkins-cli.jar -s <jenkins-url> build <job-name> -p KEY=VALUE

Explanation:
Triggers a parameterized Jenkins job.

Example:
java -jar jenkins-cli.jar -s https://jenkins.example.com build my-job -p ENV=dev

Security Note:
Do not pass secrets directly as CLI parameters.


============================================================
83. JENKINS TROUBLESHOOTING GUIDE
============================================================

Purpose:
This section contains common Jenkins issues, checks, and fixes.

============================================================
83.1 JENKINS BUILD FAILS DURING CHECKOUT
============================================================

Symptoms:
Git checkout fails.

Check commands:
git --version
git ls-remote <repository-url>
git status
git remote -v

Possible causes:
- Wrong repository URL
- Missing credentials
- Branch does not exist
- Network or proxy issue
- Git plugin issue

Fix:
1. Confirm repository URL.
2. Confirm branch exists.
3. Confirm Jenkins credentials.
4. Check proxy and network.
5. Retry checkout.


============================================================
83.2 JENKINS AGENT OFFLINE
============================================================

Symptoms:
Build stuck waiting for agent.

Check:
- Jenkins node status in UI.
- Agent pod status if running in Kubernetes.
- Agent service logs if static VM.

Kubernetes commands:
kubectl get pods -n <jenkins-agent-namespace>
kubectl describe pod <agent-pod-name> -n <jenkins-agent-namespace>
kubectl logs <agent-pod-name> -n <jenkins-agent-namespace>

Linux service commands:
sudo systemctl status jenkins-agent
sudo journalctl -u jenkins-agent -n 200 --no-pager

Possible causes:
- Agent disconnected
- Resource shortage
- Wrong label
- Network issue
- Expired secret or token
- Pod image pull issue

Fix:
1. Restart agent.
2. Check labels.
3. Check logs.
4. Check credentials.
5. Check Kubernetes events.


============================================================
83.3 JENKINS DOCKER BUILD FAILS
============================================================

Symptoms:
Docker build or push fails.

Check commands:
docker --version
docker info
docker images
docker ps -a
docker system df

Possible causes:
- Docker daemon not running
- Permission denied to Docker socket
- Disk full
- Dockerfile error
- Registry login failed

Fix commands:
sudo systemctl status docker
docker system df
docker image prune
docker login <registry-url>

Warning:
Cleanup commands should be approved on shared agents.


============================================================
83.4 JENKINS KUBECTL FAILS
============================================================

Symptoms:
kubectl command fails in Jenkins.

Check commands:
kubectl version --client
kubectl config current-context
kubectl get ns
kubectl auth can-i get pods -n <namespace>

Possible causes:
- Missing kubeconfig
- Wrong context
- Expired token
- RBAC permission issue
- Network issue to API server

Fix:
1. Validate kubeconfig.
2. Confirm context.
3. Confirm namespace.
4. Check RBAC permissions.
5. Refresh AKS credentials if needed.


============================================================
83.5 JENKINS HELM DEPLOYMENT FAILS
============================================================

Symptoms:
helm install or upgrade fails.

Check commands:
helm version
helm lint <chart-path>
helm template <release-name> <chart-path> -f <values-file> --namespace <namespace>
helm status <release-name> -n <namespace>
kubectl get pods -n <namespace>
kubectl describe pod <pod-name> -n <namespace>

Possible causes:
- Bad template syntax
- Missing values
- Invalid Kubernetes YAML
- Missing secret or configmap
- Pod runtime issue after deployment

Fix:
1. Run helm lint.
2. Render helm template locally.
3. Check pod events and logs.
4. Fix values file.


============================================================
83.6 JENKINS TERRAFORM FAILS
============================================================

Symptoms:
Terraform init, plan, or apply fails in Jenkins.

Check commands:
terraform version
terraform fmt -check -recursive
terraform init -input=false
terraform validate
terraform plan -input=false

Possible causes:
- Backend access issue
- Missing cloud credentials
- State lock
- Provider version mismatch
- Variable file missing
- Permission issue

Fix:
1. Confirm backend access.
2. Confirm cloud identity.
3. Check state lock.
4. Run terraform init -upgrade if provider issue.
5. Verify tfvars path.


============================================================
83.7 JENKINS DISK FULL
============================================================

Symptoms:
Build fails with no space left on device.

Check commands:
df -h
du -sh *
docker system df

Possible causes:
- Old workspaces
- Docker images and containers
- Build artifacts
- Large logs

Fix:
1. Clean old workspaces.
2. Clean Docker unused images if approved.
3. Archive or remove old artifacts.
4. Add disk capacity if recurring.

Commands:
docker image prune
docker container prune
docker system prune

Warning:
Run cleanup only if approved.


============================================================
83.8 JENKINS SECRET MASKING
============================================================

Best Practice:
Use Jenkins Credentials Binding.

Example:
withCredentials([string(credentialsId: 'my-secret-id', variable: 'MY_SECRET')]) {
  sh '''
    echo "Secret is available but not printed"
    command-that-uses-secret
  '''
}

Explanation:
Injects secret into environment variable and masks it in logs.

Warning:
Do not echo secret values.


============================================================
84. AZURE INFRA TROUBLESHOOTING QUICK REFERENCE
============================================================

Issue:
Cannot access Key Vault.

Check commands:
az keyvault show --name <keyvault-name>
az keyvault show --name <keyvault-name> --query properties.networkAcls
az role assignment list --scope <keyvault-resource-id> -o table
curl -vk https://<keyvault-name>.vault.azure.net

Common causes:
- Missing RBAC role
- Firewall blocks access
- Private endpoint DNS issue
- Wrong tenant or subscription

------------------------------------------------------------

Issue:
AKS cannot pull image from ACR.

Check commands:
az aks check-acr --name <aks-cluster-name> --resource-group <aks-resource-group> --acr <acr-name>.azurecr.io
az acr repository show-tags --name <acr-name> --repository <repository-name> -o table
kubectl describe pod <pod-name> -n <namespace>

Common causes:
- Missing AcrPull
- Wrong image tag
- Wrong registry URL
- imagePullSecret issue

------------------------------------------------------------

Issue:
Private endpoint not resolving.

Check commands:
nslookup <private-endpoint-hostname>
az network private-endpoint show --name <private-endpoint-name> --resource-group <resource-group-name>
az network private-dns record-set a list --zone-name <private-dns-zone-name> --resource-group <resource-group-name> -o table
az network private-dns link vnet list --zone-name <private-dns-zone-name> --resource-group <resource-group-name> -o table

Common causes:
- Missing private DNS record
- VNet not linked to private DNS zone
- DNS forwarder issue
- Wrong hostname

------------------------------------------------------------

Issue:
Network connection timeout.

Check commands:
nslookup <hostname>
nc -zv <hostname> <port>
curl -vk https://<hostname>
az network watcher test-connectivity --source-resource <source-resource-id> --dest-address <destination-hostname-or-ip> --dest-port <port>

Common causes:
- NSG blocks traffic
- Route table issue
- Firewall issue
- Private endpoint issue
- Proxy issue

------------------------------------------------------------

Issue:
Storage mount fails in AKS.

Check commands:
kubectl describe pod <pod-name> -n <namespace>
kubectl describe pvc <pvc-name> -n <namespace>
kubectl get pods -n kube-system | grep -i csi
kubectl logs <csi-pod-name> -n kube-system --tail=200

Common causes:
- Storage key issue
- CSI driver issue
- Firewall or private endpoint issue
- File share missing
- Permission issue

END UPDATED AZURE INFRA AZURE NETWORK AND JENKINS COMMANDS SECTION

END DOCUMENT
