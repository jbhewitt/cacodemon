class Jobqueue < ActiveRecord::Base
	belongs_to :splash
	belongs_to :screen

	scope :uncompleted, -> { where(completed: nil) }

	def self.next
		self.uncompleted.first
	end

end
