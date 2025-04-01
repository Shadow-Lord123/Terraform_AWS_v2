
resource "aws_lb" "example" {
  name               = "example"
  internal           = false  # Ensure it's public
  load_balancer_type = "network"

  subnet_mapping {
    subnet_id     = var.public_subnet_1_id
    allocation_id = aws_eip.nlb_eip_1.id  # Associate Elastic IP
  }

  subnet_mapping {
    subnet_id     = var.public_subnet_2_id
    allocation_id = aws_eip.nlb_eip_2.id  # Associate Elastic IP
  }
}

# Create Elastic IPs for the public NLB
resource "aws_eip" "nlb_eip_1" {
}

resource "aws_eip" "nlb_eip_2" {
}
