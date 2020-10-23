#!/bin/ruby

#
## Deploy Diverst app to production environments
#

# TODO: pull from param key store
clients = [{ env_name: 'devops', bucket: 'devops-inmvlike', role_arn: 'arn:aws:iam::151631753575:role/cli-bot-devops-administrator-access' }]

# Authenticate with STS using given role, use `cli-assume-role` bash script
def auth_env(role_arn)
  # Returns 'export <SECRET_NAME>=<SECERT_VALUE>\n...'
  secrets = %x('./devops/scripts/cli-assume-role #{role_arn}')
  return unless secrets

  # Loop through secret name & value pair
  secrets.split("\n").each do |secret|
    # secret_pair looks like [ 'export <SECRET_NAME>', '<SECRET_VALUE>' ]
    secret_pair = secret.split('=')

    # extract secret_name & secret_value
    ENV[secret_pair[0].split(' ')[1]] = secret_pair[1]
  end
end

clients.each do |client|
  # auth with env account
  auth_env(client[:role_arn])

  # deploy backend
  version_label = '0123'
  %x("./devops/scripts/create-app-version #{client[:env]} #{version_label} #{client[:bucket]}")
  %x("./devops/scripts/deploy-app-version #{client[:env]}  #{version_label}")

  # deploy frontend

  %x("./devops/scripts/load-client-env #{client[:env]}")
  %x("./devops/scripts/deploy-frontend #{client[:frontend_bucket]})

  # deploy analytics

  # unset
end
