#!/bin/bash

# Make extensive use of: https://awscli.amazonaws.com/v2/documentation/api/latest/reference/index.html
# Adding URLs of the syntax above each command

#disables AWS pager
export AWS_PAGER="less"

# Deletes S3 Buckets
REMOVEBUCKET=$(aws s3api list-buckets --query 'Buckets[-1].Name')
echo "Deleting S3 Bucket"
aws s3 rb s3://$REMOVEBUCKET

# Deletes Dynamo Database
DYNODB=$(aws dynamodb list-tables --query 'TableNames[0]')
aws dynamodb delete-table --table-name $DYNODB
echo "Deleting Dynamo Database..."
aws dynamodb wait table-not-exists --table-name $DYNODB
echo "Dynamo Database has been deleted"

# Deletes SNS Topic ARN
SNSTPCARN=$(aws sns list-topics --query 'Topics[0].TopicArn')
aws sns delete-topic --topic-arn $SNSTPCARN
echo "SNS Topic ARN has been deleted"

#Finds and logs running running ec2 instances
IDS=$(aws ec2 describe-instances --query "Reservations[*].Instances[?State.Name==`running`].InstanceId")
IDSARRAY=( $(echo $IDS))

#Retrives TargetGroup ARN 
TARGETARN=$(aws elbv2 describe-target-groups --query "TargetGroups[0].TargetGroupArn")

#Retrieves load balancer
ELBARN=$(aws elbv2 describe-load-balancers --name $7 --query "LoadBalancers[0].LoadBalancerArn")

#Finds and logs available rds instances
RDSIDENTS=$(aws rds describe-db-instances --query "DBInstances[?DBInstanceStatus==`available`].DBInstanceIdentifier")
RDSIDENTSARRAY=( $(echo $RDSIDENTS))


#This loop de-registers the target groups associated with the ELB
for ID in ${IDSARRAY[@]};
do
aws elbv2 deregister-targets --target-group-arn $TARGETARN --targets Id=$ID

#Waiter is used to allow all Target groups to be de-register the target properly
aws elbv2 wait target-deregistered --target-group-arn $TARGETARN --targets Id=$ID
done

#This command deteles the ELB 
aws elbv2 delete-load-balancer --load-balancer-arn $ELBARN

#This command deletes the target group
aws elbv2 delete-target-group --target-group-arn $TARGETARN

#This command terminates all running ec2 instances
aws ec2 terminate-instances --instance-ids $IDS
echo $IDS


