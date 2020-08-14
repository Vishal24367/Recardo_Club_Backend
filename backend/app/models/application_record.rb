#ApplicationRecord will be a single point of entry for all the customizations and extensions needed for an application, instead of monkey patching ActiveRecord::Base, needs to be implemented for rails 5

class ApplicationRecord < ActiveRecord::Base
	#using inheritance with ActiveRecord and don't want child classes to utilize the implied STI table name of the parent class, this will need to be true.
	self.abstract_class = true
end