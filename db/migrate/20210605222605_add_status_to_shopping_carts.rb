class AddStatusToShoppingCarts < ActiveRecord::Migration[5.2]
  def change
    add_column :shopping_carts, :status, :integer, default: 0
  end
end
