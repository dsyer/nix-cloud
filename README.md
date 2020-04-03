```
$ nix-shell
       _                 _   
 _ ___| | ___  _   _  __| |_ 
(_) __| |/ _ \| | | |/ _` (_)
 | (__| | (_) | |_| | (_| |_ 
(_)___|_|\___/ \__,_|\__,_(_)
                             

Terraform v0.12.23
...
$ terraform init
$ terraform validate
```

Create a VM and log in

```
$ terraform apply -auto-approve
$ gcloud compute instances list
NAME        ZONE            MACHINE_TYPE                 PREEMPTIBLE  INTERNAL_IP  EXTERNAL_IP  STATUS
test        us-central1-a   n1-standard-1                             10.128.0.62  34.71.25.65  RUNNING
$ ssh -i ~/.ssh/google_compute_engine 34.71.25.65
dsyer@test$ 
```