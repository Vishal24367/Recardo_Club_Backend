class ApplicationController < ActionController::Base
	include ApplicationHelper

	include Pundit
	protect_from_forgery with: :exception
	skip_before_action :verify_authenticity_token
	before_action :prepare_exception_notifier
	after_action :set_csrf_token
	rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

	protected
		def prepare_exception_notifier
			request.env["exception_notifier.exception_data"] = {current_user: current_user}
		end

		def current_user
			current_admin_user
		end

		def set_csrf_token
			if request.xhr?
				# Add the newly created csrf token to the page headers
				# These values are sent on 1 request only response.
				headers['X-CSRF-Token'] = "#{form_authenticity_token}"
			end
		end

	  def set_user
	    CurrentUserHelperService.current_user = session[:user]
		end
		
		def user_not_authorized
			render json: {errors: {message: "You are not authorized to perform this action"}}, status: :unauthorized
		end
end
