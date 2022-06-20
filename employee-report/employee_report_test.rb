require "minitest/autorun"
require_relative "./employee_report"

class EmployeeReportTest < Minitest::Test
  def test_return_employees_older_than_18
    employees = [
      { name: 'Max', age: 17 },
      { name: 'Sepp', age: 18 },
      { name: 'Nina', age: 15 },
      { name: 'Mike', age: 51 },
    ]
    result = EmployeeReport.new(employees).sunday_allowed_employees

    # assert_equal(
    #   ['Sepp', 'Mike'].sort,
    #   result.map { |employee| employee[:name] }.sort
    # )

    # this is less concise, but is closer to the intent
    result_names = result.map { |employee| employee[:name] }
    assert_includes result_names, 'Sepp'
    assert_includes result_names, 'Mike'
    refute_includes result_names, 'Max'
    refute_includes result_names, 'Nina'
  end

  def test_result_sorted_by_name
    employees = [
      { name: 'Max', age: 17 },
      { name: 'Sepp', age: 18 },
      { name: 'Nina', age: 15 },
      { name: 'Mike', age: 51 },
    ]
    result = EmployeeReport.new(employees).sunday_allowed_employees

    assert_equal ['Mike', 'Sepp'], result.map { |employee| employee[:name] }
  end
end
