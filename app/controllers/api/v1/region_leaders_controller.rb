class Api::V1::RegionLeadersController < DiverstController
  include Api::V1::Concerns::PolymorphicKeys
  POLYMORPHIZE_LEADER_OF_QUERY, POLYMORPHIZE_LEADER_OF_COMMIT = create_polymorphize_callbacks(:leader_of, Region)

  before_action POLYMORPHIZE_LEADER_OF_QUERY, only: [:show, :index]
  before_action POLYMORPHIZE_LEADER_OF_COMMIT, only: [:create, :update]

  protected def klass
    GroupLeader
  end
end
