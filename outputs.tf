output "created_vm_details" {
  description = "Details of the created virtual machines"
  value = {
    for name, inst in openstack_compute_instance_v2.basic : name => {
      id         = inst.id
      ip_address = inst.access_ip_v4
    }
  }
}