#!/bin/bash

aws ec2 run-instances --image-id ami-00399ec92321828f5 --instance-type t2.micro --count 1 --subnet-id subnet-3fd44654 --key-name linux-vm-desktop-itmo-444 --security-group-ids sg-0b5409229058792ec --user-data file://create-env.sh
