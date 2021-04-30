CICD Structure
==============

The CICD process is utilizing Jenkins system to manage the builds. The Jenkins job definition files
are stored in the git repository. Moreover, the Jenkins itself is configured using the 
"configuration as a code" philosophy. All Jenkins configuration files are stored in git repository
as well.

The CICD related files are in the main CLOSURE project (git@github.com:gaps-closure/build) in the cicd directory. To successfully install Jenkins that directory needs to be present on the host.

Installing Jenkins
==================

Add a Jenkins archive to apt database, and install the package as follows:

```
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update
sudo apt-get install jenkins
```

To complete installation, open the Jenkins GUI in a browser, at http://<host>:8080, and follow prompts. Make sure to install the default plugins, and to create a user 'admin'.

Next, install Jenkins plugins:

```
cd <closure dir>/build/cicd
./install_plugins.sh <password for user admin>
```

Finally, import Jenkins configuration, and all defined jobs, using the GUI: 

From Jenkins GUI click on "Manage Jenkins", then "Configuration as Code", then enter the full path to the jenkins configuration directory "<closure dir>/build/cicd/jenkins_config" and click "Apply new configuration".

Maintaining configuration files
===============================

There are three kinds of configuration files in the cicd/jenkins_config directory:
1. The plugins.txt file: it contains short names of the required Jenkins plugins, one per line.
2. Job configuration files: these files have names that start with "job" and contain job configuration as defined by job-dsl plugin (i.e., a mixture of yaml and groovy scripts).
3. Jenkins configuration files: these are all other yaml files, containing the configuration of Jenkins as defined by configuration-as-code plugin.





