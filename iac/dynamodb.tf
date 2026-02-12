resource "aws_dynamodb_table" "user_profiles" {
  name         = "${var.project_name}-user-profiles"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "userId"

  attribute {
    name = "userId"
    type = "S"
  }

  tags = {
    Name = "GameZone User Profiles"
  }
}

resource "aws_dynamodb_table" "game_scores" {
  name         = "${var.project_name}-game-scores"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "userId"
  range_key    = "gameId"

  attribute {
    name = "userId"
    type = "S"
  }

  attribute {
    name = "gameId"
    type = "S"
  }

  attribute {
    name = "score"
    type = "N"
  }

  global_secondary_index {
    name            = "GameScoreIndex"
    hash_key        = "gameId"
    range_key       = "score"
    projection_type = "ALL"
  }

  tags = {
    Name = "GameZone Game Scores"
  }
}
