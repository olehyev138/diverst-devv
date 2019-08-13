Rails.application.config.middleware.use OmniAuth::Builder do
  # provider :linkedin, ENV['LINKEDIN_ID'], ENV['LINKEDIN_SECRET']
  # provider :slack, '6867881287.709097094274', 'b08e91edfabf7de4815bf1e029780346', scope: 'chat:write:bot'
end
