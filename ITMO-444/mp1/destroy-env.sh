#!/bin/bash

# Make extensive use of: https://awscli.amazonaws.com/v2/documentation/api/latest/reference/index.html
# Adding URLs of the syntax above each command

#disables AWS pager
export AWS_PAGER="less"

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

#Loops runs to delete all RDS instances in the array
for RDSIDENT in ${RDSIDENTSARRAY[@]};
do
aws rds delete-db-instance --db-instance-identifier $RDSIDENT --skip-final-snapshot

#Waiter used to to allow time for RDS instance to be deleted
aws rds wait db-instance-deleted --db-instance-identifier $RDSIDENT
done

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
