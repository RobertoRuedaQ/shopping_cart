# == Schema Information
#
# Table name: products
#
#  id         :bigint           not null, primary key
#  title      :string
#  code       :string
#  stock      :integer          default(0)
#  price      :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Product < ApplicationRecord

  has_many :shopping_card_products

  before_save :validate_product
  after_save :send_notification
  after_save :push_notification, if: :discount?
  before_update :code_notification_changed, if: :code_changed?
  after_update :send_notification_stock, if: :stock_limit?

  validates :title, presence: {message: 'es necesario definir un valor para el titulo'}
  validates :code, presence: {message: 'es necesario definir un valor para el codigo'}
  validates :code, uniqueness: {message: 'el codigo: %{value} ya se encuentra en uso'}
  validates :price, length: {in: 3..10, message: 'el precio se encuentra fuera del rango (min: 3, max: 10)'}, if: :has_price?
  validates_with ProductValidator


  def total
    self.price / 100
  end

  def discount?
    self.total < 5
  end

  def has_price?
   self.price.nil? && self.price > 0
  end

  private

  def stock_limit?
    self.saved_change_to_stock? && self.stock <= 5
  end

  def validate_product
    puts "\n\n\n un nuevo producto sera añadido a almacen"
  end

  def send_notification
    puts "\n\n\n un nuevo producto fue añadido a almacen: #{self.title} - #{self.total} USD"
  end

  def push_notification
    puts "\n\n\n un nuevo producto en descuento ya se encuentra disponible: #{self.title}"
  end

  def code_notification_changed
    puts "\n\n\n el codigo se ha cambiado"
  end

  def code_notification_changed
    puts "\n\n\n el producto #{self.title}, se encuentra escaso, quedan #{self.stock} "
  end
end
