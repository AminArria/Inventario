module StaticPagesHelper
  def two_decimal_amount(amount)
    number_with_precision(amount, :precision => 2, :separator => ',')
  end
end
