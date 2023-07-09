variable "cidr_for_vpc" {
  description = "cidr range for vpc"
  type        = string
}
variable "tenancy" {
  description = "instance tenacy for instances launed in this vpc"
  type        = string
  default     = "default"
}

variable "dns_hostname_enabled" {
  description = "a boolean flag to enabled/disable the dns hostname"
  type        = bool
  default     = "true"
}


variable "dns_supported_enabled" {
  description = "a boolean flag to enabled/disable the dns support"
  type        = bool
  default     = "true"
}
variable "vpc_name" {
  description = "vpc name"
  type        = string
}

variable "web_server_name" {
  type        = string
  description = "name for the instance created as web server"
}
variable "inbound_rules_web" {
  description = "ingress rules for security group"
  type = list(object({

    port        = number
    description = string
    protocol    = string
  }))

  default = [{
    port        = 22
    description = "this is for ssh connection"
    protocol    = "tcp"

    },
    {
      port        = 80
      description = "this is for apache software"
      protocol    = "tcp"

    }


  ]

}

variable "inbound_rules_application" {
  description = "ingress rule for security group of application server"
  type = list(object({
    port        = number
    description = string
    protocol    = string
  }))

  default = [
    {
      port        = 8080
      description = "this is for app hosting"
      protocol    = "tcp"
  }]
}

variable "key_name" {
  type        = string
  description = "key pair name"
  default     = "deployer-key"
}

 