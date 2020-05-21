def ind(model)
  model.__elasticsearch__.delete_index!(force: true)
  model.__elasticsearch__.create_index!(force: true)
  model.__elasticsearch__.import
end
