class CreateShoppingCarts < ActiveRecord::Migration[5.2]
  def change
    create_table :shopping_carts do |t|
      t.integer :total, default: 0
      t.references :user, null:false, foreign_key: true

      t.timestamps
    end
  end
end
