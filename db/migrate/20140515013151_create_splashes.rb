class CreateSplashes < ActiveRecord::Migration
  def change

    create_table :splashes do |t|
      t.string :filename
	  t.integer :champion_id
      t.timestamps
    end

    change_table :champions do |t|
  		t.integer :id
  	end
  	
  end
end
