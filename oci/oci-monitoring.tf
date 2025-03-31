data "http" "nixstats" {
  url = "https://nixstats.com/whitelist.php"
}

data "http" "uptimerobot" {
  url = "https://uptimerobot.com/inc/files/ips/IPv4.txt"
}

locals {
  # Parse Nixstats IPs
  raw_nixstats_ips = split("\n", data.http.nixstats.response_body)
  filtered_nixstats_ips = [
    for ip in local.raw_nixstats_ips : "${trimspace(ip)}/32"
    if length(trimspace(ip)) > 0 && !can(regex("^#", trimspace(ip)))
  ]

  # Parse UptimeRobot IPs
  raw_uptimerobot_ips = split("\n", data.http.uptimerobot.response_body)
  filtered_uptimerobot_ips = [
    for ip in local.raw_uptimerobot_ips : "${trimspace(ip)}/32"
    if length(trimspace(ip)) > 0 && !can(regex("^#", trimspace(ip)))
  ]

  # Create a combined map of IP-Description
  ip_description_map = merge(
    { for ip in local.filtered_nixstats_ips : ip => "Nixstats" },
    { for ip in local.filtered_uptimerobot_ips : ip => "UptimeRobot" }
  )
}

resource "oci_core_security_list" "monitoring" {
  compartment_id = oci_identity_compartment.ph-compartment.id
  vcn_id         = oci_core_vcn.ph-vcn.id
  display_name   = "${var.ph_prefix}-security-monitoring"

  # Ingress Security Rules
  dynamic "ingress_security_rules" {
    for_each = local.ip_description_map
    content {
      description = ingress_security_rules.value # Use description from the map
      protocol    = "6"                          # TCP protocol
      source      = ingress_security_rules.key   # IP address
      source_type = "CIDR_BLOCK"

      tcp_options {
        min = 53
        max = 53
      }
    }
  }
}
