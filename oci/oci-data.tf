data "oci_core_images" "ubuntu_image" {
  #Required
  compartment_id = data.oci_identity_compartment.ph-root-compartment.id

  #Optional
  operating_system         = "Canonical Ubuntu"
  operating_system_version = "22.04"
  shape                    = var.oci_instance_shape
  state                    = "AVAILABLE"
  sort_by                  = "TIMECREATED"
}
