# == Schema Information
#
# Table name: shopping_cart_products
#
#  id               :bigint           not null, primary key
#  shopping_cart_id :bigint           not null
#  product_id       :bigint           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  quantity         :integer          default(1)
#
class ShoppingCartProduct < ApplicationRecord
  belongs_to :shopping_cart
  belongs_to :product

  after_create :update_total!
  after_destroy :update_total!
  
  private

  def update_total!
    self.shopping_cart.update_total!
  end
end
