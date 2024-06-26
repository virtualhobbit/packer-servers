packer {
  required_version = ">= 1.10.2"
  required_plugins {
    vsphere = {
      version = ">= 1.2.6"
          source  = "github.com/hashicorp/vsphere"
    }
    windows-update = {
      version = ">= 0.15.0"
          source  = "github.com/rgl/windows-update"
    }
  }
}

source "vsphere-iso" "Utrecht" {
  vcenter_server          = var.vcenterNL
  username                = var.vcenterUser
  password                = var.vcenterPass
  insecure_connection     = true

  vm_name                 = "Windows Server 2022 Standard"
  vm_version              = 20
  guest_os_type           = "windows9Server64Guest"

  CPUs                    = 1
  RAM                     = 4096
  cluster                 = var.cluster

  datastore               = var.datastore
  folder                  = var.folder
  disk_controller_type    = ["pvscsi"]
  storage {
    disk_size             = 51200
    disk_thin_provisioned = true
  }
  floppy_files            = ["${path.root}/setup/"]
  iso_paths               = ["[${var.datastoreISO}] en-us_windows_server_2022_updated_march_2024_x64_dvd_f6700d18.iso", "[${var.datastoreISO}] VMware-tools-windows-12.4.0-23259341.iso"]
  remove_cdrom            = true

  network_adapters {
    network               = var.network
    network_card          = "vmxnet3"
  }

  notes                   = "Base OS, VMware Tools, patched up to ${legacy_isotime("20060102")}"

  boot_order              = "disk,cdrom"
  shutdown_timeout        = "1h0m"

  communicator            = "winrm"
  winrm_username          = local.winrmUser
  winrm_password          = local.winrmPass

  convert_to_template     = true
  create_snapshot         = false
}

source "vsphere-iso" "Southport" {
  vcenter_server          = var.vcenterUK
  username                = var.vcenterUser
  password                = var.vcenterPass
  insecure_connection     = true

  vm_name                 = "Windows Server 2022 Standard"
  vm_version              = 20
  guest_os_type           = "windows9Server64Guest"

  CPUs                    = 1
  RAM                     = 4096
  cluster                 = var.cluster

  datastore               = var.datastore
  folder                  = var.folder
  disk_controller_type    = ["pvscsi"]
  storage {
    disk_size             = 51200
    disk_thin_provisioned = true
  }
  floppy_files            = ["${path.root}/setup/"]
  iso_paths               = ["[${var.datastoreISO}] en-us_windows_server_2022_updated_march_2024_x64_dvd_f6700d18.iso", "[${var.datastoreISO}] VMware-tools-windows-12.4.0-23259341.iso"]
  remove_cdrom            = true

  network_adapters {
    network               = var.network
    network_card          = "vmxnet3"
  }

  notes                   = "Base OS, VMware Tools, patched up to ${legacy_isotime("20060102")}"

  boot_order              = "disk,cdrom"
  shutdown_timeout        = "1h0m"

  communicator            = "winrm"
  winrm_username          = local.winrmUser
  winrm_password          = local.winrmPass

  convert_to_template     = true
  create_snapshot         = false
}

build {
  sources                 = ["source.vsphere-iso.Utrecht", "source.vsphere-iso.Southport"]

  provisioner "powershell" {
    inline                = ["powercfg.exe /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c"]
  }

  provisioner "windows-restart" {}

  provisioner "powershell" {
    elevated_user         = local.winrmUser
    elevated_password     = local.winrmPass
    scripts               = ["${path.root}/setup/certs.ps1", "${path.root}/setup/ansible.ps1", "${path.root}/setup/cloudinit.ps1", "${path.root}/setup/sshd.ps1"]
  }

  provisioner "windows-restart" {}

  provisioner "windows-update" {
    filters               = ["exclude:$_.Title -like '*Preview*'", "include:$true"]
    search_criteria       = "IsInstalled=0"
  }
}