class AddNumberToScreens < ActiveRecord::Migration
  def change
  	  add_column :screens, :splash_id, :integer
  	  add_column :screens, :alive, :boolean
  end
end
