# Fields (Backend)

## The Relationships
By far the most important part in understanding how fields work is to first understand the structure of how everything 
is related.

In the following diagram, A <- B, means A has many B, and B belongs to A
- Field Definer
    - An object which holds the definition of custom fields
- Fields:
    - The actual custom fields
- Field Users:
    - The objects which contains field data objects
- Field Data
    - Holds the actual data for each Field User, Field pair
```
+---------------+         +-------------+
|               |         |             |
| Field Definer +<--------+ Field Users |
|               |         |             |
+-------+-------+         +------+------+
        ^                        ^
        |                        |
+-------+-------+         +------+------+
|               |         |             |
|    Fields     +<--------+ Field Data  |
|               |         |             |
+---------------+         +-------------+
```

As an example, let's consider Custom Fields for users.

An `Enterprise` defines the following custom fields to use for `Users`:
- Gender with options [Male, Female, Other]
- Date of Birth
- And spoken languages with all options

Now when a `User` is modifying their profile, they can now fill in data for the custom fields defined by its
`field_definer`

So now, a user, like Alex, can set his gender as Male, his DOB as June 6th, and his spoken languages as English 
and Pig Latin.
These Data are then stored in Field Data, so there will be an entry in FieldData with `field_user = Alex`,
`field = gender`, and `data = 'Male'`

## Existing Field Users and Definers
At present, there are 5 relevant Definer/User Pairs:
- `Enterprise` and `Users`
    - For defining custom fields for a user profile
- `Poll` and `PollResponses`
    - For defining custom questions for enterprise polls
- `Group` and `UserGroups`
    - For defining custom questions for group member survey's
- `Group` and `GroupUpdates`
    - For the purposes of defining custom metrics per group for KPI
- `Initiative` and `InitiativeUpdates`
    - For the purposes of defining custom metrics per event for KPI
    
## The `ContainsFieldData` Module, and the Requirements of a Field User

#### Requirements
Each model which would contain FieldData, needs these 5 thing in order to function
- a class variable `@@field_definer_name`, which holds the name of the `belongs_to` association witch points to the
field definer
- another class variable `@@field_association_name`, which holds the name of the `has_many` association between the
field definer and its fields
- a model attribute readers for said variables `mattr_reader :field_association_name, :field_definer_name`
- include the `ContainsFieldData` module
- a `has_many` association to fields called `field_data` with the options
    - as: :field_user,
    - dependent: :destroy

