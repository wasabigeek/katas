require "minitest/autorun"
require_relative "./employee_report"

class EmployeeReportTest < Minitest::Test
  def test_return_employees_older_than_18
    employees = [
      max = Employee.new(name: 'Max', age: 17),
      sepp = Employee.new(name: 'Sepp', age: 18),
      mike = Employee.new(name: 'Mike', age: 51)
    ]
    result = EmployeeReport.new(employees).sunday_allowed_employees

    result_names = result.map(&:name)
    assert_includes result_names, 'SEPP'
    assert_includes result_names, 'MIKE'
    refute_includes result_names, 'MAX'
  end

  def test_result_sorted_by_name
    employees = [
      sepp = Employee.new(name: 'Sepp', age: 18),
      mike = Employee.new(name: 'Mike', age: 51)
    ]
    result = EmployeeReport.new(employees).sunday_allowed_employees

    assert_equal ['MIKE', 'SEPP'], result.map(&:name)
  end

  def test_results_are_capitalised
    employees = [
      sepp = Employee.new(name: 'Sepp', age: 18),
      mike = Employee.new(name: 'Mike', age: 51)
    ]
    result = EmployeeReport.new(employees).sunday_allowed_employees

    assert_equal ['MIKE', 'SEPP'], result.map(&:name)
  end
end
