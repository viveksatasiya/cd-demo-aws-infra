aws_region    = "ap-south-1"
vpc_cidr      = "10.0.0.0/16"
subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
cluster_name  = "CD_DEMO"
task_family   = "family"
desired_count = 2

ec2_ami_id           = "ami-0036f358750e191d0"
ec2_instance_type    = "t2.small"
asg_min_size         = 1
asg_max_size         = 3
asg_desired_capacity = 2

task_memory = 512
task_cpu    = 256
