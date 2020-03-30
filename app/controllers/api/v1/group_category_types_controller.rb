class Api::V1::GroupCategoryTypesController < DiverstController
  def payload
    params
        .require(klass.symbol)
        .permit(
            :id,
            :name,
            group_categories_attributes: [
                :id,
                :name,
                :_destroy
            ])
  end
end
