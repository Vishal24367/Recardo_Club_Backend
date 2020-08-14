## This is used to run the actioncable in another server.
require ::File.expand_path('../../config/environment',  __FILE__)
Rails.application.eager_load!

#run ActionCable.server
