class CreatePatients < ActiveRecord::Migration[7.0]
  def change
    create_table :patients do |t|
      t.string :last_name, null: false, default: ""
      t.string :first_name, null: false, default: ""
      t.integer :age, null: false, default: 0

      t.timestamps
    end
  end
end
