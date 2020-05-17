![Validate Packer Template](https://github.com/REDtalks/hashistack-aws-packer/workflows/Validate%20Packer%20Template/badge.svg?branch=validate)

![Build & Deploy Packer Template](https://github.com/REDtalks/hashistack-aws-packer/workflows/Build%20&%20Deploy%20Packer%20Template/badge.svg)

# hashistack-aws-packer
Repo for maintaining AWS AMI's via GitHub Actions 

## Workflow

**VALIDATE**
1. A `git push` to the 'validate' branch triggers a Github Action
2. The GitHub Action pulls the offical HashiCorp Packer docker image which is used to 'validate' the template.

**BUILD & DEPLOY**

1. A 'pull request' to the 'master' branch triggers a GitHub Action
2. The GitHub Action pulls the offical HashiCorp Packer docker image which is used to 'build' the template.
3. Using the AWS KEY and AWS SECRET passed in by the GitHub Action, Packer deploys the AMI's to the specified AWS regions.


# NOTES

## Official HashiCorp Packer Docker Container

Located: https://hub.docker.com/r/hashicorp/packer/

The GitHub Action is essentially running the following command, and passing in the template name:

```
docker run -it hashicorp/packer:light [validate|build] <template_name.json>
```

## To Persist or Overwriting AMIs

### Persist AMIs

To persist your AMI's simply using a unique name with, for example, a timestamp.

```json
  "ami_name": "mybuild {{timestamp}}",
```

Or, for something human readable:

```json
  "ami_name": "mybuild-{{isotime | clean_resource_name}}"
```

will become `mybuild-2017-10-18t02-06-30z`

NOTE: `clean_resource_name` will ensure that *special characters* which are incompatible with various cloud platforms are NOT used. Learn more about the Packer Template Engine here: https://www.packer.io/docs/templates/engine/


If you are creating unique AMi names, e.g. `` then you won't experience any name conflicts and previous AMI's will be untouches each time you deploy. However, if you *want* to overwrite existing AMI's there are two steps you must follow:

1. use a name that will conflict with previous builds
2. permit the deregistering and deletion of the previous AMI with the same name

### Overwrite AMIs

### 1. Use a common name

Removing the timestamp from the example above will ensure that the AMI's are generated with the same name each time, causing the desired 'name conflict' with previous builds.

### 2. Allow overwritting

Add the following to your AWS 'Builder'

```json
  "force_deregister": "true",
  "force_delete_snapshot": "true",
```


## AWS Regions

Below you will see both `"region": ""` and `"ami_regions": ""`

`"region":` refers to the region in which Packer will create an AMI Instance for the purpose of 'building' the AMI's. This region informs Packer where to do the building, which you can see in your "EC2 Instances" list as it runs. The Instance is automatically deleted when complete.
`"ami_regions":` refers to the AWS regions to which the AMI should be deployed for use once built.

Below is an example of specifying multiple regions using Packer 'array values' with `variable.destination_regions` at the top, and inputing that into the builder with ``"ami_regions": "{{user `destination_regions`}}",``

More on Packer 'user-variables' can be found here:
https://www.packer.io/docs/templates/user-variables/

```json
{
  "variables": {
    "destination_regions": "us-west-1,us-west-2"
  },
  "builders": [
    {
      "ami_name": "packer-qs-{{timestamp}}",
      "instance_type": "t2.micro",
      "region": "us-west-1",
      "source_ami_filter": {
        "filters": {
          "name": "*ubuntu-xenial-16.04-amd64-server-*",
          "root-device-type": "ebs",
          "virtualization-type": "hvm"
        },
        "most_recent": true,
        "owners": ["099720109477"]
      },
      "ami_regions": "{{user `destination_regions`}}",
      "ssh_username": "ubuntu",
      "type": "amazon-ebs"
    }
  ]
}
```