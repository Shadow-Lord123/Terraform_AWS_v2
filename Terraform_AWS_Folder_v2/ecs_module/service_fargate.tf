
resource "aws_security_group" "ecs_fargate_sg" {
  name        = "ecs-fargate-sg"
  description = "SG for Fargate Mongo service"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_service" "mongo_fargate" {
  name            = "terraform-mongo-fargate"
  cluster         = aws_ecs_cluster.foo.id
  task_definition = aws_ecs_task_definition.mongo_fargate.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [var.public_subnet_1_id, var.public_subnet_2_id]
    security_groups  = [aws_security_group.ecs_fargate_sg.id]
    assign_public_ip = true
  }
}
