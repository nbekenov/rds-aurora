#!/bin/bash
main(){
    #####Installing dependencies and packages ####
    echo "Installing Security Updates..."
    sudo yum -y update
    echo "Installing ec2 instance connect..."
    sudo yum install ec2-instance-connect
    echo "Installing latest aws-ssm agent..."
    sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
    sudo systemctl enable amazon-ssm-agent
    echo "Starting latest aws-ssm agent..."
    sudo systemctl start amazon-ssm-agent
    sudo amazon-linux-extras enable postgresql14
    sudo yum -y install postgresql
}
time main > /tmp/time-output.txt