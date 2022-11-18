# Course LOBs (Learning objectives)

### 13-17/11

- Familiarize yourself with the Authentication and Authorization terms.
- Challenge (8k): use `aws cloudtrail lookup-events` command (and other linux filtering commands) to fetch all EC2 instances for which a given IAM role is associated. [This docs](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/view-cloudtrail-events-cli.html#looking-up-events-with-the-aws-cli) may help.
- Challenge (23k): use [AWS DynamoDB](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Introduction.html), or (AWS Lambda)[https://docs.aws.amazon.com/lambda/latest/dg/welcome.html] to implement a [race condition solution](https://stackoverflow.com/questions/45803968/aws-s3-client-race-condition-solutions) for parallel writing s3 objects.  