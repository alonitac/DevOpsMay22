# Course LOBs (Learning objectives)

### 13-17/11

- Familiarize yourself with the Authentication and Authorization terms.
- Familiarize yourself with the term service-level agreement (SLA)
- Challenge (8k): use `aws cloudtrail lookup-events` command (and other linux filtering commands) to fetch all EC2 instances for which a given IAM role is associated. [This docs](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/view-cloudtrail-events-cli.html#looking-up-events-with-the-aws-cli) may help.
- Challenge (23k): use [AWS DynamoDB](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Introduction.html), or (AWS Lambda)[https://docs.aws.amazon.com/lambda/latest/dg/welcome.html] to implement a [race condition solution](https://stackoverflow.com/questions/45803968/aws-s3-client-race-condition-solutions) for parallel writing s3 objects.

#### Practice IAM policies

Create the below policies following the [Principle of least privilege](https://en.wikipedia.org/wiki/Principle_of_least_privilege).

1. IAM policy with permissions to start and stop EC2 instance.
2. IAM policy with permissions read object from S3 buckets **except** objects starting with "internal/"
3. IAM policy with permissions to upload objects from `STANDARD` and `STANDARD_IA` storage classes **only**.
4. IAM policy with permissions to attach EBS to EC2.
5. IAM policy with permissions to attach EBS to EC2 from `us-east-1` region only.
6. IAM policy with permissions to attach EBS to EC2 from all US and EU regions.
7. IAM policy which denying users to assign policies to and identity, which means, users under this policy cannot assign IAM policies to other users, groups, roles.

#### Etag manual computing

Write some Python code that computes the Etag of a given file. Make sure you get the same results as appears in S3 console when uploading this file to a bucket. The algorithm can be found [here](https://stackoverflow.com/a/43819225).


### 20/11 - 1/12

- Subnet sizing - https://docs.aws.amazon.com/vpc/latest/userguide/configure-subnets.html#subnet-sizing
- Read about Bastion Host
- Differences between Security Group and Access Control Lists (ACL) in AWS - https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Security.html
- [Async IO in Python: A Complete Walkthrough](https://realpython.com/async-io-python/)
- Challenge (23k) - Deploy Network Load Balancer with Application Load Balancer as a target, as described [here](https://aws.amazon.com/blogs/networking-and-content-delivery/application-load-balancer-type-target-group-for-network-load-balancer/). 

#### SSH keys rotation

Write bash scripts that automatically rotates SSH keys for a given host `ec2-user@host`. The script should work as follows:

- Generate RSA key pair locally.
- Connect to the host.
- Append the public keys of the new generated key-pair into `~/.ssh/authorized_keys` file.
- Close the connection.
- Connect to the host using the new generated key, and remove the public key of the old key from `~/.ssh/authorized_keys`.

Note that the above steps should be automatically executed by the Bash script, not manually.

### 04-08/12

- Service outage
- Read about [Application-based stickiness](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/sticky-sessions.html#application-based-stickiness)
- Horizontal vs Vertical autoscale
