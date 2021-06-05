# == Schema Information
#
# Table name: shopping_carts
#
#  id         :bigint           not null, primary key
#  total      :integer          default(0)
#  user_id    :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  active     :boolean          default(FALSE)
#
class ShoppingCart < ApplicationRecord
  belongs_to :user
  has_many :shopping_cart_products
  has_many :products, through: :shopping_card_products
  

  def get_total
    Product.joins(:shopping_cart_products)
    .where(shopping_cart_products: {shopping_cart_id: self.id})
    .select('SUM products.price * shopping_cart_products.quantity AS total_price')[0].total_price
  end
  
  def update_total!
    self.update(total: self.get_total)
  end

  def price
    self.total / 100
  end

  #other option to calculate the amount of product we have in the shopping cart using SQL
  # def products
  #   Product.joins(:shopping_cart_products)
  #   .where(shopping_cart_products: self.id)
  #   .group('products.id')
  #   .select('COUNT(products.id) AS quantity, products.id, products.title, products.price')
  # end

end
