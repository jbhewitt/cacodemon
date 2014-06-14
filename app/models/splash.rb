class Splash < ActiveRecord::Base
	belongs_to :champion
	has_many :screens
end
