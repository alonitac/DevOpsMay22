# AWS Ex1 - Provision the TelegramAI app in AWS

**Can be done in pairs (highly recommended)**.

## Background

Your goal is to provision the TelegramAI chat app as a scalable, micro-services architecture in AWS.

Here is a high level diagram of the architecture:

![](img/botaws2.png)

The general idea of scale

When end-users send a message via Telegram app (1-black), the messages are served by the Bot service (run as a Docker container in the Telegram Bot EC2 instance).
The Bot service **doesn't** download the video from YouTube itself, otherwise, all it does is sending a "job" to an SQS queue (2-black), and return the end-user a message like "your video is being downloaded...".
So, the Bot service is a very lightweight app that can serve hundreds requests per seconds. 
In the other side, there are Worker service (run as a Docker container in the Worker EC2 instance) **consumes** jobs from the SQS queue (3-black) and does the hard work - to download the video from YouTube and upload it to S3 (4-black). When the Worker done with current job, it asks the SQS queue if it has another job for him. As long as there are jobs pending in the queue, a free Worker will consume and perform the job. In such way the Bot service pushes jobs to the SQS queue, making it "full", while the Worker service consumes jobs from the queue, making it "empty".

But what if the rate in which the Bot service is pushing jobs to the queue is much higher than the rate the Worker completing jobs? In such case the queue will overflow...
To solve that, we will create multiple workers that together consume jobs from the queue. How many workers? we will deploy a dynamic model **that auto-scale the number of workers** depending on the number of messages in the queue. When there are a lot of jobs in the queue, the autoscaler will provision many workers. When there are only a few jobs in the queue, the autoscaler will provision fewer workers.
The Workers are part of an AutoScaling group, which is scaled in and out by a custom metric that the Metric Sender service (run as a Docker container in a Lambda function) writes to CloudWatch (2-blue) every 3 minutes (1-blue). CloudWatch will trigger an autoscale event (3-blue) when needed, which results in provisioning of another Worker instance, or terminate a redundant Worker instance (4-blue). 

The metric sent to CloudWatch can be called `BacklogPerInstance`, as it represents the number of jobs in the queue (jobs that was not consumed yet) per Worker instance.
For example, assuming you have 5 workers up and running, and 100 messages in the queue, thus `BacklogPerInstance` equals 20, since each Worker instance has to consume ~20 messages to get the queue empty. For more information, read [here](https://docs.aws.amazon.com/autoscaling/ec2/userguide/as-using-sqs-queue.html).

In the [TelegramAI](https://github.com/alonitac/TelegramAI) repo, review `microservices` branch. This branch contains the code for the following services:

1. `bot/app.py` - the Telegram bot you've implemented in the previous exercise (the code solution is there, no need to bring your own code). But this time, the bot doesn't download the videos itself, but sends a "job" to an SQS queue.
2. `worker/app.py` - the worker service continuously reads messages from the SQS queue and process them, which means download the video from YouTube and store it in a dedicated S3 bucket.
3. `metric-sender/app.py` - 

## Guidelines

1. Create a VPC with at least 2 public subnets (no need to create a private subnet).

2. Create an S3 bucket which will store the uploaded YouTube videos.

3. Create an SQS standard queue. Jobs that was not processed yet should reside in the queue for a maximum period of 4 days. The worker has a maximum period of 30 minutes to process a single job.

4. Create a Launch Template and an AutoScaling Group. Keep the default configurations, we will change it later. The **Minimum and Desired** capacity of the ASG should be **zero**.

[comment]: <> (5. You are given most of the code for the bot and worker services. In branch `microservices` complete the following *TODO*s:)

[comment]: <> (    1. In `worker.py` complete the implementation of `process_msg&#40;&#41;` function such that the downloaded videos will be uploaded to S3 &#40;you can delete them from the disk afterwards&#41;.)

[comment]: <> (    2. In `utils.py` complete `calc_backlog_per_instance&#40;&#41;` such that the value of variable `backlog_per_instance` will be sent as a metric to [CloudWatch]&#40;https://boto3.amazonaws.com/v1/documentation/api/latest/guide/cw-example-metrics.html#publish-custom-metrics&#41;.)

[comment]: <> (    3. Change `config.json` according to your resources in AWS.)

[comment]: <> (   Except the above two changes, you don't need to change the code &#40;unless you want to add more functionality to the service&#41;.)

[comment]: <> (6. After you've implemented the code changes, it is good idea to test everything locally. Run the `bot.py` service and a single worker `worker.py`. Make sure that when you send a message via Telegram, the Bot service produces a message to the SQS queue, and the Worker consumes the message, downloads the YouTube video and uploads it to S3.)

[comment]: <> (7. Deploy the Worker service to an EC2 instance &#40;you can run it as a container the same way you did in the last exercise&#41;. Create an AMI from that instance and base your Launch Template on that AMI, such that when a new instance is created from the launch template, the worker app in the VM will be up and running automatically.)

[comment]: <> (8. Deploy the Bot service on a single EC2 instance &#40;this service is not part of the autoscaling group&#41;. It should be very similar to the deployment you've done in the previous exercise - in a docker container that restarts automatically on OS reboot.)

[comment]: <> (9. Use AWS cli to create a [target tracking scaling policy]&#40;https://docs.aws.amazon.com/autoscaling/ec2/userguide/as-using-sqs-queue.html#create-sqs-policies-cli&#41; in your Autoscaling Group. `MetricName` and `Namespace` should correspond to the metric your Bot service is firing to CloudWatch. Give the `TargetValue` some value that you can test later &#40;e.g. 10, which means if there are more than 10 messages per worker in the SQS queue, a scale up event will trigger&#41;.)

[comment]: <> (10. Make sure your services are given restrictive IAM role permissions.)

[comment]: <> (11. Test your application under load.)

## Submission

Present you work in a personal meeting (usually 20 minutes before our bi-weekly class). **Final due date is 30/01/23**.

# Good Luck

Don't hesitate to ask any questions