class AddScreenToJobqueue < ActiveRecord::Migration
  def change
  	 add_column :jobqueues, :screen_id, :integer
  end
end
