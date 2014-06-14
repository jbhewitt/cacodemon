class FixColumnChampions < ActiveRecord::Migration
  def change
  	rename_column :splashes, :champion, :champion_id
  end
end
