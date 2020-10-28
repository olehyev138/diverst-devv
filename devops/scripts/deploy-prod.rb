#!/bin/ruby

require 'json'

#
## Deploy Diverst app to all production environments
#

#
## Load list of client hashes from parameter store in main (Diverst) account
#
def load_clients
  clients = []
  client_names = `chamber list-services`.split("\n")[1..]

  client_names.each do |client|
    clients.push(JSON.parse(`chamber export --format json #{client}`).transform_keys(&:to_sym))
  end

  clients
end

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

version_label = ARGV[0]
clients = load_clients

clients.each do |client|
  # reset access keys to main account & auth with env account using STS
  ENV['AWS_ACCESS_KEY_ID'] = ENV['CCI_AWS_ACCESS_KEY_ID']
  ENV['AWS_SECRET_ACCESS_KEY'] = ENV['CCI_AWS_SECRET_ACCESS_KEY']
  auth_env(client[:role_arn])

  # deploy backend
  `./devops/scripts/create-app-version #{client[:env]} #{version_label} #{client[:master_bucket]}`
  `./devops/scripts/deploy-app-version #{client[:env]} #{version_label}`

  # deploy frontend
  `./devops/scripts/load-client-env #{client[:env]}`
  `./devops/scripts/deploy-frontend #{client[:frontend_bucket]}`

  # deploy analytics - TODO
end
