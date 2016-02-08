
+++
date = "2016-02-07T07:55:50+01:00"
draft = false
title = "Running a single node kubelet on gcloud"
category = ["devops"]
tags = ["kubernetes", "gcloud"]

+++


## RATIONALE

Start a single node kubelet, with a pod definition, as described here:

https://cloud.google.com/compute/docs/containers/container_vms

It can be useful for projects that need to lanuch single projects 
as entites..


### Create Instance

```
gcloud compute instances create containervm-test \ 
    --image container-vm --metadata-from-file \
    google-container-manifest=demo.yaml \
    --zone europe-west1-d --machine-type f1-micro \
    --scopes compute-rw,storage-rw,monitoring
```

### Test if installation is working

```
gcloud compute ssh containervm-test
sudo docker ps
```

### Open firewall

```
gcloud compute firewall-rules create sample-http --allow tcp:80
```

### Cleanup all

```
gcloud compute instances delete containervm-test
```


### What can contain a demo.yaml

A Pod definition, as in kubernetes.


### What are the costs of a f1-micro with a SSD 10G HD

6.3$/month

https://cloud.google.com/products/calculator/#id=ed0c925f-b897-484d-9a6e-c02a010649ff


