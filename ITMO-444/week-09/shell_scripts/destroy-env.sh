#!/bin/bash 


IDS=$(aws ec2 describe-instances --query 'Reservations[*].Instances[].InstanceId')
#created variable "IDS" that pulls InstanceIds from --output json and assigns them to the newly created variable
echo $IDS
#confirms that the variable "IDS" has the InstanceIds
aws ec2 terminate-instances --instance-ids $IDS


aws ec2 describe-instances --query 'Reservations[*].Instances[?State.Name==`terminated`].InstanceId'
#terminated instance(s) should show up here
aws ec2 describe-instances --query 'Reservations[*].Instances[?State.Name==`running`].InstanceId'
#nothing should show here if instances have been terminated successfully