#CODECOMMIT REPOSITORY
resource "aws_codecommit_repository" "repo" {
  repository_name = var.repo_name
}

# CODEBUILD
resource "aws_codebuild_project" "dev_backend_build" {
  name         = var.build_project
  service_role = aws_iam_role.codebuild-role-dev-backend.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  source {
    type     = "CODECOMMIT"
    location = aws_codecommit_repository.repo.clone_url_http
    buildspec = "dev-buildspec.yml"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:5.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true

    environment_variable {
      name  = "USER_DATABASE"
      type  = "SECRETS_MANAGER"
      value = aws_secretsmanager_secret_version.ecsbackend.arn
    }

    environment_variable {
      name  = "PASSWORD_DATABASE"
      type  = "SECRETS_MANAGER"
      value = aws_secretsmanager_secret_version.ecsbackend.arn
    }

    environment_variable {
      name  = "dockerhub_username"
      type  = "PLAINTEXT"
      value = "vimalr"
    }

    environment_variable {
      name  = "dockerhub_password"
      type  = "SECRETS_MANAGER"
      value = aws_secretsmanager_secret_version.ecsbackend.arn
    }

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      type  = "PLAINTEXT"
      value = "714732271094"
    }

    environment_variable {
      name  = "IMAGE_REPO_NAME"
      type  = "PLAINTEXT"
      value = "xyz-dev-backend"
    }

    environment_variable {
      name  = "IMAGE_TAG"
      type  = "PLAINTEXT"
      value = "latest"
    }
  }

  depends_on = [
    aws_ecs_service.backend
  ]
}

# S3 BUCKET FOR ARTIFACTORY_STORE
resource "aws_s3_bucket" "dev-bucket-artifact" {
  bucket = "api-dev-artifactory-bucket001"
  acl    = "private"
}

resource "aws_codestarconnections_connection" "backend" {
  name          = "xyz-dev-backend-connection"
  provider_type = "GitHub"
}

# CODEPIPELINE
resource "aws_codepipeline" "dev_pipeline" {
  name     = join("-", ["backend-pipeline", "dev"])
  role_arn = data.aws_iam_role.pipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.dev-bucket-artifact.bucket
    type     = "S3"
  }

  # SOURCE
  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.backend.arn
        FullRepositoryId = "${var.repo_owner}/${var.repo_name}"
        BranchName       = var.branch
      }
    }
  }

  # BUILD
  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]

      configuration = {
        ProjectName = var.build_project
      }
    }
  }

  # DEPLOY
  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      version         = "1"
      input_artifacts = ["build_output"]

      configuration = {
        ClusterName = aws_ecs_cluster.dev-backend.name
        ServiceName = aws_ecs_service.backend.name
        FileName    = "imagedefinitions.json"
      }
    }
  }
}
