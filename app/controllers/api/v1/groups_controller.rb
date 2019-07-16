class Api::V1::GroupsController < DiverstController
  def index
    params.permit![:parent_id] = nil

    render status: 200, json: klass.index(self.diverst_request, params)
  end
end
