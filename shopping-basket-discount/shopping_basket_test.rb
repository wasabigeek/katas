require "minitest/autorun"
require_relative "./shopping_basket"

class ShoppingBasketTest < Minitest::Test
  def test_quantity_single_line_item
    basket_data = [
      { name: "A", price: 10, quantity: 5 },
      { name: "B", price: 25, quantity: 2 },
      { name: "C", price: 9.99, quantity: 6 },
    ]
    basket = ShoppingBasket.new(basket_data)
    basket_data.each do |item_hash|
      assert_equal(
        item_hash[:quantity],
        basket.quantity(item_hash[:name]),
        "Wrong quantity: expected #{item_hash[:quantity]} for Item #{item_hash[:name]} but got #{basket.quantity(item_hash[:name])} instead."
      )
    end
  end

  # def test_quantity_multiple_line_item;end
  # def test_quantity_for_missing_item;end

  def test_total_price_without_discounts
    basket_data = [
      { name: "A", price: 10, quantity: 5 },
      { name: "B", price: 25, quantity: 1 },
    ]
    basket = ShoppingBasket.new(basket_data)
    assert_equal 75, basket.total_price
  end

  def test_total_price_above_100_applies_discount
    basket_data = [
      { name: "A", price: 10, quantity: 5 },
      { name: "B", price: 25, quantity: 2 },
      { name: "C", price: 9.99, quantity: 6 },
    ]
    basket = ShoppingBasket.new(basket_data)
    # rounded down, should test
    assert_equal 151.94, basket.total_price
  end
end
