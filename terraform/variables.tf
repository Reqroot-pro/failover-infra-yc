variable "cloud_id" {}
variable "folder_id" {}
variable "sa_key_file" {
  description = "Path to Service Account Key File"
  type        = string
  default     = "/home/devops/keys/key.json"
}

variable "zone" { default = "ru-central1-a" }

variable "public_key_path" { default = "~/.ssh/my_key.pub" }
variable "private_key_path" { default = "~/.ssh/my_key" }

variable "vm_image" { default = "ubuntu-2204-lts" }
variable "vm_cpu"   { default = 2 }
variable "vm_memory"{ default = 2 }
