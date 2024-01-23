locals {  
    sshUser = vault("credentials/users/misc/root", "Username")
    sshPass = vault("credentials/users/misc/root", "Password")
}

variable "cluster" {
  type    = string
}

variable "datastore" {
  type    = string
}

variable "datastoreISO" {
  type    = string
}

variable "folder" {
  type    = string
}

variable "network" {
  type    = string
}

variable "vcenterNL" {
  type    = string
}

variable "vcenterPass" {
  type    = string
}

variable "vcenterUK" {
  type    = string
}

variable "vcenterUser" {
  type    = string
}