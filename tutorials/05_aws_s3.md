
## Create a Bucket

1. In S3, Choose **Create bucket**.

   The **Create bucket** wizard opens.

2. In **Bucket name**, enter a DNS-compliant name for your bucket.

   The bucket name must:
    + Be unique across all of Amazon S3.
    + Be between 3 and 63 characters long.
    + Not contain uppercase characters.
    + Start with a lowercase letter or number.

3. In **Region**, choose the AWS Region where you want the bucket to reside.

   Choose the Region where you provisioned your EC2 instance.

4. Under **Object Ownership**, leave ACLs disabled.

5. Enable Default encryption with SSE-S3 encryption type.

6. Choose **Create bucket**.

You've created a bucket in Amazon S3.

## Upload an object to S3 bucket from an EC2 instance

Disclaimer: This is not going to work. Your EC2 instance has to have permissions to operate in S3.

1. Connect to your instance over SSH.
2. Read the [examples](https://docs.aws.amazon.com/cli/latest/reference/s3api/put-object.html#examples) in AWS code and write a command to upload (put-object) in your S3 bucket.
3. Got `Unable to locate credentials.` or `Access Denied`? follow the next section...

### Attach IAM role to your EC2 Instance with permissions over S3

You must create an IAM role before you can launch an instance with that role or attach it to an instance\.

**To create an IAM role using the IAM console**

1. Open the IAM console at [https://console\.aws\.amazon\.com/iam/](https://console.aws.amazon.com/iam/)\.

1. In the navigation pane, choose **Roles**, **Create role**\.

1. On the **Trusted entity type** page, choose **AWS service** and the **EC2** use case\. Choose **Next: Permissions**\.

1. On the **Attach permissions policy** page, search for **AmazonS3FullAccess** AWS managed policy\.

1. On the **Review** page, enter a name for the role and choose **Create role**\.


**To replace an IAM role for an instance**

1. In EC2 navigation pane, choose **Instances**.

1. Select the instance, choose **Actions**, **Security**, **Modify IAM role**.

1. Choose your created IAM role, click **Save**.


## Enable versioning on your bucket bucket

1. Sign in to the AWS Management Console and open the Amazon S3 console at [https://console\.aws\.amazon\.com/s3/](https://console.aws.amazon.com/s3/)\.

2. In the **Buckets** list, choose the name of the bucket that you want to enable versioning for\.

3. Choose **Properties**\.

4. Under **Bucket Versioning**, choose **Edit**\.

5. Choose **Enable**, and then choose **Save changes**\.

6. Upload multiple object with the same key, make sure versioning is working.

## Create lifecycle rule to manage non-current versions

1. Choose the **Management** tab, and choose **Create lifecycle rule**\.

1. In **Lifecycle rule name**, enter a name for your rule\.

1. Choose the scope of the lifecycle rule (in this demo we will apply this lifecycle rule to all objects in the bucket).

1. Under **Lifecycle rule actions**, choose the actions that you want your lifecycle rule to perform:
    + Transition *noncurrent* versions of objects between storage classes
    + Permanently delete *noncurrent* versions of objects

1. Under **Transition non\-current versions of objects between storage classes**:

    1. In **Storage class transitions**, choose **Standard\-IA**.

    1. In **Days after object becomes non\-current**, enter 30.

1. Under **Permanently delete previous versions of objects**, in **Number of days after objects become previous versions**, enter 90 days.

1. Choose **Create rule**\.

   If the rule does not contain any errors, Amazon S3 enables it, and you can see it on the **Management** tab under **Lifecycle rules**\.


## Objects deletion in bucket versioning enabled

1. In the **Buckets** list, choose a versioning enabled bucket\.
2. Choose **Upload** and upload an object multiple times under the same key, such that it has non-current versions.
3. In the bucket console, choose the **Objects** tab, and delete the object you have just uploaded.
4. After the deletion action, can you see the object in the bucket's objects list?

We will examine through AWS CLI what happened.

4. From your local machine, open a command terminal with [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)) installed.
```shell
aws --version
```
5. List the versions of you object. Replace `<bucket-name>` by you bucket name and `<object-key>` by the object key:
   ```shell
   aws s3api list-object-versions --bucket <bucket-name> --prefix <object-key>
   ```
   Can you confirm that you object has not been deleted? Inspect `DeleteMarkers`.
6. Delete the _delete mark_ by:
   ```shell
   aws s3api delete-object --bucket <bucket-name> --key <object-key> --version-id <delete-mark-version-id>
   ```
7. Can you see the object in the bucket's object list in the AWS Web Console? Can you confirm that the object was "deleted softly"?
8. How can you **permanently** delete an object (and its non-current versions) from a version-enabled bucket?


## Create S3 event notification to a Lambda Function

### Create a private Docker container repository in ECR, build the YoloV5 Docker container and push it


1. Open the Amazon ECR console at [https://console\.aws\.amazon\.com/ecr/repositories](https://console.aws.amazon.com/ecr/repositories)\.

2. From the navigation bar, choose the Region to create your repository in\.

3. In the navigation pane, choose **Repositories**\.

4. On the **Repositories** page, choose **Create repository**\.

5. For **Repository name**, enter a unique name for your repository\ (for example `nginx-web-app`\)\.

6. Choose **Create repository**\.

7. Select the repository that you created and choose **View push commands** to view the steps to push an image to your new repository\.

8. Following the instructions in **View push commands**, build, tag and push the Docker container specified in `img-object-detection` directory in our shared Git repo. **You must build and push the container from an EC2 instance located in the same region of your container registry**.

### Create the Lambda Function

1. Open the [Functions page](https://console.aws.amazon.com/lambda/home#/functions) of the Lambda console\.

2. Choose **Create function**\.
3. Choose **Container image** function type.

4. Under **Basic information**, do the following:

    1. For **Function name**, enter `img-object-detection-<alias>`\, while `<alias>` is your name.

    2. For **Container image URI**, click on **Browse images** and choose the container you've built.

5. Choose **Create function**\.


### Enabling Lambda notifications


1. Open the Amazon S3 console at [https://console\.aws\.amazon\.com/s3/](https://console.aws.amazon.com/s3/)\.

2. In the **Buckets** list, choose the name of the bucket that you want to enable events for\.

3. Choose **Properties**\.

4. Navigate to the **Event Notifications** section and choose **Create event notification**\.

5. In the **General configuration** section, specify descriptive event name for your event notification\. Optionally, you can also specify a prefix and a suffix to limit the notifications to objects with keys ending in the specified characters\.

    1. Enter `img-object-detect` for the **Event name**\.

    2. Filter event notifications by prefix, enter `images/`.

6. In the **Event types** section **All object create events**.

7. In the **Destination** section, choose your **Lambda Function** as the event notification destination\.
8. Choose **Save changes**, and Amazon S3 sends a test message to the event notification destination\.
9. Test your work by uploading an image into `images/`.
