class CreateCalories < ActiveRecord::Migration
  def change
    create_table :calories do |t|
      t.string :description
      t.integer :value
      t.timestamps null: false
    end
    add_reference :calories, :user, index: true
  end
end
