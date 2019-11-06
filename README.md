# DokuWiki-jenkins-docker-apache

## DokuWiki application deployment for DevOps course project

Continuous Integration and Continuous Delivery highly fundamental topics in the software industry especially with the cloud and container 
technologies. Further I will show a simple example how we can deploy DokuWiki application using Jenkins, Docker and Apache HTTP Server.

### Preconditions
First of all, we need to install and configure Jenkins server on our machine. If you don't know how to do it, you can find here detailed
instruction https://www.blazemeter.com/blog/how-to-install-jenkins-on-windows/ .

Next, install Docker desktop application, if it is not already installed. Article about Docker installation can be found here https://docs.docker.com/docker-for-windows/install/ .

### Jenkins configuration
We need to add additional plugins to Jenkins to perform this task. We will install Build Pipeline Plugin and Global Slack Notifier Plugin.
Next, we create new item -> Pipeline. 

In General section we add three parameters:
1) String Parameter to store github link for project and as a default value we set the link for our github project which contains necessary configuration files.
2) Boolean Parameter to store variable "build_and_run_docker" with default value.
3) Boolean Parameter to store variable "remove" without default value.

In Pipeline section we add our Jenkinsfile. You can find example of Jenkins file in this repo. We define different stages and steps to perform in this file. Here we use Declarative Pipeline.
So, as it is indicated in our Jenkinsfile, firstly we will clone our git repo, next we will build Docker image, after that we will run it and delete.

### Docker configuration
After Jenkins is configured, we need to configure Docker and create right Dockerfile. 
We will create our image based on ubuntu image. We also need to install apache and php to deploy DokuWiki. After the installation we enable apache mods, next we download dokuwiki repo and unarchive it.
We change the ownership and the permissions. 

Now we need to configure apache. Apache use '000-default.conf' file for default configuration. So, we need to locate our configuration file with this one at '/etc/apache2/sites-available/', enable our configurations and disable default configuration file.
All these steps you can find here in the Dockerfile. Also you can see the example of Apache configurtaion file in dokuwiki.conf file.

### Slack Configuration
We just need to configure slack notifications. 
To configure Jenkins integration in Slack go to https://myspace.slack.com/services/new/jenkins-ci . Next go to Jenkins, open Manage Jenkins -> Configure System, find there Global Slack Notifier Plugin, add your workspace, generate secret text and indicate channel.

Now, we can start our Jenkins Job to deploy DokuWiki.
