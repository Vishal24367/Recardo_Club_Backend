#####################################################################
# Copyright (C) 2013 Navyug Infosolutions Pvt Ltd.
# Developer : Ranu Pratap Singh
# Email : ranu.singh@navyuginfo.com
# Created Date : 25/7/14
#####################################################################

module Users
	class ConfirmationsController < Devise::ConfirmationsController
		# GET /resource/confirmation?confirmation_token=abcdef
		def show
			self.resource = resource_class.confirm_by_token(params[:confirmation_token])
			yield resource if block_given?

			if resource.errors.empty?
				redirect_to APP_CONFIG["app_url"]
			else
				respond_with_navigational(resource.errors, status: :unprocessable_entity){ render :new }
			end
		end
	end
end
