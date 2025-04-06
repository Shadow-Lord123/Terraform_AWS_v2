
# Declare the ECS Cluster
resource "aws_ecs_cluster" "foo" {
  name = "terraform-ecs-cluster"
}

# Declare the ECS Task Definition
resource "aws_ecs_task_definition" "mongo" {
  family                   = "mongo-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([{
    name      = "mongo"
    image     = "mongo:latest"
    essential = true
    portMappings = [
      {
        containerPort = 8080
        hostPort      = 8080
        protocol      = "tcp"
      }
    ]
  }])
}

# Create a Security Group for the ECS Service (if needed)
resource "aws_security_group" "ecs_sg" {
  name        = "terraform-ecs-sg"
  description = "Security group for ECS service"
  vpc_id      = var.vpc_id  # Make sure to specify the VPC ID here

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow incoming traffic on port 8080 (if needed)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Allow all outgoing traffic
  }
}

# Declare the ECS Service without Load Balancer
resource "aws_ecs_service" "mongo" {
  name            = "terraform-mongodb"
  cluster         = aws_ecs_cluster.foo.id  # Reference the ECS cluster
  task_definition = aws_ecs_task_definition.mongo.arn  # Reference the ECS task definition
  desired_count   = 3

  # No load balancer specified
  # Direct access to the task is possible if public IP is assigned to the task
  
  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [eu-west-2a, eu-west-2b]"
  }

  network_configuration {
    subnets          = [var.public_subnet_1_id, var.public_subnet_2_id]  # Reference subnet variables
    assign_public_ip = false  # Assign public IPs if needed
  }

  launch_type = "EC2"  # Explicitly set to EC2 launch type

  depends_on = []  # No dependency on load balancer or target group
}
