JENKINS_HOME="/var/lib/jenkins"
BACKUP_DIR="$HOME/jenkins_backup/backup"
LOG_DIR="$HOME/jenkins_backup/log"

DATE=$(date +%Y-%m-%d_%H-%M-%S)

BACKUP_FILE="$BACKUP_DIR/backup-jenkins-$DATE.tar.gz"
LOG_FILE="$LOG_FILE/backup.log"

#creating logging function

log_message() {
    echo "$(date +%Y-%m-%d %H:%M:%S) : $1" >> "LOG_FILE"
}

#create directories
mkdir $BACKUP_DIR
mkdir $LOG_DIR

log_message "Script started.."

#check jenkins installation

if [ ! -d "$JENKINS_HOME" ]
then
    echo "ERROR: Jenkins is not installed"
    log_message "jenkins home missing"
    exit 1
fi

if ! systemctl is-active --quiet jenkins
then
    echo "Jenkins is not running"
    log_message "jenkins service is down"
    exit 1
fi

#creating backup 
echo "Creating backup...."
tar -cvf "$BACKUP_FILE" "$JENKINS_HOME"

if [ $? -eq 0 ]
then
    echo "Backup created successfully"
    log_message "backup success"
else
    echo "Backup failed"
    log_message "backup failed"
    exit
fi

#Delete old backup 
find "$BACKUP_DIR" -name "*.tar.gz" -mtime +7 -delete
echo "Old backup delete successfullly"
log_message "Old backup delete successfully"

echo "Backup location"
echo "$BACKUP_FILE"

log_message "Script completed"
