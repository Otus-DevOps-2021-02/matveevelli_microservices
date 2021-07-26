variable cloud_id {
  description = "Cloud"
}
variable folder_id {
  description = "Folder"
}
variable zone {
  description = "Zone"
  # Значение по умолчанию
  default = "ru-central1-a"
}
variable public_key_path {
  description = "/users/matveev/.ssh/ubuntu.pub"
}
variable private_key_path {
  description = "/users/matveev/.ssh/ubuntu"
}

variable image_id {
  description = "Disk image"
}
variable subnet_id {
  description = "Subnet"
}
variable service_account_key_file {
  description = "/users/matveev/otus/devops/key.json"
}

variable count_app {
  description = "count"
  default     = 1
}
variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "fd84744976fo87rptj7f"
}
variable db_disk_image {
  description = "Disk image for reddit db"
  default     = "fd8hvagqpehdiko2qqmi"
}
