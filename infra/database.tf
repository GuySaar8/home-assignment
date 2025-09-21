################################################################################
# RDS Module
################################################################################

module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 6.0"

  identifier = "hello-world-${local.tags.Environment}"

  # Engine options
  engine               = "postgres"
  engine_version       = "14"
  family               = "postgres14"
  major_engine_version = "14"
  instance_class       = "db.t3.micro"

  # Storage
  allocated_storage     = 5  # Minimum storage for RDS is 5GB
  max_allocated_storage = 10 # Cap at 10GB, more than enough for visit logs

  # Credentials
  db_name                     = "hello_world"
  username                    = "hello_world_user"
  port                        = 5432
  password                    = random_password.db_password.result # Use the generated password
  manage_master_user_password = false                              # Disable AWS automatic password management

  # Network
  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = module.vpc.database_subnet_group_name

  # Backup
  backup_retention_period = 7
  skip_final_snapshot     = true

  # Disable enhanced monitoring to avoid role configuration complexity
  monitoring_interval = 0

  # Tags
  tags = local.tags
}

# Security Group for RDS
resource "aws_security_group" "rds" {
  name_prefix = "hello-world-${local.tags.Environment}-rds"
  description = "Allow database traffic from EKS cluster"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "PostgreSQL from EKS cluster"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [module.eks.cluster_security_group_id]
  }

  ingress {
    description     = "PostgreSQL from EKS worker nodes"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [module.eks.node_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.tags
}
