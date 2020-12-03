class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.string :name 
      t.string :alcohol_type
      t.float :price
      t.integer :inventory
      t.integer :abv
      t.string :origin
      t.text :description
    end 
  end
end


