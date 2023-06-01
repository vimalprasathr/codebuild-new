resource "aws_subnet" "dev_rds_subnet_1" {
  vpc_id            = module.vpc.vpc_id
  cidr_block        = "10.0.10.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {

  }
}

resource "aws_subnet" "dev_rds_subnet_2" {
  vpc_id            = module.vpc.vpc_id
  cidr_block        = "10.0.11.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = {

  }
}

resource "aws_db_subnet_group" "dev_rds" {
  name        = "dev_rds"
  description = "subnet group for rds"
  subnet_ids  = [aws_subnet.dev_rds_subnet_1.id, aws_subnet.dev_rds_subnet_2.id]

  tags = {
  }
}
