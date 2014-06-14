class AddChampionToSplash < ActiveRecord::Migration
  def change
  	change_table :splashes do |t|
  		t.rename :champion, :champion_id
  	end
  end
end
