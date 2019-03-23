class ArchivedInitiativesController < ApplicationController
	before_action :authenticate_user!
	before_action :set_initiative, only: [:restore, :destroy]

	layout 'erg_manager'

	def index
		authorize current_user.enterprise, :manage_posts?, :policy_class => EnterprisePolicy
		@initiatives = Initiative.archived_initiatives(current_user.enterprise).order(created_at: :desc)
	end

	def destroy
	end

	def delete_all
	end

	def restore_all
	end

	def restore
	end


	private 

	def set_iniativie
		@initiative = Initiative.find(params[:id])
	end
end
