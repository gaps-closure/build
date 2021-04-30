#!/bin/bash

PASSWD=${1:-admin}

JENKINS_CLI=jenkins-cli.jar
JENKINS_URL=http://localhost:8080
JENKINS_AUTH=admin:$PASSWD

if [ -f "$JENKINS_CLI" ]
then
  echo "Using $JENKINS_CLI"
else
  wget -O "$JENKINS_CLI" $JENKINS_URL/jnlpJars/jenkins-cli.jar
fi

while read -u 10 p || [ -n "$p" ]
do
  CMD="java -jar $JENKINS_CLI -s $JENKINS_URL -auth $JENKINS_AUTH install-plugin $p"
  echo $CMD
  $CMD
done 10<"plugins.txt"

echo "Restarting Jenkins...."
java -jar $JENKINS_CLI -s $JENKINS_URL -auth $JENKINS_AUTH restart
