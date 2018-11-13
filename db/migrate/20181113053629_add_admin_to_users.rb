class AddAdminToUsers < ActiveRecord::Migration[5.1]
  def change
    # also added false as default which means that users will not 
    # be administrators by default
    add_column :users, :admin, :boolean, default: false
  end
end
