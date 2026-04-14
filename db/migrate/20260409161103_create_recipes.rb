class CreateRecipes < ActiveRecord::Migration[7.0]
  def change
    create_table :recipes do |t|
      t.string :difficulty_type, null: false, default: ""
      t.date :start_at, null: false
      t.string :drug_list, null: false, array: true, default: []
      t.date :end_at, null: false

      t.references :patient, null: true, foreign_key: true

      t.timestamps
    end

    add_index :recipes, :drug_list, using: "gin"
  end
end
