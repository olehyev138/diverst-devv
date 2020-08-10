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
        attr_accessor :a, :b, :c, :d, :e, :f, :g, :h, :j
        validates :a, :b, :c, presence: true
        def attributes; { a: a, b: b, c: c, d: d, f: f, e: e, g: g, h: h, j: j } end
      end
    }
    let(:policy) {
      Class.new(ApplicationPolicy) do
        def index?;   true  end

        def show?;    false end

        def create?;  true  end

        def manage?;  false end

        def update?;  true  end

        def destroy?; false end

        def custom1?; true  end

        def custom2?; false end
      end
    }
    let(:other_policy) {
      Class.new(ApplicationPolicy) do
        def index?;   false end

        def show?;    true  end

        def create?;  false end

        def manage?;  true  end

        def update?;  false end

        def destroy?; true  end

        def custom1?; false end

        def custom2?; true  end
      end
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
          expect(@serializer1._attributes).to be_empty

          serializer = @serializer1.new(model.new({ a: 1, b: 2, c: 3 }))

          expect(@serializer1._attributes).to     include :a
          expect(@serializer1._attributes).to     include :b
          expect(@serializer1._attributes).to_not include :c
          expect(@serializer1._attributes).to include :d
          expect(@serializer1._attributes).to include :e
          expect(@serializer1._attributes).to_not include :f
          expect(@serializer1._attributes).to_not include :z

          expect(serializer.serializable_hash[:a]).to eq 1
          expect(serializer.serializable_hash[:b]).to eq 2
        end
      end

      context 'serialize_all_fields is false, nothing is defined' do
        it 'has :a and :b as attributes on first instantiation' do
          expect(@serializer1._attributes).to be_empty

          serializer = @serializer1.new(model.new({ a: 1, b: 2, c: 3 }))

          expect(serializer.attributes).to be_empty
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

          a = model.new({ a: 1, b: 2, c: 3 })
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

    describe 'Scope Exception' do
      let(:serializer_class) { Class.new(ApplicationRecordSerializer) }
      context 'scope given' do
        let(:serializer_instance) { serializer_class.new(model.new, scope: {}) }
        it 'returns the scope' do
          expect(serializer_instance.scope).to eql({})
        end
      end
      context 'scope not given' do
        context 'while in testing env' do
          let(:serializer_instance) { serializer_class.new(model.new) }
          it 'raises ScopeNotDefinedException' do
            expect { serializer_instance.scope }.to raise_error(SerializerScopeNotDefinedException)
          end
        end
        context 'while not in testing env' do
          let(:serializer_instance) { serializer_class.new(model.new) }
          it 'returns nil' do
            allow(Rails.env).to receive(:test?).and_return(false)
            expect(serializer_instance.scope).to be(nil)
          end
        end
      end
    end

    describe 'Policy' do
      context 'with default policies' do
        let(:serializer) do
          Class.new(ApplicationRecordSerializer) do
            attributes :permissions
          end
        end
        context 'where policy passed as option' do
          context 'and where current_user is defined' do
            let(:serializer_instance) do
              new_object = model.new
              serializer.new(new_object, scope: {}, policy: policy.new(create(:user), new_object))
            end

            it 'serializes the permissions correctly' do
              expect(serializer_instance.as_json).to eq({
                                                            permissions: {
                                                                show?: false,
                                                                update?: true,
                                                                destroy?: false,
                                                            }
                                                        })
            end
          end
        end
        context 'where policy determined with Pundit Policy Finder' do
          before :each do
            allow_any_instance_of(Pundit::PolicyFinder).to receive(:policy).and_return(other_policy)
          end
          context 'and where current_user is defined' do
            let(:serializer_instance) do
              serializer.new(model.new, scope: serializer_scopes(create(:user)))
            end

            it 'serializes the permissions correctly' do
              expect(serializer_instance.as_json).to eq({
                                                            permissions: {
                                                              show?: true,
                                                              update?: false,
                                                              destroy?: true,
                                                            }
                                                        })
            end
          end
          context 'and where current_user is not defined' do
            let(:serializer_instance) do
              serializer.new(model.new, scope: {})
            end

            it 'serializes the permissions correctly' do
              expect(serializer_instance.as_json).to eq({
                                                            permissions: {
                                                                show?: false,
                                                                update?: false,
                                                                destroy?: false,
                                                            }
                                                        })
            end
          end
        end
      end
      context 'with custom policies' do
        let(:serializer) do
          Class.new(ApplicationRecordSerializer) do
            attributes :permissions
            def policies
              [
                  :index?,
                  :show?,
                  :create?,
                  :manage?,
                  :update?,
                  :destroy?,
                  :custom1?,
                  :custom2?
              ]
            end
          end
        end
        context 'where policy passed as option' do
          context 'and where current_user is defined' do
            let(:serializer_instance) do
              new_object = model.new
              serializer.new(new_object, scope: {}, policy: policy.new(create(:user), new_object))
            end
            it 'serializes the permissions correctly' do
              expect(serializer_instance.as_json).to eq({
                                                            permissions: {
                                                                index?: true,
                                                                show?: false,
                                                                create?: true,
                                                                manage?: false,
                                                                update?: true,
                                                                destroy?: false,
                                                                custom1?: true,
                                                                custom2?: false,
                                                            }
                                                        })
            end
          end
        end
        context 'where policy determined with Pundit Policy Finder' do
          before do
            allow_any_instance_of(Pundit::PolicyFinder).to receive(:policy).and_return(other_policy)
          end
          context 'and where current_user is defined' do
            let(:serializer_instance) do
              serializer.new(model.new, scope: serializer_scopes(create(:user)))
            end

            it 'serializes the permissions correctly' do
              expect(serializer_instance.as_json).to eq({
                                                            permissions: {
                                                                index?: false,
                                                                show?: true,
                                                                create?: false,
                                                                manage?: true,
                                                                update?: false,
                                                                destroy?: true,
                                                                custom1?: false,
                                                                custom2?: true,
                                                            }
                                                        })
            end
          end
          context 'and where current_user is not defined' do
            let(:serializer_instance) do
              serializer.new(model.new, scope: {})
            end

            it 'serializes the permissions correctly' do
              expect(serializer_instance.as_json).to eq({
                                                            permissions: {
                                                              index?: false,
                                                              show?: false,
                                                              create?: false,
                                                              manage?: false,
                                                              update?: false,
                                                              destroy?: false,
                                                              custom1?: false,
                                                              custom2?: false,
                                                          }
                                                        })
            end
          end
        end
      end
    end

    describe 'Conditional Attributes' do
      let!(:serializer_class) do
        Class.new(ApplicationRecordSerializer) do
          attributes :a, :b, :c
          attributes_with_permission :c, :d, :e, :f, :g, if: :false?
          attributes_with_permission :f, :g, :h, :j, if: :true?

          def b; object.b ** 2 end
          def e; object.e ** 2 end
          def g; object.g ** 2 end
          def j; object.j ** 2 end

          def true?; true end
          def false?; false end
        end
      end

      let!(:serializer) do
        serializer_class.new(model.new(
          {
              a: 1,
              b: 2,
              c: 3,
              d: 4,
              e: 5,
              f: 6,
              g: 7,
              h: 8,
              j: 9,
          }
        ))
      end

      context 'class side' do
        it 'has conditional attributes' do
          expect(serializer_class._attributes).to include :a
          expect(serializer_class._attributes).to include :b
          expect(serializer_class._attributes).to include :c
          expect(serializer_class._attributes).to include :d
          expect(serializer_class._attributes).to include :e
          expect(serializer_class._attributes).to include :f
          expect(serializer_class._attributes).to include :g
          expect(serializer_class._attributes).to include :h
          expect(serializer_class._attributes).to include :j
        end
      end
      context 'permission module' do
        let(:permission_module) { serializer_class.permission_module }
        let(:defined_method) { permission_module.instance_methods(false) }

        it 'has proper attr_conditions for condition attributes' do
          expect(permission_module[:c]).to eq [:false?]
          expect(permission_module[:d]).to eq [:false?]
          expect(permission_module[:e]).to eq [:false?]
          expect(permission_module[:f]).to eq [:false?, :true?]
          expect(permission_module[:g]).to eq [:false?, :true?]
          expect(permission_module[:h]).to eq [:true?]
          expect(permission_module[:j]).to eq [:true?]
        end
        it 'has empty attr_conditions for regular attributes' do
          expect(permission_module[:a]).to eq []
          expect(permission_module[:b]).to eq []
        end
        it 'defines the method for the permission' do
          expect(defined_method).to include :c
          expect(defined_method).to include :d
          expect(defined_method).to include :e
          expect(defined_method).to include :f
          expect(defined_method).to include :g
          expect(defined_method).to include :h
          expect(defined_method).to include :j
        end
        it "doesn't define methods for regular attributes" do
          expect(defined_method).to_not include :a
          expect(defined_method).to_not include :b
        end
      end
    end
  end
end
