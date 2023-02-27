# CI/CD with Jenkins

**Due date: 15/04/2023**

In this exercise you will implement a full CI/CD process for the TelegramAI service in Development and Production environments. 

All the code in this exercise is already given to you in the [TelegramAI-CICD repo](https://github.com/alonitac/TelegramAI-CICD.git), `main` branch. So no need to write any Python. Fork this repo and work on your fork along the exercise.


## Deploy k8s cluster

You will deploy a single-node k8s cluster using a very lightweight distro of Kubernetes called [k0s](https://k0sproject.io/).

1. Create an **Amazon Linux** EC2 `medium` instance. Since Jenkins will communicate with k8s using the EC2 instance's private IP, **they both have to reside in the same VPC**!
2. Connect to your instance, install the cluster by:

```shell
curl -o ecr-creds-helper.yaml https://raw.githubusercontent.com/alonitac/DevOpsMay22/main/cicd_ex_helpers/ecr-creds-helper.yaml
curl https://raw.githubusercontent.com/alonitac/DevOpsMay22/main/cicd_ex_helpers/init.sh | bash -e
```

You can always re-run the above lines to re-install a fresh k0s cluster.

4. Keep the _dashboard url_, and the _login token_ printed on screen. We will use them later on.
5. Your EC2 instance in which the k8s cluster is running needs the appropriate permissions, i.e. S3, SQS, etc... Specifically, it must have read permissions for your ECR registries. In addition, you should open the following ports:
   - `30001` for accessing the k8s dashboard.
   - `6443` to communicate with the k8s api server.
6. Both Development and Production environments will be running on the same k8s cluster in 2 different namespaces. From your EC2 terminal, create Kubernetes namespaces for each env:
```shell
$ kubectl create namespace dev
>> namespace/dev created

$ kubectl create namespace prod
>> namespace/prod created
```

## Create resources for multiple environments

Since the TelegramAI service is going to be deployed in two different (and potentially isolated) environments (dev and prod), 
each env has to have its own resources in AWS. 
But first and most, **you need to create another Telegram bot**.
At the end of the process, you should hold two different Telegram tokens - one for the bot used in `dev` env, and the other, for the bot that will be used in `prod` env (the bot that your customers have access to).
Thus, you need to store the new Telegram bot token as a secret in Amazon Secrets Manager, as you did with the existed token. 
Furthermore, you need another SQS queue, and another S3 bucket. 
**No need to create another Autoscaling Group or Launch Template since in this exercise we don't mind scalability at all.** 

To summarize:

- Use your existed Telegram token (and aws resources) for the `dev` env.
- Create another Telegram bot that will be used by `prod` env. Store the new token in AWS Secrets manager.
- Create another SQS and S3 bucket for the new bot. 

After creating the resources, in the project repo, edit `config-dev.json` and `config-prod.json` accordingly. 

## Prepare the Jenkins server

Perform the following steps on your existed Jenkins server. 

1. In your Jenkins server, create `dev` and `prod` folders (New Item -> Folder). All pipelines will be created in those folders.  
2. Jenkins needs to talk with the k8s cluster in order to deploy the applications. It does so using the Kubernetes command-line tool, `kubectl`. To configure `kubectl` to work with your k8s cluster, create in Jenkins a **Secret file** credentials called `kubeconfig` in the Jenkins global scope. The secret file content can be found in the EC2 you've installed the k8s cluster under `~/.kube/config`. You can copy & paste this file's content to your local machine and upload to Jenkins.
3. All pipelines are running on a containerized agent (the same Docker image for all pipelines). The agent's Dockerfile can be found under `infra/jenkins/JenkinsAgent.Dockerfile`. You should complete the `TODO` inside the Dockerfile, which is installing `kubectl` cli tool inside the image, then build and push it to an ECR registry, and replace `<jenkins-agent-image>` with your Docker image URI in each Jenkinsfile.

**Note:** no need to run agents on different **nodes**! All pipelines can be running on the Jenkins server itself.


## The Dev and Prod Jenkins pipelines 

Read the following guidelines carefully **before** you start the implementation! 
Create the following pipelines in Jenkins and complete the corresponding Jenkinsfiles:


### The `dev` folder pipelines

In your Jenkins server, the following pipelines should be created under `dev` folder:

- The `botBuild` Pipeline - responsible to build the Bot app. The Jenkinsfile is partially implemented under `infra/jenkins/dev/BotBuild.Jenkinsfile`. Complete the `TODO`s. This pipeline should be triggered upon changes in `bot/` directory or any other file you may find related to the bot app.
- The `botDeploy` Pipeline - responsible to deploy the Bot app. The Jenkinsfile is partially implemented under `infra/jenkins/dev/BotDeploy.Jenkinsfile`. You should create the k8s YAML manifest for the Bot app and replace `<path-to-bot-yaml-k8s-manifest>` with your YAML file (create k8s YAMLs under `infra/k8s`).
- The `workerBuild` Pipeline - responsible to build the Worker app. The Jenkinsfile configured under `infra/jenkins/dev/WorkerBuild.Jenkinsfile`. You should implement it. This pipeline should be triggered upon changes in `worker/` directory or any other file you may find related to the worker app.
- The `workerDeploy` Pipeline - responsible to deploy the Worker app. The Jenkinsfile is partially implemented under `infra/jenkins/dev/WorkerDeploy.Jenkinsfile`.

#### Notes for `dev` pipelines

1. Implement the pipelines in branch `dev` (create it from `main`).
2. All `dev` pipelines should be triggered from a Git branch `dev`.
3. In `dev` env, `botBuild` and `workerBuild` should automatically trigger the `botDeploy` and `workerDeploy` pipelines accordingly (see **Trigger Deploy** stages in the Jenkinsfiles).
4. To trigger a pipeline only upon changes to a given directory, in the pipeline configuration page in Jenkins, under **Additional Behaviours** section, choose **Polling ignores commits in certain paths**. In the **Included Regions** textbox, enter your paths, line by line.
5. `BotDeploy` and `WorkerDeploy` pipelines use `telegram-bot-token` and `kubeconfig` credentials, make sure you have them configured.
6. You should create yourself the k8s YAML manifest for the Worker app. 

### The `prod` folder

Similar to `dev` pipelines, the following pipelines should be located under `prod` folder:

- The `botBuild` Pipeline - The Jenkinsfile is partially implemented under `infra/jenkins/prod/BotBuild.Jenkinsfile`. 
- The `botDeploy` Pipeline - The Jenkinsfile is partially implemented under `infra/jenkins/prod/BotDeploy.Jenkinsfile`. 
- The `workerBuild` Pipeline - The Jenkinsfile is partially implemented under `infra/jenkins/prod/WorkerBuild.Jenkinsfile`. 
- The `workerDeploy` Pipeline - The Jenkinsfile is partially implemented under `infra/jenkins/prod/WorkerDeploy.Jenkinsfile`.
- The `PullRequestTesting` Pipeline -  responsible to execute PR testing before code is being merged to `main` branch. The Jenkinsfile is configured under `infra/jenkins/prod/PullRequest.Jenkinsfile`. This is a **Multi-branch pipeline** that should be triggered upon Pull Request creation as we've seen in class. Make sure that a given PR is blocked from being merged into main when this pipeline fails. **Already implemented**, no need to touch.


#### Notes for `prod` pipelines

1. Implement the pipelines in branch `main` (tip: at that point it might help to merge branch `dev` into `main` so you'll have the Jenkinsfiles you've implemented for `dev` env as a reference).
2. All `prod` pipelines should be triggered from a Git branch `main`.
3. In Prod env, `botBuild` and `workerBuild` should **not** trigger the `botDeploy` and `workerDeploy` pipelines automatically. The Deploy pipelines should be triggered manually (In the pipeline configurations, choose **This project is parameterized**, then either **String Parameter** or **Run Parameter** may help).
4. At the end of `prod` pipelines implementation, you should protect branch `main` from pushing code into it, as we did in class. New code can be merged only through a Pull Request.
5. Make sure the `Warnings Next Generation` plugin is installed on your Jenkins server. In the builds of `PullRequestTesting`, you can click on the **Pylint warnings** page to get some insights regarding PyLint errors.


### Deploy a new change

1. From branch `main`, checkout a new feature branch (e.g. `feature/greeting_msg`).
2. Make some change to the bot code, for example add a greeting message for the users.
3. Commit your change.
4. Test your change in `dev` env, checkout `dev` branch, and merge `feature/greeting_msg` into `dev`.
5. Push `dev`. Make sure the pipelines are running, and the change has been deployed to Dev (talk with the dev bot to check the change). 
6. Everything is good? time to deploy to Production. Create a PR from `feature/greeting_msg` into `main`. Let Jenkins run the PR testing, if needed (and you'll need...), fix some code so Jenkins will approve your PR. Ask a friend to review the code (or review it yourself). Finally, complete the PR. 
7. Make sure the `prod/BotBuild` pipeline is running, and trigger `prod/BotDeploy` manually. Check that the change in prod bot has been deployed. 

Make sure you understand the above process, repeat it again if needed.  

### Submission 

The course staff will review your forked repo.

# Good Luck

Don't hesitate to ask any questions
