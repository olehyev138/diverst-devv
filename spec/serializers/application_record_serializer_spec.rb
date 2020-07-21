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
    let(:model) {
      class ModelOne
        include ActiveModel::Model
        attr_accessor :a, :b, :c
        validates :a, :b, :c, presence: true
        def attributes; { a: a, b: b, c: c } end
      end
      ModelOne
    }
    let!(:policy) {
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
    let(:serializer1) {
      class ModelOneSerializer < ApplicationRecordSerializer
        def serialize_all_fields; true end
        def excluded_keys; [:c, :f] end
      end
      ModelOneSerializer
    }
    let(:serializer2) {
      class ModelTwoSerializer < ApplicationRecordSerializer
        def serialize_all_fields; false end
        def excluded_keys; [:c, :f] end
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

    context 'serialize_all_fields' do
      before do
        serializer1.define_method :serialize_all_fields do true end
      end

      it 'has :a and :b as attributes on first instantiation' do
        expect(serializer1._attributes).to     be_empty

        serializer1.new(model.new)

        expect(serializer1._attributes).to     include :a
        expect(serializer1._attributes).to     include :b
        expect(serializer1._attributes).to_not include :c
        expect(serializer1._attributes).to_not include :d
        expect(serializer1._attributes).to_not include :e
        expect(serializer1._attributes).to_not include :f
      end
    end
  end
end
