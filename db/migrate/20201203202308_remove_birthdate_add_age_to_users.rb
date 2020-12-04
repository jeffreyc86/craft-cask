class RemoveBirthdateAddAgeToUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :birthdate 
    add_column :users, :age, :integer 
  end
end

