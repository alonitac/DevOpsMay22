# IAM Tutorial

## Identity-based policies

### Create IAM role with permissions over S3 and attach it to an EC2 instance


1. Open the IAM console at [https://console\.aws\.amazon\.com/iam/](https://console.aws.amazon.com/iam/)\.

2. In the navigation pane, choose **Roles**, **Create role**\.

3. On the **Trusted entity type** page, choose **AWS service** and the **EC2** use case\. Choose **Next: Permissions**\.

4. On the **Attach permissions policy** page, search for **AmazonS3FullAccess** AWS managed policy\.

5. On the **Review** page, enter a name for the role and choose **Create role**\.
6. Attach the role to your EC2 instance. 


### Create a policy to access a certain bucket only and attach it to your IAM role.

1. Open the [IAM console](https://console.aws.amazon.com/iam/).
2. From the console, open the IAM user or role that should have access to only a certain bucket.
3. In the **Permissions** tab, remove the **AmazonS3FullAccess** AWS managed policy.
4. Click **Add permissions** and **Create inline policy**
5. Choose **Import manages policy** and import **AmazonS3FullAccess**, switch to the JSON view of your new policy.
6. Inspired by [policies examples](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_examples.html) in AWS IAM docs, try to change the given policy JSON such that it allows the user to list, read, and write objects with a prefix `images/`
7. Save your policy, and validate your changes using the [IAM Policy Simulator](https://policysim.aws.amazon.com/).

### Extend your policy

1. Explore [S3 policy condition key elements](https://docs.aws.amazon.com/AmazonS3/latest/userguide/amazon-s3-policy-keys.html).
2. Try to add a condition to your above policy such that only objects in `STANDARD_IA` storage-class can be accessed. 
3. Validate your changes.

### Tag IAM users and roles to control what they can access

1. In IAM roles console, choose your role.
2. In **Tags** tab, add a tag with the key `BucketPrefix` and some value according to your choice.
3. Instead of allow operation on prefix `images/`, try to allow access on a dynamic prefix according to the principal tag:
```text
"Resource": ["arn:aws:s3:::<your-bucket-name>/${aws:PrincipalTag/BucketPrefix}/*"]
```

### Controlling access to EC2 using resource tags

In this demo we are going to create a role which can start/stop EC2 instances belong to Development environment only.

1. In IAM console, **Roles** page, create a new role with **AWS account** trusted entity type.
2. According to the policy described in [Controlling access to AWS resources](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_tags.html#access_tags_control-resources), create an inline policy for your role, that allows the principal assumed this role to start/stop EC2 instances that was tagged
   with key `Env` and value `Dev`
3. Create and save the role.
4. Tag some of your EC2 instance with `Env=Dev`.
5. Now we would like to switch our AWS IAM user to assume the created role. 
   1. In the IAM console, choose your user name on the navigation bar in the upper right\. It typically looks like this: ***username*@*account\_ID\_number\_or\_alias***\.
   2. Choose **Switch Role**
   3. On the **Switch Role** page, type the account ID number and the role.
6. Test your policy by trying to start/stop EC2 instances with/without appropriate `Env` tag.
7. Switch back to your IAM user. 

### Force tagging policy for resources

1. We now want to force a tagging policy in our AWS account. We want all EC2 instances to be tagged with a key `Env` with allowed values of `Dev`, `Test`, or `Prod`.
2. According to the policy described in [Controlling access during AWS requests](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_tags.html#access_tags_control-requests), add a statement to the above inline policy, that enforces the tagging policy for EC2 instances belonging to different environments. 
3. Switch to your role and test your policy. 
