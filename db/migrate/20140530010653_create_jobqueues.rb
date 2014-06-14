class CreateJobqueues < ActiveRecord::Migration
  def change
    create_table :jobqueues do |t|
      t.boolean :completed
      t.integer :mode
      t.integer :splash_id

      t.timestamps
    end
  end
end
