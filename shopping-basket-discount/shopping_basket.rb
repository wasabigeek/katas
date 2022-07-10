class ShoppingBasket
  LineItem = Struct.new(:name, :price, :quantity) do |_new_class|
    def total_price
      price * quantity
    end
  end

  def initialize(basket_data)
    @line_items = basket_data.map do |item_hash|
      LineItem.new(
        item_hash[:name],
        item_hash[:price],
        item_hash[:quantity]
      )
    end
  end

  def quantity(item_name)
    line_items
      .find { |item| item.name == item_name }
      .quantity
  end

  def total_price
    price_before_bulk_discounts = line_items.reduce(0) do |acc, line_item|
      acc + line_item.total_price
    end

    if price_before_bulk_discounts > 200
      price_before_bulk_discounts *= 0.90
    elsif price_before_bulk_discounts > 100
      price_before_bulk_discounts *= 0.95
    end

    price_before_bulk_discounts.truncate(2)
  end

  private

  attr_reader :line_items
end
