#!/bin/bash

# Reuse all the code from mp1 - remove the RDS content, no need for that in this project

# Use the AWS CLI to Create a S3 Bucket
#Create S3 bucket
aws s3 mb s3://${11}

# Create DynamoDB Table
# I am giving you the table creation script for DynamoDB

aws dynamodb create-table --table-name ${10} \
    --attribute-definitions AttributeName=RecordNumber,AttributeType=S AttributeName=Email,
    AttributeType=S \
    --key-schema AttributeName=Email,KeyType=HASH AttributeName=RecordNumber,KeyType=RANGE 
    --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
    --stream-specification StreamEnabled=TRUE,StreamViewType=NEW_AND_OLD_IMAGES

# Create SNS topic (to subscribe the users phone number to)
# Use the AWS CLI to create the SNS
aws sns create-topic --name $9


# Install ELB and EC2 instances here -- remember to add waiters and provide and --iam-instance-profile so that your EC2 instances have permission to access SNS, S3, and DynamoDB
SECGROUPID=$(aws ec2 describe-security-groups --query "SecurityGroups[0].[GroupId]")
echo $SECGROUPID
SUBNETID1=$(aws ec2 describe-subnets --query "Subnets[0].SubnetId")
echo $SUBNETID1
SUBNETID2=$(aws ec2 describe-subnets --query "Subnets[1].SubnetId")

aws ec2 run-instances --image-id $1 --instance-type $2 --count $3 --subnet-id $SUBNETID1 --key-name $4 --security-group-ids $SECGROUPID --user-data $5

IDS=$(aws ec2 describe-instances --query 'Reservations[*].Instances[?State.Name==`pending`].InstanceId')
#aws ec2 waiters
aws ec2 wait instance-running --instance-ids $IDS

IDSARRARY=($(echo $IDS))
#aws ec2 waiters

aws ec2 wait instance-running --instance-ids $IDS

# Need Code to create Target Groups and then dynamically attach instances (3) in this example

VPCID=$(aws ec2 describe-vpcs --query "Vpcs[0].VpcId")
echo $VPCID

aws elbv2 create-target-group --name $6 --protocol HTTP --port 80 --vpc-id $VPCID --health-check-protocol HTTP --health-check-port 80 --target-type instance 

# Need Code to register Targets to Target Group (your instance IDs)
TARGETARN=$(aws elbv2 describe-target-groups --query "TargetGroups[0].TargetGroupArn")

for ID in ${IDSARRARY[@]};
do
aws elbv2 register-targets --target-group-arn $TARGETARN --targets Id=$ID
done 

# Need code to create an ELB 
aws elbv2 create-load-balancer --name $7 --subnets $SUBNETID1 $SUBNETID2

#Process needs to wait to run sucessfully
aws elbv2 wait --names $7

# Need to create ELB listener (where you attach the target-group ARN)
#Query for ELB arn
ELBARN=$(aws elbv2 describe-load-balancers --name $7 --query "LoadBalancers[0].LoadBalancerArn")
 
aws elbv2 create-listener --load-balancer-arn $ELBARN --protocol HTTP --port 80 --default-actions Type=forward,TargetGroupArn=$TARGETARN

ELBDNS=$(aws elbv2 describe-load-balancers --query "LoadBalancers[0].DNSName")
echo "This is the URL to get to the ELB: " $ELBDNS

#  --iam-instance-profile Name=$8

