output "cloudblock-output" {
  value = <<OUTPUT

#############
## OUTPUTS ##
#############

## SSH (VPN) ##
ssh ubuntu@${oci_core_instance.ph-instance.public_ip}
(ssh ubuntu@${var.docker_gw})

## WebUI (VPN) ##
https://${oci_core_instance.ph-instance.public_ip}/admin/
(https://${var.docker_webproxy}/admin/)

## Wireguard Configurations ##
https://console.${local.oci_region}.oraclecloud.com/object-storage/buckets/${data.oci_objectstorage_namespace.ph-bucket-namespace.namespace}/${var.ph_prefix}-bucket/objects

#############
## UPDATES ##
#############

# SSH to the server
ssh ubuntu@${oci_core_instance.ph-instance.public_ip}

# Remove containers (services are down until ansible step completes!)
sudo docker rm -f cloudflared_doh pihole web_proxy wireguard

# Re-apply Ansible playbook via systemctl
sudo systemctl start cloudblock-ansible-state.service

#############
## DESTROY ##
#############

# If destroying the project via terraform, remove the bucket objects first
oci os object bulk-delete-versions -bn ${var.ph_prefix}-bucket -ns ${data.oci_objectstorage_namespace.ph-bucket-namespace.namespace}

# then run terraform destroy as normal
terraform destroy -var-file="oci.tfvars"

OUTPUT
}

output "ubuntu_image_id" {
  description = "The OCID of the Ubuntu 22.04 image"
  value       = data.oci_core_images.ubuntu_image.images[0].id
}
