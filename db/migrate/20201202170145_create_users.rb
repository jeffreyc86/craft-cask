class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :first_name 
      t.string :username
      t.string :password
      t.date :birthdate #may need to change to :datetime
    end 
  end
end


