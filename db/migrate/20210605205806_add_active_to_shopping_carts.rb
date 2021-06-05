class AddActiveToShoppingCarts < ActiveRecord::Migration[5.2]
  def change
    add_column :shopping_carts, :active, :boolean, default: false
  end
end
