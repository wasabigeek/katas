require "minitest/autorun"
require_relative "./employee_report"

class EmployeeReportTest < Minitest::Test
  def test_return_employees_older_than_18
    employees = [
      { name: 'Max', age: 17 },
      { name: 'Sepp', age: 18 },
      { name: 'Mike', age: 51 }
    ]
    result = EmployeeReport.new(employees).sunday_allowed_employees

    result_names = result.map { |employee| employee[:name] }
    assert_includes result_names, 'Sepp'
    assert_includes result_names, 'Mike'
    refute_includes result_names, 'Max'
  end

  def test_result_sorted_by_name
    employees = [
      { name: 'Sepp', age: 18 },
      { name: 'Mike', age: 51 }
    ]
    result = EmployeeReport.new(employees).sunday_allowed_employees

    assert_equal ['Mike', 'Sepp'], result.map { |employee| employee[:name] }
  end
end
