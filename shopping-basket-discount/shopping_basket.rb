class ShoppingBasket
  def initialize(basket_data)
    @basket_data = basket_data
  end

  def quantity(item_name)
    basket_data
      .find { |item_hash| item_hash[:name] == item_name }
      .dig(:quantity)
  end

  def total_price
    price_before_bulk_discounts = basket_data.reduce(0) do |acc, item_hash|
      acc + item_hash[:quantity] * item_hash[:price]
    end

    if price_before_bulk_discounts > 100
      price_before_bulk_discounts *= 0.95
    end

    price_before_bulk_discounts.truncate(2)
  end

  private

  attr_reader :basket_data
end
