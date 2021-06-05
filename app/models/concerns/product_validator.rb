class ProductValidator < ActiveModel::Validator

  def validate(record)
    validate_stock(record)
    validate_code(record)
  end

  def validate_code(record)
    if self.code.nil? || self.code.length < 3
      self.errors.add(:code, 'el codigo debe tener por lo menos 3 caracteres')
    end
  end

  def validate_stock(record)
    if record.stock < 0
      record.errors.add(:stock, 'El stock no puede ser un valor negativo')
    end
  end
end