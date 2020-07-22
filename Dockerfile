FROM hashicorp/packer:light

COPY scripts/ami_user_data.sh /home/scripts/ami_user_data.sh
