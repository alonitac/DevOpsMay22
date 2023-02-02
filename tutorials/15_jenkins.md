# CI/CD with Jenkins

## What is CI/CD?

CI/CD stands for Continuous Integration/Continuous Deployment.
In  short, the CI/CD process involves the following steps:

1. Code: Developers commit and push their code changes to a shared repository.
2. Build: The code is automatically built into a deployable **artifact**, such as a binary or a Docker image.
3. Test: Automated tests are run to validate the build and catch any issues.
4. Deploy: The build is automatically deployed to a **test or dev environment** for further testing and to validate that the changes are integrated with other systems.
5. Release: If the tests pass, the build is (automatically??) released to **production**.

The goal of the CI/CD process is to automate the software development lifecycle, from code to deployment, to increase efficiency and speed while maintaining high software quality.

# Jenkins 

**Jenkins** is an open-source tool that is commonly used to automate the CI/CD process.

## Install Jenkins on EC2

Jenkins is typically run as a standalone application in its own process with the built-in Java servlet container/application.

1. Create a ***.small, Amazon Linux** EC2 instance with `20GB` disk.
2. Connect to your instance, execute `sudo yum update && sudo amazon-linux-extras install epel -y`
3. Download and install Jenkins as described [here](https://www.jenkins.io/doc/tutorials/tutorial-for-installing-jenkins-on-AWS/#downloading-and-installing-jenkins) (no need to install the EC2 plugin).
4. On Jenkins' machine, [install Docker engine](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/create-container-image.html#create-container-image-prerequisites). You may want to add jenkins linux user the docker group, so Jenkins could run docker commands:
   ```shell
   sudo usermod -a -G docker jenkins
   ```
5. Install Git.
6. Create an Elastic IP and associate it to your Jenkins instance.
7. Open port `8080` and visit your Jenkins server via `http://<static-ip>:8080` and complete the setup steps.
8. In the **Dashboard** page, choose **Manage Jenkins**, then **Manage Plugins**. In the **Available** tab, search and install **Blue Ocean** and **Docker Pipeline** plugins. Then restart jenkins by `http://<ip>:8080/safeRestart`

## Create a GitHub repository with a `Jenkinsfile` in it

A **Jenkins pipeline** is a set of automated steps defined in a `Jenkinsfile` (usually in the code repository) that tells Jenkins what to do in each step of your CI/CD pipeline. 

The `Jenkinsfile`, written in Groovy, has a specific syntax and structure, and it is executed within the Jenkins server.
The pipeline typically consists of multiple **stages**, each of which performs a specific **steps**, such as building the code as a Docker image, running tests, or deploying the software to Kubernetes cluster.

1. Create a new GitHub repository for which you want to integrate Jenkins.
2. In your repository, in branch `main`, create a `Jenkinsfile` in the root directory as the following template:

```text
pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                sh 'echo building...'
            }
        }
    }
}
```

3. Commit and push your changes.

A GitHub webhook is a mechanism that allows GitHub to notify a Jenkins server when changes occur in the repo. 
When a webhook is configured, GitHub will send a HTTP POST request to a specified URL whenever a specified event, such as a push to the repository, occurs.

4. To set up a webhook from GitHub to the Jenkins server, on your GitHub repository page, go to **Settings**. From there, click **Webhooks**, then **Add webhook**.
5. In the **Payload URL** field, type `http://<jenkins-ip>:8080/github-webhook/`. In the **Content type** select: `application/json` and leave the **Secret** field empty.
6. Choose the following events to be sent in the webhook:
    1. Pushes
    2. Pull requests

## Define the Pipeline in Jenkins server

1. From the main Jenkins dashboard page, choose **New Item**.
2. Enter `AppBuild` as the project name, and choose **Pipeline**.
3. Check **GitHub project** and enter the URL of your GitHub repo.
4. Under **Build Triggers** check **GitHub hook trigger for GITScm polling**.
5. Under **Pipeline** choose **Pipeline script from SCM**.
6. Choose **Git** as your SCM, and enter the repo URL.
7. If you don't have yet credentials to GitHub, choose **Add** and create **Jenkins** credentials.
   1. **Kind** must be **Username and password**
   2. Choose informative **Username** (as **github** or something similar)
   3. The **Password** should be a GitHub Personal Access Token with the following scope:
      ```text
      repo,read:user,user:email,write:repo_hook
      ```
      Click [here](https://github.com/settings/tokens/new?scopes=repo,read:user,user:email,write:repo_hook) to create a token with this scope.
   4. Enter `github` as the credentials **ID**.
   5. Click **Add**.
8. Under **Branches to build** enter `main` as we want this pipeline to be triggered upon changes in branch main.
9. Under **Script Path** write the path to your `Jenkinsfile` defining this pipeline.
10. **Save** the pipeline.
11. Test the integration by add a [`sh` step](https://www.jenkins.io/doc/pipeline/tour/running-multiple-steps/#linux-bsd-and-mac-os) to the `Jenkinsfile`, commit & push and see the triggered job.

