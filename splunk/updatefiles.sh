#!/bin/sh

# Set optimistic file locking in main location
if ! grep -iq "OPTIMISTIC_ABOUT_FILE_LOCKING = 1" ${SPLUNK_HOME}/etc/splunk-launch.conf; then
  printf "\nOPTIMISTIC_ABOUT_FILE_LOCKING = 1\n" >> ${SPLUNK_HOME}/etc/splunk-launch.conf
fi
# Set optimistic file locking in backup location
if ! grep -iq "OPTIMISTIC_ABOUT_FILE_LOCKING = 1" ${SPLUNK_BACKUP_DEFAULT_ETC}/etc/splunk-launch.conf; then
  printf "\nOPTIMISTIC_ABOUT_FILE_LOCKING = 1\n" >> ${SPLUNK_BACKUP_DEFAULT_ETC}/etc/splunk-launch.conf
fi
exit0
