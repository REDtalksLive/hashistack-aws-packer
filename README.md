![Validate Packer Template](https://github.com/REDtalks/hashistack-aws-packer/workflows/Validate%20Packer%20Template/badge.svg?branch=validate)

![Build & Deploy Packer Template](https://github.com/REDtalks/hashistack-aws-packer/workflows/Build%20&%20Deploy%20Packer%20Template/badge.svg)

# hashistack-aws-packer
Repo for maintaining AWS AMI's via GitHub Actions 

## Workflow

Github pull reuqest executes the 'validate' GitHub Action.

The 'validate' GitHub Action runs the office HashiCorp Packer container, e.g.

```sh
docker run -it \
    --mount type=bind,source=/absolute/path/to/test_docker_packer,target=/mnt/test_docker_packer \
    hashicorp/packer:latest build \
    --var-file /mnt/test_docker_packer/vars.json \
    /mnt/test_docker_packer/template.json
```



# NOTES

## AWS Regions

Use 'array values' for the AWS regions:
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
      "region": "us-east-1",
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