class CreateLegends < ActiveRecord::Migration[6.1]
  def change
    create_table :legends do |t|
      t.references :poster, null: false, foreign_key: true
      t.string :title, default: "MY TREK"
      t.string :subtitle, default: "Description"
      t.string :labels
      t.boolean :position, default: true
      t.boolean :disposition, default: true
      t.string :text_color, default: "#222"
      t.integer :height, default: 300

      t.timestamps
    end
  end
end
