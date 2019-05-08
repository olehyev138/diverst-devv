require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  let(:user) { create(:user) }
  login_user_from_let

  context 'common errors' do
    controller do
      def index
        raise params[:error][:name].constantize
      end
    end

    describe '#rescue_from' do
      errors = [
        { name: 'ActionController::BadRequest', status: 404 },
        { name: 'ActionController::UnknownFormat', status: 404 },
        { name: 'ActiveRecord::RecordNotFound', status: 404 },
        { name: 'BadRequestException', status: 404 }
    ]

      errors.each do |error|
        before do
          request.env['HTTP_REFERER'] = 'back'
          allow(Rails).to receive(:env) { 'production'.inquiry }
          get :index, error: error
        end


        it "flashes an alert message when #{error[:name]} is raised" do
          expect(flash[:alert]).to eq 'Sorry, the resource you are looking for does not exist.'
        end

        it 'redirects to previous page' do
          expect(response).to redirect_to 'back'
        end
      end
    end
  end

  context 'errors with custom arguments' do
    controller do
      def index
        raise ActionView::MissingTemplate.new(
          ActionView::PathSet.new([]),
          '',
          ['metrics_dashboards', 'application'],
          nil,
          { locale: [:en], formats: [:zip], variants: [], handlers: [:erb, :builder, :raw, :ruby, :jbuilder] }
        )
      end
    end

    describe '#rescue_from' do
      before do
        request.env['HTTP_REFERER'] = 'back'
        allow(Rails).to receive(:env) { 'production'.inquiry }
        get :index
      end

      it 'flashes an alert message when ActionView::MissingTemplate is raised' do
        expect(flash[:alert]).to eq 'Sorry, the resource you are looking for does not exist.'
      end
    end
  end
end
