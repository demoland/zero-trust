# agent-server-secure.hcl

# Data Persistence
data_dir = "/etc/consul/data"

# Logging
log_level = "DEBUG"

# Enable service mesh
connect {
  enabled = true
}

# Addresses and ports
addresses {
  grpc = "0.0.0.0"
  https = "0.0.0.0"
  dns = "0.0.0.0"
}

ports {
  grpc_tls  = 8503
  http      = 8500
  https     = 8443
  dns      = 8600
}

# DNS recursors
recursors = ["1.1.1.1"]

# Disable script checks
enable_script_checks = false

# Enable local script checks
enable_local_script_checks = true

## ACL configuration
acl = {
  enabled = true
  default_policy = "deny"
  enable_token_persistence = true
  enable_token_replication = true
  down_policy = "extend-cache"
}


encrypt = "a+9h847Ss8A9gUi5OgkAs1Zn/5hhQnvWux0cjQ1Aius="

## Server specific configuration for dc1
server = true
bootstrap_expect = 1
datacenter = "dc1"

client_addr = "0.0.0.0"

## UI configuration (1.9+)
ui_config {
  enabled = true
}

## TLS Encryption (requires cert files to be present on the server nodes)
# tls {
#   defaults {
#     ca_file   = "/etc/consul/config/consul-agent-ca.pem"
#     cert_file = "/etc/consul/config/dc1-server-consul-0.pem"
#     key_file  = "/etc/consul/config/dc1-server-consul-0-key.pem"

#     verify_outgoing        = true
#     verify_incoming        = true
#   }
#   https {
#     verify_incoming        = false
#   }
#   internal_rpc {
#     verify_server_hostname = true
#   }
# }

## TLS Encryption (requires cert files to be present on the server nodes)
ca_file   = "/etc/consul/config/consul-agent-ca.pem"
cert_file = "/etc/consul/config/dc1-server-consul-0.pem"
key_file  = "/etc/consul/config/dc1-server-consul-0-key.pem"
verify_incoming        = false
verify_incoming_rpc    = true
verify_outgoing        = true
verify_server_hostname = true

auto_encrypt {
  allow_tls = true
}
