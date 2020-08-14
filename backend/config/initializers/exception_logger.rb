class ExceptionLogger
	# Logs and emails exception
	# Optional args:
	# request: request Used for the ExceptionNotifier
	# info: "A descriptive messsage"
	def self.log_exception(exception,args={})
		extra_info = args[:info]

		Rails.logger.error extra_info if extra_info
		Rails.logger.error exception.message
		st = exception.backtrace.join("\n")
		Rails.logger.error st

		extra_info ||= "<NO DETAILS>"
		ExceptionNotifier.notify_exception(exception, :data => {:message => extra_info||=exception.message})
	end
end
