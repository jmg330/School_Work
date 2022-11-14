#!/bin/bash

# Make extensive use of: https://awscli.amazonaws.com/v2/documentation/api/latest/reference/index.html
# Adding URLs of the syntax above each command

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

# Need WAIT for the operation to complete
# Need code to create an RDS instance with a read-replica

aws rds create-db-instance --db-instance-identifier $8 --db-instance-class $9 --engine ${10} --master-username ${11} --master-user-password ${12} --allocated-storage ${13}

#AWS rds instance needs to wait after being created

aws rds wait db-instance-available

#Need to query db instance indentifiers 

RDSIDENT=$(aws rds describe-db-instances --query "DBInstances[0].DBInstanceIdentifier")

aws rds create-db-instance-read-replica --db-instance-identifier $RDSIDENT --source-db-instance-identifier $RDSIDENT --db-instance-class $9 --engine ${10} --master-username ${11}
