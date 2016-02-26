after :enterprise do
  enterprise = Enterprise.last

  # ERG invitation

  email = enterprise.emails.create(
    name: 'ERG invitation',
    slug: 'group-invitation'
  )

  email.variables.create(
    key: 'group.name',
    description: 'The name of the group',
    required: false
  )

  email.variables.create(
    key: 'group.description',
    description: 'The group\'s description',
    required: false
  )

  email.variables.create(
    key: 'accept_link',
    description: 'The URL to accept the invitation',
    required: true
  )


  # Group message

  email = enterprise.emails.create(
    name: 'ERG message',
    slug: 'group-message'
  )

  email.variables.create(
    key: 'group.name',
    description: 'The name of the group',
    required: false
  )

  email.variables.create(
    key: 'group.description',
    description: 'The group\'s description',
    required: false
  )

  email.variables.create(
    key: 'message.subject',
    description: 'The message\'s subject',
    required: false
  )

  email.variables.create(
    key: 'message.content',
    description: 'The message\'s content',
    required: false
  )
end