Create local environment (if you don't have `terraform` already):

```
$ nix-shell
       _                 _   
 _ ___| | ___  _   _  __| |_ 
(_) __| |/ _ \| | | |/ _` (_)
 | (__| | (_) | |_| | (_| |_ 
(_)___|_|\___/ \__,_|\__,_(_)
                             

Terraform v0.12.23
...
```

Initialize and make sure the configuration is clean:

```
$ terraform init
$ terraform validate
```

Create a VM and log in (you will need to replace the GCP project ID):

```
$ terraform apply -auto-approve
Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

instance_ip = 35.197.203.4
```

You can verify with `gcloud` that the instance is running:

```
$ gcloud compute instances list
NAME        ZONE            MACHINE_TYPE                 PREEMPTIBLE  INTERNAL_IP  EXTERNAL_IP  STATUS
test        europe-west2-c  n1-standard-1                             10.154.0.8   35.197.203.4  RUNNING
$ ssh -i ~/.ssh/google_compute_engine `terraform output instance_ip`
dsyer@test$ 
```

Unfortunately you can't use Terrafrom to [stop an instance](https://github.com/terraform-providers/terraform-provider-aws/issues/22) so you have to go to `gcloud` to do that:

```
$ gcloud compute instances stop --zone europe-west2-c test
Stopping instance(s) test...
```

You can, however, destroy the resource completely:

```
$ terraform destroy -auto-approve
...
Destroy complete! Resources: 1 destroyed.
```