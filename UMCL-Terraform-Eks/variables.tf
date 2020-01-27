variable "vpc_cidr" {
  description = "CIDR for vpc"
  type        = "string"
  default     = "10.20.0.0/16"
}

variable "region" {
  description = "Choose region for your stack"
  type        = "string"
  default     = "ap-south-1"
}

variable "nat_amis" {
  type = "map"

  default = {
    #ap-southeast-1 = "ami-0217a85e28e625474"
    ap-south-1 = "ami-01e074f40dfb9999d"

    #ap-south-1     = "ami-0a74bfeb190bd404f"
  }
}

/*variable "key_file_path" {
  default     = "https://jenkey.s3.ap-south-1.amazonaws.com/jenkins_key_pair.pem"
  #default     = "C:/Users/sony/Downloads/books/keys/jenkins_key_pair.pem"
  description = " Location of the local private key file for the EC2 instance."
}*/
/*variable "jenkins_pub_key_pair" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAo3moZAdHmQFzkwgs2S+dDQNAQ7v5ykAUD9NCwghz2vqse1Sr2OFQm8tJjx7amIq4cCjAx818HB3JcCGHdEao2qM5WP7tAfJp0lK4a1bD96xnyyfGSkGL1y3mn7KzDV0jt53T2MGW2ElUKU6Lt6X+nErZoNPq01/qeGZHgKDD0/koHvDWyBpR2qOj4gOi2N2/9Z3+ZFDKEEZk+SOrg1NvV6XCVKesL+SQ6PvMqGY21h7Gu6VJCQ6vN9389g8VjcXS1E5a9V94UkJvm2quS5yT6BBW33FJl99i5EQPpU2DHzFzng52XboEiBRQIV/u0shild860Vp8IncHx3lYBl0Eew== nadhsai@gmail.com"
}*/

variable "key_file_path" {
  default     = "C:/Users/sony/Downloads/books/keys/jenkins_key_pair.pem"
  description = " Location of the local private key file for the EC2 instance."
}

variable "key_name" {
  default     = "jenkins_key_pair"
  description = "Existing AWS KeyPair name. Must match the KeyPair referenced in key_file_path"
}

variable "linux_username" {
  default     = "ec2-user"
  description = "AWS default instance username"
}

variable "volume_type" {
  default     = "standard"
  description = "type of EBS volume to use"
}

variable "root_disk_size_gb" {
  default     = 8
  description = "AWS disk size for this machine."
}

variable "eks_cluster" {
  default = "terraform_eks_cluster"
  type    = "string"
}
