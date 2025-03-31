## COMMON ##
ph_password = "zxasqw12"
ssh_key     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQChfZryPRwPcle2fzNjZkjzDiTLOLBvDAx+Vj1zyMEMkoTGA7e8t0p6uuuQaL1ifunjlN7WvhTbvJYy4YNU1/YCN8g99SvZHpJxRDq0qti9W2DUeSdagw6+wSL0ZLseLbDpT4QMJzuGM8y/nkJVUcxTg08GGhDzLdjLxQRI37CTsrt3mShEnf0wp+SYC0hYjKXdYQo27VBNIIsa/MuuOfhgvg7lqM2vvQhCD/8MjHtwOZe8ae342JbK6bzyfBscLbXhxIw2+cIV8MFmvG4DeMCg71h1xfNR8ic9XW9OeW6nJZz4Fm1uysSZnrc24jsoNRl1taWPoCY/S3EvGzM+Hlxz avi@langburd.com"
mgmt_cidr   = "81.199.130.107/32"
work_ip     = "104.30.134.89/32"

oci_config_profile   = "ddyyconsulting"
oci_root_compartment = "ocid1.tenancy.oc1..aaaaaaaato5fdockcmomca6kdwqkiaj36zwbwfbqqqasxy23v5yb3nr6rndq"

# The number of wireguard peer configurations to generate / store - 1 per device
wireguard_peers = 20

# dns over https provider, one of adguard applied-privacy cloudflare google hurricane-electric libre-dns opendns pi-dns quad9-recommended - see https://github.com/curl/curl/wiki/DNS-over-HTTPS
doh_provider = "cloudflare"

# Generate wireguard client configurations to route only "dns" traffic through VPN, or:
# "peers" - dns + other connected peers
# "all" - all traffic
# The wireguard server container does NOT restrict clients, clients can change their AllowedIPs as desired.
# either "dns" "peers" or "all"
vpn_traffic = "all"

# a value of 1 permits mgmt_cidr and client_cidrs access to DNS without the VPN
dns_novpn = 1

# additional client networks granted access pihole DNS without the VPN, example format:
# client_cidrs = ["127.0.0.1/32","8.8.8.8/32"]
client_cidrs = []

## FREE TIER USERS ##
# Oracle configured your account for two free virtual machines in a specific cloud REGION + AD (Availability Domain), terraform needs to know these.
# See which REGION + AD oracle assigned to your account with the following two commands (without the #):

# OCI_TENANCY_OCID=$(oci iam compartment list --all --compartment-id-in-subtree true --access-level ACCESSIBLE --include-root --raw-output --query "data[?contains(\"id\",'tenancy')].id | [0]")
# oci limits value list --compartment-id $OCI_TENANCY_OCID --service-name compute --query "data [?contains(\"name\",'standard-e2-micro-core-count')]" --all

# Example output - look at each "value" and find the 2 (thats the two free virtual machines)
# The AD number is the last digit in "availability-domain" - 2 in this example (note - some regions only have one AD)
#  {
#    "availability-domain": "oaKW:US-ASHBURN-AD-1",
#    "name": "standard-e2-micro-core-count",
#    "scope-type": "AD",
#    "value": 0
#  },
#  {
#    "availability-domain": "oaKW:US-ASHBURN-AD-2",
#    "name": "standard-e2-micro-core-count",
#    "scope-type": "AD",
#    "value": 2
#  }

oci_region   = "il-jerusalem-1"
oci_adnumber = 1

# By default Cloudblock for OCI is configured to use the Always Free tier included Micro (AMD) instance - a different shape can be specified here
# Always Free VM.Standard.E2.1.Micro up to 1 OCPU and 1 MemGB
# Always Free VM.Standard.A1.Flex up to 4 OCPU and 24 MemGB but OnlyOffice is not compatible
# For ARM, use VM.Standard.A1.Flex
oci_instance_shape = "VM.Standard.E2.1.Micro"

# Default OCPUs and Memory set Always Free tier included Micro instance - can be adjusted here if other shape specified above
oci_instance_ocpus = 1
oci_instance_memgb = 1

# If required, the instance boot volume can be changed here. By default the "VM.Standard.E2.1.Micro" instance uses a 50GB boot volume
# The Always Free tier includes 200GB of block volume storage across all instances in your tenancy
oci_instance_diskgb = 50

# Use a recent version of OCI's managed Ubuntu 22.04 image - specific to your region.
# For the latest Ubuntu 22.04 image ids in your region, run:
# OCI_TENANCY_OCID=$(oci iam compartment list --all --compartment-id-in-subtree true --access-level ACCESSIBLE --include-root --raw-output --query "data[?contains(\"id\",'tenancy')].id | [0]") && oci compute image list --compartment-id $OCI_TENANCY_OCID --all --lifecycle-state 'AVAILABLE' --operating-system "Canonical Ubuntu" --operating-system-version "22.04" --sort-by "TIMECREATED" | grep 'display-name\|ocid'

# For ARM instances, choose the AARCH64 ocid in the command above
oci_imageid = "ocid1.image.oc1.il-jerusalem-1.aaaaaaaarh6rxdqeiffih3yyepmo2evqcjaw5xg4brby24wsuj2idch4giyq"

## VERY UNCOMMON - Change if git project is cloned or deploying into an existing OCI environment where IP schema might overlap ##
vcn_cidr          = "10.10.12.0/24"
ph_prefix         = "cloudblock"
project_url       = "https://github.com/chadgeary/cloudblock"
docker_network    = "172.18.0.0"
docker_gw         = "172.18.0.1"
docker_doh        = "172.18.0.2"
docker_pihole     = "172.18.0.3"
docker_wireguard  = "172.18.0.4"
docker_webproxy   = "172.18.0.5"
wireguard_network = "172.19.0.0"
