resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr

    lifecycle {
    prevent_destroy = false
    }
    

    tags = {
        Name = var.vpc_name
    }
}


resource "aws_subnet" "public1" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.public1_cidr
    availability_zone = var.publicsubnet1_az
}

resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
        Name = "${var.vpc_name}-public-rt"
    }
}

resource "aws_route_table_association" "public1_rta" {
    subnet_id = aws_subnet.public1.id
    route_table_id = aws_route_table.public_rt.id
}


resource "aws_subnet" "public2" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.public2_cidr
    availability_zone = var.publicsubnet2_az
}

resource "aws_route_table_association" "public2_rta" {
    subnet_id = aws_subnet.public2.id
    route_table_id = aws_route_table.public_rt.id
}

resource "aws_subnet" "private1" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.private1_cidr
    availability_zone = var.privatesubnet1_az
}

resource "aws_route_table" "private_rt1" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.natgw1.id
    }
}

resource "aws_route_table_association" "private1_rta" {
    subnet_id = aws_subnet.private1.id
    route_table_id = aws_route_table.private_rt1.id
}


resource "aws_route_table" "private_rt2" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.natgw2.id
    }
}


resource "aws_subnet" "private2" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.private2_cidr
    availability_zone = var.privatesubnet2_az
}

resource "aws_route_table_association" "private2_rta" {
    subnet_id = aws_subnet.private2.id
    route_table_id = aws_route_table.private_rt2.id

}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id

    tags = {
        Name = "${var.vpc_name}-igw"
    }
}

resource "aws_eip" "nat1" {
    domain = "vpc"
    # depends_on = [aws_internet_gateway.igw]

    tags = {
        Name = "${var.vpc_name}-natgw-eip1"
    }
}

resource "aws_nat_gateway" "natgw1" {
    allocation_id = aws_eip.nat1.id 
    subnet_id = aws_subnet.public1.id

    tags = {
        Name = "${var.vpc_name}-natgw1"
    }
}

resource "aws_eip" "nat2" {
    domain = "vpc"
    # depends_on = [aws_internet_gateway.igw]

    tags = {
        Name = "${var.vpc_name}-natgw-eip2"
    }
}

resource "aws_nat_gateway" "natgw2" {
    allocation_id = aws_eip.nat2.id
    subnet_id = aws_subnet.public2.id

    tags = {
        Name = "${var.vpc_name}-natgw2"
    }
}

