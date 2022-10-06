# AWS demos

## Hello World EC2

1. Create an EC2 instance, as follows:
    1. `Amazon Linux 2 AMI` AMI.
    2. `t2.micto` instance type  (or equivalent medium type from another generation).
    3. Choose your key-pair (create if needed).
    4. In network configurations:
       1. Make sure your instance is provisioned in the default VPC. 
       2. Choose the **a** availability zone of your region. e.g. my instance will be provisioned in **us-east-1**, the AZ should be us-east-1**a**
2. Your instance should have a public ip4v address. Connect to your instance via SSH by click on **Connect** button in the instance summary page, then **SSH Client**, follow the instructions there.
3. Connect to your instance using SSH. 

## Create and mount EBS volume

1. In EC2 the navigation pane, choose **Volumes**\.

2. Choose **Create volume**\.

3. For **Volume type**, choose the type of volume to create, SSD gp2\. For more information, see [Amazon EBS volume types](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-volume-types.html).

4. For **Size**, enter the size of the volume, 10GiB\. For more information, see [Constraints on the size and configuration of an EBS volume](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/volume_constraints.html).

5. For **Availability Zone**, choose the Availability Zone in which to create the volume\. A volume can be attached only to an instance that is in the same Availability Zone\.

6. For **Snapshot ID**, keep the default value \(**Don't create volume from a snapshot**\)\.

7. Assign custom tags to the volume, in the **Tags** section, choose **Add tag**, and then enter a tag key and value pair\.

8. Choose **Create volume**\.
   **Note**  
   The volume is ready for use when the **Volume state** is **available**\.

9. To use the volume, attach it to an instance\. For more information, see [Attach an Amazon EBS volume to an instance](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-attaching-volume.html).

10. Connect to your instance over SSH.
11. [Format and mount the attached volume](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-using-volumes.html)
12. and write some data to the mounter EBS.


## Create an encrypted EBS and migrate disks

1. In KMS, [create encryption key](https://docs.aws.amazon.com/kms/latest/developerguide/create-keys.html#create-symmetric-cmk). Make sure your IAM user can administer this key and delete it.
2. [Create a volume snapshot](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-creating-snapshot.html#ebs-create-snapshot) of the EBS you provisioned and mounted in the previous section.
3. Create an **encrypted EBS from the EBS snapshot**. Use the encrypted keys you’ve just created in KMS.
4. Attach and mount the encrypted volume to your instance, as follows:
   1. Generate new UUID for the encrypted disk by:
      ```shell
      sudo xfs_admin -U generate <device-name>
      ```
   2. Copy the generated uuid, and add the following entry to `/etc/fstab`:
      ```shell
      UUID=<device-uuid>  /data  xfs  defaults,nofail  0  2
      ```
      while `<device-uuid>` is your generated device UUID.   
   
   Make sure the data from the unencrypted volume has been migrated successfully to the encrypted volume.

#### Discussion

5. In KMS page, disable your encryption key. What happened to the data in your instance?
6. Stop the machine and start it again, [what happened](https://docs.aws.amazon.com/kms/latest/developerguide/services-ebs.html#ebs-cmk) to the data in your instance?