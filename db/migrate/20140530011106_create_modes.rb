class CreateModes < ActiveRecord::Migration
  def change
    create_table :modes do |t|
      t.integer :state
      t.string :name

      t.timestamps
    end
  end
end
