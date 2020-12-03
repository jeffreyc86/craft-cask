class RemoveBirthdateAndAddByearBmonthBdayToUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :birthdate 
    add_column :users, :birth_month 
  end
end
