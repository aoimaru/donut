# 作成リソース
# プライベート想定のサブネット2つ(1a, 1c)と
# パブリック想定のサブネット2つ(1a, 1c)を作成


# パブリックサブネット1a
resource "aws_subnet" "public_subnet_1a" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1a"
  cidr_block              = local.subnet_cidr_blocks[0]
  map_public_ip_on_launch = true

  tags = {
    Name    = "${var.project}-${var.environment}-${var.ver}-public-subnet-1a"
    Project = var.project
    Env     = var.environment
    Type    = "public"
    Ver     = var.ver
  }
}

# パブリックサブネット1c
resource "aws_subnet" "public_subnet_1c" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1c"
  cidr_block              = local.subnet_cidr_blocks[1]
  map_public_ip_on_launch = true

  tags = {
    Name    = "${var.project}-${var.environment}-${var.ver}-public-subnet-1c"
    Project = var.project
    Env     = var.environment
    Type    = "public"
    Ver     = var.ver
  }
}

# プライベートサブネット1a
resource "aws_subnet" "private_subnet_1a" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1a"
  cidr_block              = local.subnet_cidr_blocks[2]
  map_public_ip_on_launch = false

  tags = {
    Name    = "${var.project}-${var.environment}-${var.ver}-private-subnet-1a"
    Project = var.project
    Env     = var.environment
    Type    = "private"
    Ver     = var.ver
  }
}

# プライベートサブネット1c 
resource "aws_subnet" "private_subnet_1c" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1c"
  cidr_block              = local.subnet_cidr_blocks[3]
  map_public_ip_on_launch = false

  tags = {
    Name    = "${var.project}-${var.environment}-${var.ver}-private-subnet-1c"
    Project = var.project
    Env     = var.environment
    Type    = "private"
    Ver     = var.ver
  }
}
