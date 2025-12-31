# ak，sk需要修改
variable "secret_id" {
  default = ""
}

variable "secret_key" {
  default = ""
}

# region内网测试环境为广州不需要变, 其他环境看需求变化
variable "region" {
  default = "ap-guangzhou"
}

variable "availability_zone" {
  default = "ap-guangzhou-6"
}

# vpc配置, 根据需求修改,2个子网
variable "vpc_name" {
  default = "terraform测试环境"
}

variable "vpc_cidr" {
  default = "10.152.8.0/24"
}

variable "vpc_cvm_name" {
  default = "服务器子网"
}

variable "subnet_cvm_cidr" {
  default = "10.152.8.0/25"
}


variable "vpc_k8s_name" {
  default = "k8s子网"
}

variable "subnet_k8s_cidr" {
  default = "10.152.8.128/25"
}


# 标签配置，根据需求修改标签
variable "Resource_tag" {
  default = {
    "ResourceGroup" = "海外公共"
  }  
}

# 公共配置, 安全组和密钥，这个不需要修改
variable "security_groups_id" {
  default = ["sg-mu68lwsr"]
}

variable "key_ids" {
  default = ["skey-0e5brr5f"]
}


# cvm配置,内网环境不需要修改image_id,只需要修改cvm名称
# 数据库cvm配置
variable "db_cvm_name" {
  default = "terraform测试-数据库"
}

variable "db_image_id" {
  default = "img-9uqhralc"
}

# nsq的cvm配置
variable "nsq_cvm_name" {
  default = "terraform测试-nsq"
}

variable "nsq_image_id" {
  default = "img-quo372i2"
}

# 发布工具的cvm配置
variable "deploy_cvm_name" {
  default = "terraform测试-发布工具"
}

variable "deploy_image_id" {
  default = "img-kxbvom92"
}

# k8s配置，只需要修改集群名称和service网段
variable "cluster_name" {
  default = "terraform测试"
}
# service网段，根据需求修改，确认不能重叠
variable "service_cidr" {
  default = "172.29.0.0/17"
}

# NAT网关配置, 只需要修改nat名字
variable "nat_name" {
  default = "terraform测试"
}
# nat可用区, 不需要修改
variable "nat_zone" {
  default = "ap-guangzhou-5"
}

# cos桶配置, 只需要修改cos名称
variable "bucket_name" {
  default = "terraform-test"
}

# app_id，不需要修改
variable "app_id" {
  default = "1329675467"
}

