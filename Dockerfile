FROM hashicorp/packer:light

COPY /github/workspace/scripts/ami_user_data.sh /home/scripts/ami_user_data.sh
