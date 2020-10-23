#!/bin/ruby

#
## Deploy Diverst app to production environments
#

# TODO: pull from param key store
clients = [{ env: 'devops',
             bucket: 'devops-inmvlike',
             frontend: 'devops.diverst.com',
             role_arn: 'arn:aws:iam::151631753575:role/cli-bot-devops-administrator-access' }]

#
## Authenticate with env account using STS with, use `cli-assume-role` bash script
#
def auth_env(role_arn)
  # Returns 'export <SECRET_NAME>=<SECERT_VALUE>\n...'
  secrets = `./devops/scripts/cli-assume-role #{role_arn}`
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
  # set access keys & auth with env account using STS
  ENV['AWS_ACCESS_KEY_ID'] = ENV['CCI_AWS_ACCESS_KEY_ID']
  ENV['AWS_SECRET_ACCESS_KEY'] = ENV['CCI_AWS_SECRET_ACCESS_KEY']
  auth_env(client[:role_arn])

  # deploy backend
  version_label = 'test-0123'
  `./devops/scripts/create-app-version #{client[:env]} #{version_label} #{client[:bucket]}`
  `./devops/scripts/deploy-app-version #{client[:env]} #{version_label}`

  # deploy frontend
  `./devops/scripts/load-client-env #{client[:env]}`
  `./devops/scripts/deploy-frontend #{client[:frontend]}`

  # deploy analytics - TODO
end
