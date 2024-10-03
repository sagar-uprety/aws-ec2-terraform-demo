variable "region" {
  description = "The AWS region to deploy the VM"
  type = string
  default     = "us-east-1"
}

variable "created_by_tf" {
  description = "The creator of the resources"
  type = bool
  default = false
}

variable "environment" {
  description = "The environment of the resources"
  type = string
  default     = ""
}

variable "application" {
  description = "The application for the resources"
  type = string
  default     = ""
}

variable "ami_name" {
  description = "The name of the AMI to use for the VM, default is the latest Ubuntu AMI"
  type = string
  default = ""
}

variable "ami_owners" {
  description = "The owners of the AMI to use for the VM, default is the official Ubuntu AMI"
  type = list(string)
  default = [] # Canonical
}

variable "custom_ami" {
  description = "The custom AMI to use for the VM, if not provided the latest Ubuntu AMI will be used"
  type = string
  default     = ""
}

variable "ssh_pub_key" {
  description = "Public SSH key to be added to the VM"
  type = string
  default     = ""
}

variable "provision_script" {
  description = "The path to the script to provision the VM"
  type = string
  default     = ""
}

