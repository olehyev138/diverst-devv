RSpec.shared_examples 'InvalidInputException when creating' do |model|
  it 'captures the error when InvalidInputException' do
    allow_any_instance_of(model.constantize).to receive(:save).and_return(false)
    allow_any_instance_of(model.constantize).to receive_message_chain(:errors, :full_messages) { [] }
    allow_any_instance_of(model.constantize).to receive_message_chain(:errors, :messages) { [[]] }
    post "/api/v1/#{route}", params: { "#{route.singularize}" => build(route.singularize.to_sym).attributes }, headers: headers
    expect(response).to have_http_status(422)
  end
end

RSpec.shared_examples 'InvalidInputException when updating' do |model|
  it 'captures the error when InvalidInputException' do
    allow_any_instance_of(model.constantize).to receive(:save).and_return(false)
    allow_any_instance_of(model.constantize).to receive_message_chain(:errors, :full_messages) { [] }
    allow_any_instance_of(model.constantize).to receive_message_chain(:errors, :messages) { [[]] }
    patch "/api/v1/#{route}/#{item.id}", params: { "#{route.singularize}" => item.attributes }, headers: headers
    expect(response).to have_http_status(422)
  end
end
