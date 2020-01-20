# Fields (API)

## Actions

Like usual, fields have 5 actions
- index
- show
- create
- update
- delete

However, where fields differ is that for index and create, instead of querying fields directly, we have to query them
through their definer.

To do this, inside the controller of the FieldDefiner (for example enterprise), you have to define new actions
```ruby
  def fields
    item = klass.find(params[:id])
    base_authorize(item)

    render status: 200, json: Field.index(self.diverst_request, params.except(:id).permit!, base: item.fields)
  rescue => e
    raise BadRequestException.new(e.message)
  end

  def create_field
    params[:field] = field_payload
    base_authorize(klass)
    item = klass.find(params[:id])

    render status: 201, json: Field.build(self.diverst_request, params, base: item.fields)
  rescue => e
    case e
    when InvalidInputException
      raise
    else
      raise BadRequestException.new(e.message)
    end
  end
```
What these do is it first get the instance of the FieldDefiner, then calls `Field.index` or `Field.build`, with
`item.fields` as a base.

This will cause index to limit it's scope to its fields, and cause `build` to call `item.fields.new` creating a field for
that specific definer.

Next, we need to add these actions to the routes. Again, we add these actions to the members of a field definer
```ruby
resources :enterprises do
  member do
    get  '/fields',       to: 'enterprises#fields'
    post '/create_field', to: 'enterprises#create_field'
  end
end
```

After this is done, to query the fields, these are the paths to use
- index
    - `GET` /:field_definer/:field_definer_id/fields
- show
    - `GET` /fields/:id
- create
    - `POST` /:field_definer/:field_definer_id/fields
- update
    - `PUT/PATCH` /fields/:id
- delete
    - `DELETE` /fields/:id
