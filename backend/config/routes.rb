Backend::Application.routes.draw do
	devise_for :admin_users, {class_name: 'User'}.merge(ActiveAdmin::Devise.config)
	devise_for :students, {class_name: 'Student'}.merge(ActiveAdmin::Devise.config)
	ActiveAdmin.routes(self)
	require 'sidekiq/web'
	require 'sidekiq-status/web'
	authenticate :user, lambda { |u| u.is_admin } do
		mount Sidekiq::Web => '/sidekiq'
	end
	
	namespace :api do
		namespace :v1 do
			resources :students do
				post 'signup', :on => :collection
			end
		end
	end
end
  