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
    # Note that we rely on the Employee instances being the same
    # as the input. This might not be ideal, potentially you could
    # get around it by adding a comparison method on Employee.
    # But _not_ doing this is also just as valid.
    assert_includes result, sepp
    assert_includes result, mike
    refute_includes result, max
  end

  def test_result_sorted_by_names_descending
    employees = [
      sepp = Employee.new(name: 'Sepp', age: 18),
      mike = Employee.new(name: 'Mike', age: 51)
    ]
    result = EmployeeReport.new(employees).sunday_allowed_employees
    assert_equal [sepp, mike], result
  end

  def test_results_are_capitalised
    employees = [Employee.new(name: 'Sepp', age: 18)]
    result = EmployeeReport.new(employees).sunday_allowed_employees
    # ActiveSupport has a nice #sole method that could be used instead
    assert_equal result.first.display_name, 'SEPP'
  end
end
