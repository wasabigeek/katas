require "minitest/autorun"
require_relative "./employee_report"

class EmployeeReportTest < Minitest::Test
  def test_return_employees_older_than_18
    employee_hashes = [
      { name: 'Max', age: 17 },
      { name: 'Sepp', age: 18 },
      { name: 'Mike', age: 51 }
    ]
    result = EmployeeReport.new(employee_hashes).sunday_allowed_employees

    result_names = result.map(&:name)
    assert_includes result_names, 'SEPP'
    assert_includes result_names, 'MIKE'
    refute_includes result_names, 'MAX'
  end

  def test_result_sorted_by_name
    employee_hashes = [
      { name: 'Sepp', age: 18 },
      { name: 'Mike', age: 51 }
    ]
    result = EmployeeReport.new(employee_hashes).sunday_allowed_employees

    assert_equal ['MIKE', 'SEPP'], result.map(&:name)
  end

  def test_results_are_capitalised
    employee_hashes = [
      { name: 'Sepp', age: 18 },
      { name: 'Mike', age: 51 }
    ]
    result = EmployeeReport.new(employee_hashes).sunday_allowed_employees

    assert_equal ['MIKE', 'SEPP'], result.map(&:name)
  end
end
