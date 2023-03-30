# Kubernetes Tutorial Part II

## Elastic Kubernetes Service (EKS)

Follow the below docs to create a cluster using the management console:  
https://docs.aws.amazon.com/eks/latest/userguide/create-cluster.html

In order to get the kubeconfig content and connect to an EKS cluster, you should execute the following `aws` command from your local machine:

```shell
aws eks --region <region> update-kubeconfig --name <cluster_name>
```

Change `<region>` and `<cluster_name>` accordingly.


### Install and connect through OpenLens

https://github.com/MuhammedKalkan/OpenLens

### Install Ingress and Ingress Controller on EKS

[Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/#what-is-ingress) exposes HTTP and HTTPS routes from outside the cluster to services within the cluster.
An Ingress may be configured to give Services externally-reachable URLs, load balance traffic, terminate SSL / TLS, and offer name-based virtual hosting.
In order for the **Ingress** resource to work, the cluster must have an **Ingress Controller** running.

Kubernetes supports and maintains AWS, GCE, and [nginx](https://github.com/kubernetes/ingress-nginx) ingress controllers.

1. If working on a shared repo, create your own namespace by:
   ```shell
   kubectl create ns <my-ns-name>
   ```
2. **In your namespace**, Deploy the following Docker image as a Deployment, with correspond Service: [`alexwhen/docker-2048`](https://hub.docker.com/r/alexwhen/docker-2048).
3. Deploy the Nginx ingres controller (done only **once per cluster**). We will deploy the [Nginx ingress controller behind a Network Load Balancer](https://kubernetes.github.io/ingress-nginx/deploy/#aws) manifest.

We want to access the 2048 game application from a domain such as http://test-2048.int-devops-may22.com

4. Add a subdomain A record for the [int-devops-may22.com](https://us-east-1.console.aws.amazon.com/route53/v2/hostedzones#ListRecordSets/Z04765852WWE8ZAF7TX92) domain (e.g. test-2048.int-devops-may22.com). The record should have an alias to the NLB created by EKS after the ingress controller has been deployed.
5. Inspired by the manifests described in [Nginx ingress docs](https://kubernetes.github.io/ingress-nginx/user-guide/basic-usage/#basic-usage-host-based-routing), create and apply an Ingress resource such that when visiting your registered DNS, the 2048 game will be displayed on screen.


[comment]: <> (## Configure a Pod to Use a Volume for Storage)

[comment]: <> (Follow:  )

[comment]: <> (https://kubernetes.io/docs/tasks/configure-pod-container/configure-volume-storage/)

[comment]: <> (### Further reading and doing)

[comment]: <> (- Familiarize yourself with the material in [Volumes]&#40;https://kubernetes.io/docs/concepts/storage/volumes/&#41;)

[comment]: <> (- [Communicate Between Containers in the Same Pod Using a Shared Volume]&#40;https://kubernetes.io/docs/tasks/access-application-cluster/communicate-containers-same-pod-shared-volume/&#41;)


[comment]: <> (## Configure a Pod to Use a PersistentVolume for Storage)

[comment]: <> (Follow:  )

[comment]: <> (https://kubernetes.io/docs/tasks/configure-pod-container/configure-persistent-volume-storage/)


[comment]: <> (## Run a Single-Instance Stateful Application)

[comment]: <> (Follow:  )

[comment]: <> (https://kubernetes.io/docs/tasks/run-application/run-single-instance-stateful-application/)

[comment]: <> (## Run a Replicated Stateful Application)

[comment]: <> (Follow:)

[comment]: <> (https://kubernetes.io/docs/tasks/run-application/run-replicated-stateful-application/)


## Helm

Helm is the package manager for Kubernetes.
The main big 3 concepts of helm are:

- A **Chart** is a Helm package. It contains all the resource definitions necessary to run an application, tool, or service inside of a Kubernetes cluster.
- A **Repository** is the place where charts can be collected and shared.
- A **Release** is an instance of a chart running in a Kubernetes cluster.

[Install](https://helm.sh/docs/intro/install/) the Helm cli if you don't have.

You can familiarize yourself with this tool using [Helm docs](https://helm.sh/docs/intro/using_helm/).

### Deploy MySQL using Helm

How relational databases are deployed in real-life applications?

The following diagram shows a Multi-AZ DB cluster.

![](../docs/img/mysql-multi-instance.png)

With a Multi-AZ DB cluster, MySQL replicates data from the writer DB instance to both of the reader DB instances.
When a change is made on the writer DB instance, it's sent to each reader DB instance.
Acknowledgment from at least one reader DB instance is required for a change to be committed.
Reader DB instances act as automatic failover targets and also serve read traffic to increase application read throughput.

Once you have Helm ready, you can add a chart repository. Check [Artifact Hub](https://artifacthub.io/packages/search?kind=0).

Let's review the Helm chart written by Bitnami for MySQL provisioning in k8s cluster.

[https://github.com/bitnami/charts/tree/master/bitnami/mysql/#installing-the-chart](https://github.com/bitnami/charts/tree/master/bitnami/mysql/#installing-the-chart)

1. Add the Bitnami Helm repo to your local machine:
```shell
# or update if you have it already: `helm repo update bitnami`
helm repo add bitnami https://charts.bitnami.com/bitnami
```
2. First let's install the chart without any changes
```shell
# helm install <release-name> <repo-name>/<chart-name> 
helm install mysql bitnami/mysql
```

Whenever you install a chart, a new release is created. So one chart can be installed multiple times into the same cluster. And each can be independently managed and upgraded.

During installation, the helm client will print useful information about which resources were created, what the state of the release is, and also whether there are additional configuration steps you can or should take.

You can always type `helm list` to see what has been released using Helm.

Now we want to customize the chart according to our business configurations.
To see what options are configurable on a chart, use `helm show values bitnami/mysql` or even better, go to the chart documentation on GitHub.

We will pass configuration data during the chart upgrade by specify a YAML file with overrides (`-f custom-values.yaml`). This can be specified multiple times and the rightmost file will take precedence.

3. Review `mysql-helm/values.yaml`, change values or [add parameters](https://github.com/bitnami/charts/tree/master/bitnami/mysql/#parameters) according to your need.
4. Upgrade the `mysql` chart by
```shell
helm upgrade -f mysql-helm/values.yaml mysql bitnami/mysql
```

An upgrade takes an existing release and upgrades it according to the information you provide. Because Kubernetes charts can be large and complex, Helm tries to perform the least invasive upgrade. It will only update things that have changed since the last release.

If something does not go as planned during a release, it is easy to roll back to a previous release using `helm rollback [RELEASE] [REVISION]`:

```shell
helm rollback mysql 1
```

5. To uninstall this release:
```shell
helm uninstall mysql
```

## Stream Pod logs to Elasticsearch databases using FluentD

### Fluentd introduced

[Fluentd](https://www.fluentd.org/) is an open source data collector for unified logging layer.
Fluent allows you to unify data collection and consumption for a better use and understanding of data.

Here is an illustration of how Fluent works in the k8s cluster:

![](../docs/img/fluent.png)

Fluentd runs in the cluster as a [DaemonSet](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/). A DaemonSet ensures that all **nodes** run a copy of a **pod**. That way, Fluentd can collect log information from every containerized applications easily in each k8s node.

We will deploy the Fluentd chart to collect containers logs to send them to [Elasticsearch](https://www.elastic.co/what-is/elasticsearch) database.

1. Visit the Fluentd Helm chart at https://github.com/fluent/helm-charts/tree/main/charts/fluentd
2. Add the helm repo
```shell
# or update if you have it already: `helm repo update fluent`
helm repo add fluent https://fluent.github.io/helm-charts
```

3. Install the Fluentd chart by:
```shell
helm install fluentd fluent/fluentd
```

4. Watch and inspect the running containers under **Workloads** -> **DaemonSet**. Obviously, it doesn't work, as Fluent need to talk to an existed Elasticsearch database.
5. Elasticsearch db can be provisioned by applying `elasticsearch.yaml`.
6. Create a YAML file called `fluentd-helm-values.yaml`. You should override the [following](https://github.com/fluent/helm-charts/blob/main/charts/fluentd/values.yaml#L379) default Helm values, by:
```yaml
fileConfigs:
  04_outputs.conf: |-
    <label @OUTPUT>
      <match **>
        @type elasticsearch
        host "<elasticsearch-host>"
        logstash_format true
        port <elasticsearch-port>
      </match>
    </label>
```
While replacing `<elasticsearch-host>` and `<elasticsearch-port>` with the hostname of Elasticsearch int the cluster.
7. Finally, upgrade the `fluentd` release by `helm upgrade -f elastic-fluent/fluentd-helm-values.yaml fluentd fluent/fluentd`


### Visualize logs with Grafana

1. Review the objects in `grafana.yaml` and apply.
2. Visit grafana service (default username and password is `admin`) and configure the Elasticsearch database to view all cluster logs.


### Fluentd permissions in the cluster

Have you wondered how does the Fluentd pods have access to other pods logs!?

This is a great point to learn something about k8s role and access control mechanism ([RBAC](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)).

#### Role and ClusterRole

_Role_ or _ClusterRole_ contains rules that represent a set of permissions on the cluster (e.g. This Pod can do that action..).
A Role always sets permissions within a particular _namespace_
ClusterRole, by contrast, is a non-namespaced resource.

#### Service account

A _Service Account_ provides an identity for processes that run in a Pod.
When you create a pod, if you do not specify a service account, it is automatically assigned the `default` service account in the same namespace.

#### RoleBinding and ClusterRoleBinding

A role binding grants the permissions defined in a role to a user or set of users.
A RoleBinding may reference any Role in the same namespace. Alternatively, a RoleBinding can reference a ClusterRole and bind that ClusterRole to the namespace of the RoleBinding.

---

Observe the service account used by the fluentd Pods, observe their ClusterRole bound to them.


## Prometheus on K8S

[Prometheus](https://prometheus.io/docs/introduction/overview/) Prometheus is a monitoring platform that collects metrics from monitored targets by scraping metrics HTTP endpoints on these targets.
Prometheus is shipped with an extensive list of [exporters](https://prometheus.io/docs/instrumenting/exporters/). An exporter is a pluggable piece which allow Prometheus to collect metrics from other system (e.g. databases, cloud services, OS etc..). Some exporters are official, others developed by the community.

Note: If using a shared k8s cluster, **deploy all resources in your own namespace**!

1. Deploy Prometheus using the [community Helm chart](https://github.com/prometheus-community/helm-charts/tree/main/charts/prometheus).
2. Deploy Grafana (either by Helm or by the manifest under `21_k8s/elastic-fluent/grafana.yaml`).
3. Connect to Grafana (you can utilize the installed Ingress controller or by `kubectl port-forward`).
4. Configure the Prometheus server as a data source.
5. Import one of the following dashboards:
    - https://grafana.com/grafana/dashboards/6417-kubernetes-cluster-prometheus/
    - https://grafana.com/grafana/dashboards/315-kubernetes-cluster-monitoring-via-prometheus/
    - https://grafana.com/grafana/dashboards/12740-kubernetes-monitoring/
6. Deploy the [Prometheus Cloudwatch Exporter](https://github.com/prometheus-community/helm-charts/tree/main/charts/prometheus-cloudwatch-exporter).
7. Configure Prometheus to scrape metrics from Cloudwatch Exporter (you may find helpful values under `prometheus/values.yaml`).
