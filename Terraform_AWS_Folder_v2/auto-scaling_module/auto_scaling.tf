
resource "aws_launch_template" "foobar" {
  name_prefix   = "foobar"
  image_id      = "ami-0aa35885dc2443bb3"
  instance_type = "t2.micro"
}

resource "aws_autoscaling_group" "bar" {
  name                      = "foobar3-terraform-test"
  max_size                  = 5
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 4
  force_delete              = true
  #placement_group           = aws_placement_group.test.id
  vpc_zone_identifier       = [var.public_subnet_1_id, var.public_subnet_2_id]

  launch_template {
    id      = aws_launch_template.foobar.id
    version = "$Latest"
  }

  instance_maintenance_policy {
    min_healthy_percentage = 90
    max_healthy_percentage = 120
  }

  tag {
    key                 = "foo"
    value               = "bar"
    propagate_at_launch = true
  }

  timeouts {
    delete = "15m"
  }

  tag {
    key                 = "lorem"
    value               = "ipsum"
    propagate_at_launch = false
  }
}
