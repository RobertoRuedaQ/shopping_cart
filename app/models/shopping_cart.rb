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
#  status     :integer          default(0)
#
class ShoppingCart < ApplicationRecord
  include AASM
  
  belongs_to :user
  has_many :shopping_cart_products
  has_many :products, through: :shopping_card_products
  
  enum status: [:created, :canceled, :payed, :completed]
  aasm column: 'status' do
    state :created, initial: true
    state :canceled
    state :payed
    state :completed

    before_all_transactions :before_transaction
    after_all_transactions :after_transaction

    event :cancel do
      before_transaction :before_cancel
      after_transaction :after_cancel
      transitions from: :created, to: :canceled
    end

    event :pay do
      transitions from: :created, to: :completed
    end

    event :complete do
      transitions from: :payed, to: :completed
    end
  end

  def get_total
    Product.joins(:shopping_cart_products)
    .where(shopping_cart_products: {shopping_cart_id: self.id})
    .select('SUM products.price * shopping_cart_products.quantity AS total_price')[0].total_price
  end
  
  def update_total!
    self.update(total: self.get_total)
  end

  def payed!
    ActiveRecord::Base.transaction do
      self.update!(status: :payed)
  
      self.products.each do |product|
        quantity = ShoppingCartProduct.find_by(shopping_cart_id: self.id, product_id: product.id).quantity
        product.with_lock do 
          product.update!(stock: product.stock - quantity)
        end
      end
    end
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

  private

  def before_cancel
    puts 'la compra sera cancelada'
  end

  def after_cancel
    puts 'la compra fue cancelada'
  end

  def before_transaction
    puts 'se va a dar un cambio de estado'
  end

  def after_transaction
    puts  'se dio un cambio en los estados'
  end
end
