# Vision for cncf/demo

Our evolving vision for the CNCF demo is to provide a widely referenced marketing demo using the shortest path to multi-cloud deployments.

The approach needs to be opinionated to get us to multi-cloud deployments asap, while at the same time being easy for others to understand and modify.

A [cloud-init][https://cloud-init.io/] approach is, by definition very cloud-native and can be replicated across multiple provisioning toolchains.

Terraform is well documented/maintained and [supports the aws resources we need to configure](https://www.terraform.io/docs/providers/aws/). Targeting [Azure](https://www.terraform.io/docs/providers/azure), [Google](https://www.terraform.io/docs/providers/google/), and [Packet](https://www.terraform.io/docs/providers/packet/) would require minimal code changes. Simply [templating cloud-init](https://www.terraform.io/docs/providers/template/d/cloudinit_config.html) across all those clouds which would reduce our dependency on vendor specific provisioning code. (We have also developed an approach for hardware deploys via Hanlon/PXE for CNCF Cluster)

We took some time to understand and in the process simplify the cncf/demo codebase.

You can take a look at [code.ii.coop/cncf/demo][code.ii.coop/cncf/demo]

## tl;dr
```bash
# 
$ docker run 

# build artifacts and deploy cluster
$ make all

# nodes
$ kubectl get nodes

# addons
$ kubectl get pods --namespace=kube-system

# verify dns - run after addons have fully loaded
$ kubectl exec busybox -- nslookup kubernetes

# open dashboard
$ make dashboard

# obliterate the cluster and all artifacts
$ make clean
```

## Features
* TLS certificate generation

### AWS
* [EC2 Key Pair](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html)
creation
* AWS VPC Public and Private subnets
* IAM protected S3 bucket for asset (TLS and manifests) distribution
* Bastion Host
* Multi-AZ Auto-Scaling Worker Nodes
* [NAT Gateway](http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/vpc-nat-gateway.html)

### CoreOS (1185.5.0, 1235.2.0, 1262.0.0)
* etcd DNS Discovery Bootstrap
* kubelet runs under rkt (using CoreOS recommended [Kubelet Wrapper Script](https://coreos.com/kubernetes/docs/latest/kubelet-wrapper.html))

### Kubernetes (v1.5.1)
* [Highly Available ApiServer Configuration](http://kubernetes.io/v1.1/docs/admin/high-availability.html)
* Service accounts enabled
* SkyDNS utilizing cluster's etcd

### Terraform (v0.8.2)
* CoreOS AMI sourcing
* Terraform Pattern Modules

## Prerequisites
* [docker](https://docker.io/)

## Resulting Cluster

- client and server TLS assets
- s3 bucket for TLS assets (secured by IAM roles for master and worker nodes)
- AWS VPC with private and public subnets
- Route 53 internal zone for VPC
- Etcd cluster bootstrapped from Route 53
- High Availability Kubernetes configuration (masters running on etcd nodes)
- Autoscaling worker node group across subnets in selected region
- kube-system namespace and addons: DNS, UI, Dashboard

#### ElasticSearch and Kibana

To access Elasticseach and Kibana first start `kubectl proxy`.

```bash
$ kubectl proxy
Starting to serve on localhost:8001
```

* [http://localhost:8001/api/v1/proxy/namespaces/kube-system/services/elasticsearch-logging ](http://localhost:8001/api/v1/proxy/namespaces/kube-system/services/elasticsearch-logging)
* [http://localhost:8001/api/v1/proxy/namespaces/kube-system/services/kibana-logging](http://localhost:8001/api/v1/proxy/namespaces/kube-system/services/kibana-logging)

