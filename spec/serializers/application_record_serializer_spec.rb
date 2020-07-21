require 'rails_helper'

RSpec.describe ApplicationRecordSerializer, type: :serializer do
  # MODEL VARIABLES
  # a: To test basic serialization of Model Methods
  # b: To test with_permissions of Model Methods
  # c: To test exclude_keys of Model Methods
  #
  # d: To test basic serialization of Serializer Methods
  # e: To test with_permissions of Serializer Methods
  # f: To test exclude_keys of Serializer Methods

  context 'Inheriting from ApplicationRecordSerializer' do
    let(:model1) {
      class ModelOne < ApplicationRecord
        attr_accessor :a, :b, :c
        def initialize(a, b, c); self.a = a; self.b = b; self.c = c end
        def attributes; { a: a, b: b, c: c } end
      end
      ModelOne
    }

    let(:model2) {
      class ModelTwo < ApplicationRecord
        attr_accessor :a, :b, :c
        def initialize(a, b, c); self.a = a; self.b = b; self.c = c end
        def attributes; { a: a, b: b, c: c } end
      end
      ModelTwo
    }

    let!(:policy1) {
      class ModelOnePolicy < ApplicationPolicy
        def index?;   true  end
        def show?;    false end
        def create?;  true  end
        def manage?;  false end
        def update?;  true  end
        def destroy?; false end
        def custom1?; true  end
        def custom2?; false end
      end
      ModelOnePolicy
    }

    let!(:policy2) {
      class ModelTwoPolicy < ApplicationPolicy
        def index?;   !true  end
        def show?;    !false end
        def create?;  !true  end
        def manage?;  !false end
        def update?;  !true  end
        def destroy?; !false end
        def custom1?; !true  end
        def custom2?; !false end
      end
      ModelTwoPolicy
    }

    let(:serializer1) {
      class ModelOneSerializer < ApplicationRecordSerializer
        def serialize_all_fields; true end
      end
      ModelOneSerializer
    }
    let(:serializer2) {
      class ModelTwoSerializer < ApplicationRecordSerializer
        def serialize_all_fields; false end
      end
      ModelTwoSerializer
    }

    let(:permission_module1) { serializer1.permission_module }
    let(:permission_module2) { serializer2.permission_module }

    it 'should create unique permissions module for each descendants' do
      expect(permission_module1).to be_a Module
      expect(permission_module2).to be_a Module
      expect(permission_module1).to_not be permission_module2
    end
  end
end
