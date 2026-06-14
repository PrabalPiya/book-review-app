project_name = "book-review"
environment  = "dev"
aws_region   = "ap-south-1"

availability_zones = ["ap-south-1a", "ap-south-1b"]

node_instance_type = "t3.small"
node_desired_size  = 2
node_min_size      = 1
node_max_size      = 3

db_name           = "bookreviewdb"
db_username       = "admin"
db_instance_class = "db.t3.medium"