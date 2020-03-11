output "db_address" {
  value         = aws_db_instance.db.address
  description   = "Hostname of database instance"
}

output "db_username" {
  value         = aws_db_instance.db.username
  description   = "The master username for the database"
}

output "db_port" {
  value         = aws_db_instance.db.port
  description   = "The database port"
}
