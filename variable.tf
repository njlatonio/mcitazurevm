variable "subscription_id"{
  type=string
}
variable "client_id"{
  type=string
}
variable "client_secret"{
  type=string
}
variable "tenant_id"{
  type=string
}
variable "admin_username"{
  type=string
}
variable "admin_password"{
  type=string
}
variable "name"{
  type=string
} 
variable "location"{
  type=string
} 
variable "virtual_network_name"{
  type=string
} 
variable "address_space"{
  type=list(string)
}
variable "subnet_name"{
  type=string
} 
variable "address_prefixes"{
  type=list(string)
}
variable "nic_name"{
  type=string
} 
variable "ip_config_name"{
  type=string
}
variable "private_ip_address_allocation"{
  type=string
}
variable "vm_size"{
  type=string
}
variable "publisher"{
  type=string
}
variable "offer"{
  type=string
}
variable "sku"{
  type=string
}
variable "storage_image_reference_version"{
  type=string
}
variable "storage_os_disk_name"{
  type=string
}
variable "caching"{
  type=string
}
variable "create_option"{
  type=string
}
variable "managed_disk_type"{
  type=string
}
variable "computer_name"{
  type=string
}
variable "disable_password_authentication"{
  type=bool
}
variable "environment"{
  type=string
}
