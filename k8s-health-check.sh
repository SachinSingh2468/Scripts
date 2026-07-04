#Kubernetes Cluster Health check

#script ke liye path - where to store
#backup dir & log dir initialize, backup & log file format initialize , create if not present
#create a log function that store logs in logfile
#check if kubectl installed or not
#check cluster connectivity, node, pods,namespace, service, pvc
#find problamatic pods, generate reports




REPORT_DIR="$HOME/k8s-health/report"
LOG_DIR="$HOME/k8s-health/logs"

date=$(date +%Y-%m-%d_%H-%M-%S)

REPORT_FILE="$REPORT_DIR/report-$DATE.txt"
LOG_FILE="$LOG_DIR/health.log"

#creating directory if not present

mkdir -p "$REPORT_DIR"
mkdir -p "$LOG_DIR"

# creating a log function
log_message() {
    echo "$(date '+%F %T')" : $1 >> "$LOG_FILE"
}

log_message "Script started"
#check kubectl is installed or not 
if ! command -v kubectl $> /dev/null
then
    echo "ERROR ! kubectl is not installed"
    exit 1
fi

#check k8s cluster connectivity
kubectl cluster-info > /dev/null 2>&1
if [ $? -nq 0]
then    
    echo "ERROR ! Not able to connect with K8s cluster"
    exit 1
fi

#run commands

NODE_STATUS=$(kubectl get nodes)
NAMESPACE_STATUS=$(kubectl get ns -A)
POD_STATUS=$(kubectl get pods -A)
DEPLOYMENT_STATUS=$(kubectl get deployments -A)
SERVICE_STATUS=$(kubectl get svc -A)
PVC_STATUS=$(kubectl get pvc -A)

#find problematic pods

FAILED_PODS=$(kubectl get pods -A | grep -e "Crashloopbackoff|Pending|Evicted|Imagepullbackoff")

#generate reports
{
echo "========================"
echo "====Kubernetes Cluster Health Report========="
echo "Generated : $DATE"

echo 
echo "=================================="
echo "NODE STATUS"
echo "$NODE_STATUS"

echo
echo "NAMESPACE STATUS"
echo "$NAMESPACE_STATUS"

echo
echo "PODS STATUS"
echo "$POD_STATUS"

echo
echo "DEPLOYMENT STATUS"
echo "$DEPLOYMENT_STATUS"

echo
echo "SERVICE STATUS"
echo "$SERVICE_STATUS"

echo
echo "PVC STATUS"
echo "$PVC_STATUS"

echo
echo "PROBLEMATIC PODS STATUS"
if [ -z "$FAILED_POD" ]
then 
    echo "No problematic pods found"
else
    echo "$FAILED_POD"
fi
} > $REPORT_FILE

log_message "Health Check Completed"
