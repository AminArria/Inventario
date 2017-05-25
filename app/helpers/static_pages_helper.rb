module StaticPagesHelper
  def two_decimal_amount(amount, separator=',')
    number_with_precision(amount, :precision => 2, :separator => separator)
  end
end
