class CreateEndpoints < ActiveRecord::Migration[6.1]
  def change
    create_table :endpoints do |t|
      t.references :route, null: false, foreign_key: true
      t.float :lat
      t.float :lon
      t.string :label
      t.string :color
      t.integer :position, default: 0

      t.timestamps
    end
  end
end
