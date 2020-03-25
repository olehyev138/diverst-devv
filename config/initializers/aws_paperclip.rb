# Set deprecated aws-sdk constant for paperclip s3 usage
# See: https://github.com/thoughtbot/paperclip/issues/2484#issuecomment-335040294
Aws::VERSION =  Gem.loaded_specs["aws-sdk"].version if defined?(Aws)
