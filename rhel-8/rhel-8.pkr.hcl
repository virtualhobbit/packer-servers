packer {
  required_version = ">= 1.10.2"
  required_plugins {
    vsphere = {
      version = ">= 1.2.6"
          source  = "github.com/hashicorp/vsphere"
    }
  }
}

source "vsphere-iso" "Utrecht" {
  vcenter_server          = var.vcenterNL
  username                = var.vcenterUser
  password                = var.vcenterPass
  insecure_connection     = true  

  vm_name                 = "RHEL 8"
  vm_version              = 20
  guest_os_type           = "rhel8_64Guest"

  CPUs                    = 1
  RAM                     = 2048
  cluster                 = var.cluster

  datastore               = var.datastore
  folder                  = var.folder
  disk_controller_type    = ["pvscsi"]
  storage {
    disk_size             = 16384
    disk_thin_provisioned = true
  }
  iso_paths               = ["[${var.datastoreISO}] rhel-8.9-x86_64-dvd.iso"]
  remove_cdrom            = true

  network_adapters {
    network               = var.network
    network_card          = "vmxnet3"
  }

  notes                   = "Base OS, VMware Tools, patched up to ${legacy_isotime("20060102")}"

  boot_order              = "disk,cdrom"
  boot_command            = ["<up><up><tab>inst.text inst.ks=http://intranet.mdb-lab.com/rhel-8.cfg ip=dhcp<enter><wait>"]
  shutdown_command        = "echo '${local.sshPass}' | sudo -S -E shutdown -P now"

  communicator            = "ssh"
  ssh_username            = local.sshUser
  ssh_password            = local.sshPass

  convert_to_template     = true
  create_snapshot         = false
}

source "vsphere-iso" "Southport" {
  vcenter_server          = var.vcenterUK
  username                = var.vcenterUser
  password                = var.vcenterPass
  insecure_connection     = true

  vm_name                 = "RHEL 8"
  vm_version              = 20
  guest_os_type           = "rhel8_64Guest"

  CPUs                    = 1
  RAM                     = 2048
  cluster                 = var.cluster

  datastore               = var.datastore
  folder                  = var.folder
  disk_controller_type    = ["pvscsi"]
  storage {
    disk_size             = 16384
    disk_thin_provisioned = true
  }
  iso_paths               = ["[${var.datastoreISO}] rhel-8.9-x86_64-dvd.iso"]
  remove_cdrom            = true

  network_adapters {
    network               = var.network
    network_card          = "vmxnet3"
  }

  notes                   = "Base OS, VMware Tools, patched up to ${legacy_isotime("20060102")}"

  boot_order              = "disk,cdrom"
  boot_command            = ["<up><up><tab>inst.text inst.ks=http://intranet.mdb-lab.com/rhel-8.cfg ip=dhcp<enter><wait>"]
  shutdown_command        = "echo '${local.sshPass}' | sudo -S -E shutdown -P now"

  communicator            = "ssh"
  ssh_username            = local.sshUser
  ssh_password            = local.sshPass

  convert_to_template     = true
  create_snapshot         = false
}

build {
  sources                 = ["source.vsphere-iso.Utrecht", "source.vsphere-iso.Southport"]

  provisioner "shell" {
    inline                = ["subscription-manager register --username mark@mdb.eu.com --password h34Mph_V --auto-attach"]
  }

  provisioner "shell" {
    inline                = ["dnf install -y perl", "dnf update -y", "dnf clean all"]
  }

  provisioner "shell" {
    execute_command       = "echo '${local.sshPass}' | sudo -S -E bash '{{ .Path }}'"
    scripts               = ["setup/certs.sh", "setup/ansible.sh"]
  }

  provisioner "shell" {
    inline                = ["subscription-manager unregister"]
  }
}
