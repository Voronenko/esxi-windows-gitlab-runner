provider "esxi" {
  esxi_hostname      = var.esxi_hostname
  esxi_hostport      = var.esxi_hostport
  esxi_username      = var.esxi_username
  esxi_password      = var.esxi_password
}

#
# Template for initial configuration bash script
#    template_file is a great way to pass variables to
#    cloud-init
data "template_file" "userdata_default" {
  template = file("userdata.tpl")
  vars = {
    HOSTNAME = var.vm_hostname
    HELLO    = "Hello EXSI World!"
  }
}

resource "esxi_guest" "vmtest" {
  # guest_name - Required - The Guest name.
  guest_name         = var.vm_hostname
  # guestos  # Optional - Default will be taken from cloned source
  notes              = "Windows runner"  # Optional - The Guest notes (annotation).
  disk_store         = var.disk_store # Required - esxi Disk Store where guest vm will be created
  boot_disk_type     = "thin" # Optional - Guest boot disk type. Default 'thin'. Available thin, zeroedthick, eagerzeroedthick
  boot_disk_size     = "140" # Optional - Specify boot disk size or grow cloned vm to this size.
  memsize            = "8192" # Optional - Memory size in MB. (ie, 1024 == 1GB). See esxi documentation for limits. - Default 512 or default taken from cloned source
  numvcpus           = "4" # Optional - Number of virtual cpus. See esxi documentation for limits. - Default 1 or default taken from cloned source.
  virthwver          = "14" #  Optional - esxi guest virtual HW version. See esxi documentation for compatible values. - Default 8 or taken from cloned source.
  power              = "on" # Optional - on, off.
  guest_startup_timeout = "180"

  network_interfaces {
     virtual_network = var.virtual_network
  }

  #
  #  Specify an existing guest to clone, an ovf source, or neither to build a bare-metal guest vm.
  #
  #clone_from_vm      = var.vm_clone_from #  Source vm to clone. Mutually exclusive with ovf_source option.
  ovf_source        = var.vm_ovf_local_path # ovf files to use as a source. Mutually exclusive with clone_from_vm option.

  #Array of upto 10 network interfaces.
  #virtual_network - Required for each Guest NIC - This is the esxi virtual network name configured on esxi host.
  #mac_address - Optional - If not set, mac_address will be generated by esxi.
  #nic_type - Optional - See esxi documentation for compatibility list. - Default "e1000" or taken from cloned source.

  # Other optionals

  # resource_pool_name - Optional - Any existing or terraform managed resource pool name. - Default "/"
  # virtual_disks - Optional - Array of additional storage to be added to the guest.
  #     virtual_disk_id - Required - virtual_disk.id from esxi_virtual_disk resource.
  #     slot - Required - SCSI_Ctrl:SCSI_id. Range '0:1' to '3:15'. SCSI_id 7 is not allowed.
  # guest_startup_timeout - Optional - The amount of guest uptime, in seconds, to wait for an available IP address on this virtual machine.
  # guest_shutdown_timeout - Optional - The amount of time, in seconds, to wait for a graceful shutdown before doing a forced power off.

  # guestinfo - Optional - The Guestinfo root
  # metadata - Optional - A JSON string containing the cloud-init metadata.
  # metadata.encoding - Optional - The encoding type for guestinfo.metadata. (base64 or gzip+base64)
  # userdata - Optional - A YAML document containing the cloud-init user data.
  # userdata.encoding - Optional - The encoding type for guestinfo.userdata. (base64 or gzip+base64)
  # vendordata - Optional - A YAML document containing the cloud-init vendor data.
  # vendordata.encoding - Optional - The encoding type for guestinfo.vendordata (base64 or gzip+base64)

  # /Other optionals

  # OUTPUTS
  # ip_address - Computed - The IP address reported by VMware tools.
}