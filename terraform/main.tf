provider "tencentcloud" {
  secret_id  = var.secret_id
  secret_key = var.secret_key
  region     = var.region
}

# 创建VPC
resource "tencentcloud_vpc" "vpc" {
  name       = var.vpc_name
  cidr_block = var.vpc_cidr
  tags = var.Resource_tag
}

# 创建云服务器子网
resource "tencentcloud_subnet" "subnet_cvm" {
  availability_zone = var.availability_zone
  name              = var.vpc_cvm_name
  vpc_id            = tencentcloud_vpc.vpc.id
  cidr_block        = var.subnet_cvm_cidr
  is_multicast      = false
  tags = var.Resource_tag
}

# 创建k8s子网
resource "tencentcloud_subnet" "subnet_k8s" {
  availability_zone = var.availability_zone
  name              = var.vpc_k8s_name
  vpc_id            = tencentcloud_vpc.vpc.id
  cidr_block        = var.subnet_k8s_cidr
  is_multicast      = false
  tags = var.Resource_tag
}


# 创建数据库服务器
resource "tencentcloud_instance" "db_cvm" {
  instance_name     = var.db_cvm_name
  availability_zone = var.availability_zone
  # 包月自动续订
  # instance_charge_type = "PREPAID"
  # instance_charge_type_prepaid_period = "1"
  # instance_charge_type_prepaid_renew_flag = "NOTIFY_AND_AUTO_RENEW"
  image_id          = var.db_image_id
  instance_type     = "SA9.LARGE8"
  system_disk_type  = "CLOUD_BSSD"
  system_disk_size  = 150
  allocate_public_ip = true
  internet_max_bandwidth_out = 200
  vpc_id            = tencentcloud_vpc.vpc.id
  subnet_id         = tencentcloud_subnet.subnet_cvm.id
  orderly_security_groups  = var.security_groups_id
  key_ids = var.key_ids
  tags = var.Resource_tag
}


# 创建nsq服务器
resource "tencentcloud_instance" "nsq_cvm" {
  instance_name     = var.nsq_cvm_name
  availability_zone = var.availability_zone
  # instance_charge_type = "PREPAID"
  # instance_charge_type_prepaid_period = "1"
  # instance_charge_type_prepaid_renew_flag = "NOTIFY_AND_AUTO_RENEW"
  image_id          = var.nsq_image_id
  instance_type     = "SA9.MEDIUM4"
  system_disk_type  = "CLOUD_BSSD"
  system_disk_size  = 150
  allocate_public_ip = true
  internet_max_bandwidth_out = 200
  vpc_id            = tencentcloud_vpc.vpc.id
  subnet_id         = tencentcloud_subnet.subnet_cvm.id
  orderly_security_groups  = var.security_groups_id
  key_ids = var.key_ids
  tags = var.Resource_tag
}


# 创建发布工具服务器
resource "tencentcloud_instance" "deploy_cvm" {
  instance_name     = var.deploy_cvm_name
  availability_zone = var.availability_zone
  # instance_charge_type = "PREPAID"
  # instance_charge_type_prepaid_period = "1"
  # instance_charge_type_prepaid_renew_flag = "NOTIFY_AND_AUTO_RENEW"
  image_id          = var.deploy_image_id
  instance_type     = "SA9.LARGE8"
  system_disk_type  = "CLOUD_BSSD"
  system_disk_size  = 50
  allocate_public_ip = true
  internet_max_bandwidth_out = 200
  vpc_id            = tencentcloud_vpc.vpc.id
  subnet_id         = tencentcloud_subnet.subnet_cvm.id
  orderly_security_groups  = var.security_groups_id
  key_ids = var.key_ids
  tags = var.Resource_tag
}


# 创建k8s和节点
resource "tencentcloud_kubernetes_cluster" "managed_cluster" {
  cluster_version         = "1.28.3"
  vpc_id                  = tencentcloud_vpc.vpc.id
  eni_subnet_ids          = ["${tencentcloud_subnet.subnet_k8s.id}"]
  service_cidr            = var.service_cidr
  cluster_name            = var.cluster_name
  cluster_max_service_num = 32768
  network_type            = "VPC-CNI"
  cluster_os              = "tlinux3.1x86_64"
  cluster_level           = "L5"
  tags                    = var.Resource_tag

  worker_config {
    count                      = 2
    availability_zone          = var.availability_zone
    instance_type              = "SA9.2XLARGE16"
    system_disk_type           = "CLOUD_BSSD"
    system_disk_size           = 50
    subnet_id                  = tencentcloud_subnet.subnet_k8s.id
    security_group_ids         = var.security_groups_id
    # instance_charge_type = "PREPAID"
    # instance_charge_type_prepaid_period = "1"
    # instance_charge_type_prepaid_renew_flag = "NOTIFY_AND_AUTO_RENEW"
    key_ids                    = var.key_ids
  }
}

# NAT网关
resource "tencentcloud_eip" "eip_example" {
  name = "nat_gateway_eip"
}

resource "tencentcloud_nat_gateway" "example" {
  name             = var.nat_name
  vpc_id           = tencentcloud_vpc.vpc.id
  nat_product_version  = 2
  zone = var.nat_zone
  assigned_eip_set = [
    tencentcloud_eip.eip_example.public_ip
  ]
  tags = var.Resource_tag
}

# cos桶
locals {
  app_id = var.app_id
  region = var.region
}

resource "tencentcloud_cos_bucket" "private_bucket" {
  bucket = "${var.bucket_name}-${local.app_id}"
  acl    = "public-read"
  tags   =  var.Resource_tag
}
