variable "application_name" {
  type        = string
  description = "Application name."
  default     = "aws_network"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR range."
  default     = "10.0.0.0/24"
}

variable "subnets_private" {
  type = map(object({
    cidr = string
    az   = string
  }))

  description = "Map of private subnets with their CIDR ranges and availability zones."

  default = {
    subnet_private_1 = {
      cidr = "10.0.0.0/25"
      az   = "us-east-1a"
    }
    subnet_private_2 = {
      cidr = "10.0.0.128/25"
      az   = "us-east-1b"
    }
  }
}

variable "subnet_public_1_cidr" {
  type        = string
  description = "Public Subnet 1 CIDR range."
  default     = null
}

variable "subnet_public_2_cidr" {
  type        = string
  description = "Public Subnet 2 CIDR range."
  default     = null
}

variable "subnet_public_1_az" {
  type        = string
  description = "Public Subnet 1 Availability Zone."
  default     = "us-east-1a"
}

variable "subnet_public_2_az" {
  type        = string
  description = "Public Subnet 2 Availability Zone."
  default     = "us-east-1b"
}

variable "nat_availability_mode" {
  type        = string
  description = "NAT Gateway Availability Mode. Can be 'zonal' or 'regional'."
  default     = "regional"

  validation {
    condition     = contains(["zonal", "regional"], var.nat_availability_mode)
    error_message = "nat_availability_mode must be either 'zonal' or 'regional'."
  }
}

variable "enable_internet_connectivity" {
  type        = bool
  description = "Enable Internet connectivity for the VPC."
  default     = false
}
