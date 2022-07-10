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
    basket_data.reduce(0) do |acc, item_hash|
      acc + item_hash[:quantity] * item_hash[:price]
    end
  end

  private

  attr_reader :basket_data
end
