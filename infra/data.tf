data "aws_iam_role" "pipeline_role" {
  name = "codepipeline-role"
}

data "aws_iam_role" "ecs-task-dev-backend" {
  name = "ecsTaskExecutionRole"
}
