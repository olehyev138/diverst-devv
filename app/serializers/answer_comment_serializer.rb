class AnswerCommentSerializer < ApplicationRecordSerializer
  attributes :author

  def author
    new_scope = scope.dup
    new_scope[:action] = 'index'
    UserSerializer.new(object.author, **instance_options, scope: new_scope)
  end

  def serialize_all_fields
    true
  end
end
