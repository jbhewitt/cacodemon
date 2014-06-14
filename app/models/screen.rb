class Screen < ActiveRecord::Base
	belongs_to :splash
	belongs_to :champion
	
	has_many :jobqueue

	accepts_nested_attributes_for :champion, :splash
end
