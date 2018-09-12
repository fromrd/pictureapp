class AddAssociation < ActiveRecord::Migration[5.1]
  def change
    add_reference :pictures, :user
  end
end
