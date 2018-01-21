require 'rails_helper'

RSpec.describe DevicesController, type: :controller do
    let(:user){ create(:user) }
    let(:device){ create(:device, :user => user) }

    def sign_in
        auth_headers = user.create_new_auth_token
        request.headers.merge!(auth_headers)
    end

    describe "GET#index" do
        context "with logged in user" do
            before {
                sign_in
                get :index
            }

            it "returns 200" do
                expect(response.status).to eq(200)
            end

            it "gets the user devices" do
                devices = JSON.parse(response.body)
                expect(devices.length).to eq(0)
            end
        end

        context "with logged out user" do
            it "returns 401" do
                get :index
                expect(response.status).to eq(401)
            end
        end
    end


    describe "POST#create" do
        context "with logged in user" do
            context "with invalid params" do
                before {
                    sign_in
                    post :create, {:device => {:token => "token", :platform => 0}}
                }

                it "returns 200" do
                    expect(response.status).to eq(200)
                end

                it "create the user device" do
                    device = JSON.parse(response.body)
                    expect(device["token"]).to eq("token")
                end
            end

            context "with invalid save" do
                before {
                    allow_any_instance_of(Device).to receive(:save).and_return(false)
                    sign_in
                    post :create, {:device => {:token => "token", :platform => 0}}
                }

                it "returns 422" do
                    expect(response.status).to eq(422)
                end
            end
        end

        context "with logged out user" do
            it "returns 401" do
                post :create
                expect(response.status).to eq(401)
            end
        end
    end

    describe "POST#test_notif" do
        context "with logged in user" do
            it "returns 200" do
                apn = OpenStruct.new({:push => true, :certificate => ""})
                allow(Houston::Client).to receive(:development).and_return(apn)
                allow(apn).to receive(:push).and_return(true)
                sign_in
                post :test_notif, :id => device.id
                expect(response.status).to eq(204)
            end

            it "returns 500" do
                apn = OpenStruct.new({:push => true, :certificate => ""})
                allow(Houston::Client).to receive(:development).and_return(apn)
                notification = OpenStruct.new({:alert => "", :badge => 1, :sound => "", :category => "", :custom_data => {}, :error => true})
                allow(Houston::Notification).to receive(:new).and_return(notification)
                allow(apn).to receive(:push).and_return(true)
                sign_in
                post :test_notif, :id => device.id
                expect(response.status).to eq(500)
            end

            it "returns 204" do
                device.platform = "android"
                device.save!

                sign_in
                post :test_notif, :id => device.id
                expect(response.status).to eq(204)
            end
        end

        context "with logged out user" do
            it "returns 401" do
                post :test_notif, :id => device.id
                expect(response.status).to eq(401)
            end
        end
    end

    describe "DELETE#destroy" do
        context "with logged in user" do
            context "with valid destroy" do
                before {
                    sign_in
                    delete :destroy, :id => device.token
                }

                it "returns 204" do
                    expect(response.status).to eq(204)
                end

                it "deletes the user device" do
                    expect{Device.find(device.id)}.to raise_error ActiveRecord::RecordNotFound
                end
            end

            context "with invalid destroy" do
                before {
                    allow_any_instance_of(Device).to receive(:destroy).and_return(false)
                    sign_in
                    delete :destroy, :id => device.token
                }

                it "returns 500" do
                    expect(response.status).to eq(500)
                end
            end
        end

        context "with logged out user" do
            it "returns 401" do
                delete :destroy, :id => device.token
                expect(response.status).to eq(401)
            end
        end
    end
end