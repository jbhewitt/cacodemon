class Champion < ActiveRecord::Base
	has_many :splashes
	has_many :screens
	accepts_nested_attributes_for :splashes, :screens
end
