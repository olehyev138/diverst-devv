group_ids = Group.ids
employee_ids = Employee.ids

employee_ids.each do |employee_id|
  groups_to_join = group_ids.sample([1, 1, 1, 1, 2, 2, 3].sample)

  groups_to_join.each do |g_id|
    EmployeeGroup.create(employee_id: employee_id, group_id: g_id)
  end
end