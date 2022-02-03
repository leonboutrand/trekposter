class CreateRoutes < ActiveRecord::Migration[6.1]
  def change
    create_table :routes do |t|
      t.references :poster, null: false, foreign_key: true
      t.string :name
      t.boolean :elevation, default: true
      t.integer :thickness, default: 8
      t.string :color1, default: "#FF6"
      t.string :color2, default: "#300"
      t.integer :sort_index, default: 0
      t.string :gpx_track

      t.timestamps
    end
  end
end
