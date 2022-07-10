class ShoppingBasket
  def initialize(basket_data)
    @basket_data = basket_data
  end

  def quantity(item_name)
    basket_data
      .find { |item_hash| item_hash[:name] == item_name }
      .dig(:quantity)
  end

  private

  attr_reader :basket_data
end
