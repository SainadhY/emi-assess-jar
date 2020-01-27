#!/bin/bash
sudo yum -y update

#echo "Install Java JDK 8"
#sudo yum remove -y java
#sudo yum install -y java-1.8.0-openjdk

#echo "Install Maven"

#sudo wget http://apache.saix.net/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz
#sudo tar xvf apache-maven-3.6.3-bin.tar.gz
#sudo mv apache-maven-3.6.3  /usr/local/apache-maven
#export M2_HOME=/usr/local/apache-maven
#export M2=$M2_HOME/bin
#export PATH=$M2:$PATH

#echo "Install git"
#sudo yum install -y git

#echo "Install Docker engine"
#sudo yum update -y
#sudo yum install docker -y
#sudo sudo chkconfig docker on

#echo "Install Jenkins"
#sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo
#sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
#sudo yum install -y jenkins
#sudo usermod -a -G docker jenkins
#sudo chkconfig jenkins on

#echo "Start Docker & Jenkins services"
sudo service docker start
sudo service jenkins start
