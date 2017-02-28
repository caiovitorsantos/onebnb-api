class CreateVisitors < ActiveRecord::Migration[5.0]
  def change
    create_table :visitors do |t|
      t.integer :user
      t.references :property, foreign_key: true

      t.timestamps
    end
  end
end