for example, here is a snippet from `UserGroup`:
```
class UserGroup < ApplicationRecord
  @@field_definer_name = 'group'
  @@field_association_name = 'survey_fields'
  mattr_reader :field_association_name, :field_definer_name

  include ContainsFieldData
  # ...
  has_many :field_data, class_name: 'FieldData', as: :field_user, dependent: :destroy
  # ...
end 
```
#### ContainsFieldData
By including `ContainsFieldData`, you gain access to the following functions:
- Instance Methods (For these, assume I started by running `u = User.first`)
    - :fields, returns the list of fields defined by its definer
        - ``` 
          u.fields
               Enterprise Load (0.3ms)  SELECT  `enterprises`.* FROM `enterprises` WHERE `enterprises`.`id` = 1 LIMIT 1
               Field Exists (0.2ms)  SELECT  1 AS one FROM `fields` WHERE `fields`.`field_definer_id` = 1 AND `fields`.`field_definer_type` = 'Enterprise' AND `fields`.`elasticsearch_only` = FALSE LIMIT 1
               Field Load (0.3ms)  SELECT `fields`.* FROM `fields` WHERE `fields`.`field_definer_id` = 1 AND `fields`.`field_definer_type` = 'Enterprise' AND `fields`.`elasticsearch_only` = FALSE
          => [ #<SelectField:0x000055c3987e5138>, ... ]
          ```
    - :field_definer, returns the field defined
        - ``` 
          u.field_definer
            Enterprise Load (0.2ms)  SELECT  `enterprises`.* FROM `enterprises` WHERE `enterprises`.`id` = 1 LIMIT 1
          => #<Enterprise:0x000055c397e6d4e8>
    - :field_definer_id, returns the id of the field defined
        - ``` 
          u.field_definer_id
          => 1
          ```
    - :load_field_data, creates getters and setters for the field data
        - ``` 
          u.load_field_data
            FieldData Load (1.1ms)  SELECT  `field_data`.* FROM `field_data` WHERE `field_data`.`field_user_id` = 1 AND `field_data`.`field_user_type` = 'User' ORDER BY `field_data`.`id` ASC LIMIT 1000
            Field Load (0.5ms)  SELECT `fields`.* FROM `fields` WHERE `fields`.`id` IN (5, 15, 6, 7, 8, 9, 10, 11, 12, 13, 14, 16, 17, 18, 19, 20, 21, 22, 23, 58, 73)
          
          u.gender
          => "AGender"
          
          u.gender = ['Male']
             (0.4ms)  BEGIN
            FieldData Update (0.7ms)  UPDATE `field_data` SET `data` = '[\"Male\"]', `updated_at` = '2020-01-02 16:50:50' WHERE `field_data`.`id` = 1
             (2.3ms)  COMMIT
          ```
    - :create_missing_field_data(*ids), checks to see if there are fields defined but, no field_data for them, and creates
    the field data that is missing
        - if no IDs are provided, it will check if the field_user has field_data for the fields of the `:fields` method
        - if they are it filters the scope of checking to the fields from the `:fields` method which have an id among
         the provided
- Class Methods
    - The only class method which exist is a variation on the `:load_field_data` instance method, however instead of
    calling it on a individual, it calls it on an active record (or model).
    - ``` 
      us = User.where('id < 10').load_field_data
          User Load (0.8ms)  SELECT `users`.* FROM `users` WHERE (id < 10)
          FieldData Load (1.4ms)  SELECT `field_data`.* FROM `field_data` WHERE `field_data`.`field_user_type` = 'User' AND `field_data`.`field_user_id` IN (1, 2, 3, 4, 5, 6, 7, 8, 9)
          Field Load (0.4ms)  SELECT `fields`.* FROM `fields` WHERE `fields`.`id` IN (5, 15, 6, 7, 8, 9, 10, 11, 12, 13, 14, 16, 17, 18, 19, 20, 21, 22, 23, 58, 73)
      => [ #<User:0x000055c39596f380>, ... ]
      
      us.map(&:date_of_birth)
      => [ "\"1987-03-28\"", "\"1998-02-20T19:00:00-05:00\"", "\"1960-03-24T19:00:00-05:00\"", ... ]
      ```
    - A warning, the class method `:load_field_data` does NOT return the active record query but instead returns the
    evaluation of an active_record query, so make sure to call it last if you want to call it.
- Callbacks
    - `after_create :create_missing_field_data`
        - After the creation of an object which contains field_data, it will automatically create field_data for it.
        
## The `DefinesFields` Module, and the Requirements of a Field Definer
#### Requirements
Each model which would contain FieldData, needs these 4 thing in order to function
- a class variable `@@field_users`, which holds the names of the `has_many` associations witch points to the field users
- a model attribute readers for said variables `mattr_reader :field_users`
- include the `DefinesFields` module
- a `has_many` association to fields with the options
    - as: :field_definer
    - class_name: 'Field' (if association isn't called `fields`)
    - dependent: :destroy
    - after_add: :add_missing_field_background_job

for example, here is a snippet from `Group`:
```
class Group < ApplicationRecord
  # ...
  include DefinesFields
  # ...
  @@field_users = [:user_groups, :updates]
  mattr_reader :field_users

  # ...
  has_many :fields, -> { where field_type: 'regular' },
             as: :field_definer,
             dependent: :destroy,
             after_add: :add_missing_field_background_job
  has_many :survey_fields, -> { where field_type: 'group_survey' },
             as: :field_definer,
             class_name: 'Field',
             dependent: :destroy,
             after_add: :add_missing_field_background_job
  # ...
end 
```

#### DefinesFields
By including `DefinesFields`, you gain access to the following functions:
- :create_missing_field_data
    - Calls the function of the same name on all its field_users
- :add_missing_field_background_job(field)
    - Creates a background job which calls `create_missing_field_data(field.id)`
    
The purpose behind the `after_add` callback is to make sure that field_users are being left behind,
while at the same time, considering an Enterprise can have 10000+ users, waiting for it to finish will
clog up the requests, so it is moved to a background job.

## The Fields Controllers and Actions
Though not fully implemented yet, ideally, we want to not query fields on the fields controller directly
but instead query of the definer's controller. This has two benefits (for index, and create):
1. Policies can be defined by the permissions of the definer
2. Less likely to mis-assign an association, and prevents exposing the implementation of polymorphism

To this, let's look at how field "index" and "create" are handled in the enterprise controller

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

If you notice, these are essentially identical to the regular index and create controller methods, with 4 differences:
1. You first obtain a copy of the enterprise first
2. Instead of doing `klass.index` or `klass.build`, you call `Field.index` and `Field.build`
3. in the `index` and `build` function call, you'll notice the argument `base:`. If defined, it will take the place of what
would be the `klass/self`
    - ex1: `Field.new` => `enterprise.fields.new`
    - ex2: `@items = policy_scope.new(current_user, Field).resolve` 
    => `@items = policy_scope.new(current_user, enterprise.fields).resolve`
4. Create has it's own payload, and you have to explicitly assign it to `params[:field]`

For show, update and delete Policies, they will all check the `update?` policy of their `field_definer`