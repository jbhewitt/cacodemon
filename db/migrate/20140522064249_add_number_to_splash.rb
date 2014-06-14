class AddNumberToSplash < ActiveRecord::Migration
  def change
  	  add_column :splashes, :number, :integer
  end
end
