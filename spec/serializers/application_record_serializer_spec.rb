require 'rails_helper'

RSpec.describe ApplicationRecordSerializer, type: :serializer do
  # MODEL VARIABLES
  # a: To test basic serialization of Model Methods
  # b: To test with_permissions of Model Methods
  # c: To test exclude_keys of Model Methods
  #
  # d: To test basic serialization of Serializer Methods
  # e: To test with_permissions of Serializer Methods
  # f: To test exclusive with_permissions of Serializer Methods

  context 'Inheriting from ApplicationRecordSerializer' do
    let(:model) {
      Class.new do
        include ActiveModel::Model
        include ActiveModel::Serialization
        attr_accessor :a, :b, :c
        validates :a, :b, :c, presence: true
        def attributes; { a: a, b: b, c: c } end
      end
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

    before :each do
      @serializer1 = Class.new(ApplicationRecordSerializer) do
        def excluded_keys; [:c, :f] end
      end

      @serializer2 = Class.new(ApplicationRecordSerializer) do
        def excluded_keys; [:c, :f] end
      end

      @permission_module1 = @serializer1.permission_module
      @permission_module2 = @serializer2.permission_module
    end

    it 'should create unique permissions module for each descendants' do
      expect(@permission_module1).to be_a Module
      expect(@permission_module2).to be_a Module
      expect(@permission_module1).to_not be @permission_module2
    end

    describe 'Attributes' do
      context 'serialize_all_fields is true' do
        before :each do
          @serializer1.define_method :serialize_all_fields do true end
        end

        it 'has :a and :b as attributes on first instantiation' do
          pp @serializer1.object_id
          expect(@serializer1._attributes).to     be_empty

          serializer = @serializer1.new(model.new({a: 1, b: 2, c: 3}))

          expect(@serializer1._attributes).to     include :a
          expect(@serializer1._attributes).to     include :b
          expect(@serializer1._attributes).to_not include :c
          expect(@serializer1._attributes).to_not include :d
          expect(@serializer1._attributes).to_not include :e
          expect(@serializer1._attributes).to_not include :f

          expect(serializer.serializable_hash[:a]).to eq 1
          expect(serializer.serializable_hash[:b]).to eq 2
        end
      end

      context 'serialize_all_fields is false, nothing is defined' do
        it 'has :a and :b as attributes on first instantiation' do
          pp @serializer1.object_id
          expect(@serializer1._attributes).to     be_empty

          serializer = @serializer1.new(model.new({a: 1, b: 2, c: 3}))

          expect(@serializer1._attributes).to     be_empty
        end
      end

      context 'with extra fields' do
        before :each do
          @serializer1.attributes :d, :e
          @serializer1.define_method :d do 2 * object.a end
          @serializer1.define_method :e do 2 * object.b end
        end

        it 'it will serializes d and e' do
          expect(@serializer1._attributes).to_not include :a
          expect(@serializer1._attributes).to_not include :b
          expect(@serializer1._attributes).to_not include :c
          expect(@serializer1._attributes).to     include :d
          expect(@serializer1._attributes).to     include :e
          expect(@serializer1._attributes).to_not include :f

          a = model.new({a: 1, b: 2, c: 3})
          serializer = @serializer1.new(a)

          expect(serializer.serializable_hash[:d]).to eq 2
          expect(serializer.serializable_hash[:e]).to eq 4
        end
      end

      context 'all fields' do
        before :each do
          @serializer1.attributes :a, :b, :d, :e
          @serializer1.define_method :d do 2 * object.a end
          @serializer1.define_method :e do 2 * object.b end
        end

        it 'it serializes all the fields' do
          expect(@serializer1._attributes).to     include :a
          expect(@serializer1._attributes).to     include :b
          expect(@serializer1._attributes).to_not include :c
          expect(@serializer1._attributes).to     include :d
          expect(@serializer1._attributes).to     include :e
          expect(@serializer1._attributes).to_not include :f
        end
      end
    end
  end
end
