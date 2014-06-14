class AddChampionsToSplash < ActiveRecord::Migration
  def change
  	  	 add_column :screens, :champion_id, :integer
  end
end
