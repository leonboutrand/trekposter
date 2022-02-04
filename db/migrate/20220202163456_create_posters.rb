class CreatePosters < ActiveRecord::Migration[6.1]
  def change
    create_table :posters do |t|
      t.string :email
      t.integer :height, default: 2480 
      t.integer :width, default: 3508
      t.integer :padding, default: 0
      t.boolean :elevation_profile, default: true
      t.string :elevation_color, default: '#222'
      t.integer :elevation_height, default: 248
      t.string :theme, default: 'mapbox://styles/mapbox/streets-v11'
      t.string :background, default: '#F7F7F7'
      t.string :bounds

      t.timestamps
    end
  end
end
