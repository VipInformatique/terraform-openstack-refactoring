
terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "3.0.0"
    }
  }
}

provider "openstack" {
  auth_url    = "http://192.168.0.154/identity"
  user_name   = "admin"
  password    = "secret"
  tenant_name = "admin"
  region      = "RegionOne"
}

# Wczytanie danych z pliku CSV
locals {
  csv_data_raw = file("${path.module}/vm.csv")
  instances    = csvdecode(local.csv_data_raw)

  key_map = {
    for key in distinct([for inst in local.instances : inst.key_pair]) :
    key => "${pathexpand("~/.ssh")}/${key}.pub"
  }
}

resource "openstack_compute_keypair_v2" "keys" {
  for_each   = local.key_map
  name       = each.key
  public_key = file(each.value)
}


# Sieć prywatna (musi istnieć w OpenStack)
data "openstack_networking_network_v2" "network" {
  name = "private"
}

# Projekt (tenant) admina
data "openstack_identity_project_v3" "admin" {
  name = "admin"
}

# Domyślna grupa zabezpieczeń
data "openstack_networking_secgroup_v2" "default_sg" {
  name      = "default"
  tenant_id = data.openstack_identity_project_v3.admin.id
}

# Dynamiczne tworzenie maszyn z pliku CSV
resource "openstack_compute_instance_v2" "basic" {
  for_each    = { for inst in local.instances : inst.local_id => inst }

  name        = each.value.name
  image_name  = each.value.image_name
  flavor_name = each.value.flavor_name
  key_pair    = openstack_compute_keypair_v2.keys[each.value.key_pair].name

  security_groups = [data.openstack_networking_secgroup_v2.default_sg.name]

  network {
    uuid = data.openstack_networking_network_v2.network.id
  }
}
