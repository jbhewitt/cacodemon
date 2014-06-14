class CreateScreens < ActiveRecord::Migration
  def change
    create_table :screens do |t|

      t.timestamps
    end
  end
end
