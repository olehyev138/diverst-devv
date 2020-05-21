# Module to create a KMS key for encrpyting the envs secrets
# - key is used by chamber and requires an alias 'parameter_store_key'

resource "aws_kms_key" "parameter_store_key" {
  description = "Encryption key for parameter store secrets"
}

resource "aws_kms_alias" "parameter_store_key_alias" {
  name          = "alias/parameter_store_key"
  target_key_id = aws_kms_key.parameter_store_key.id
}
