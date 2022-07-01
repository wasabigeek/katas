require "minitest/autorun"
require_relative "./employee_report"

class EmployeeReportTest < Minitest::Test
  def test_return_employees_older_than_18
    employees = [
      # Note the new Employee class.
      Employee.new(name: 'Max', age: 17),
      Employee.new(name: 'Sepp', age: 18),
      Employee.new(name: 'Mike', age: 51)
    ]
    result = EmployeeReport.new(employees).sunday_allowed_employees
    # We're now comparing Employee objects, instead of their attributes.
    assert_contains_exactly(
      [Employee.new(name: 'Sepp', age: 18), Employee.new(name: 'Mike', age: 51)],
      result
    )
  end

  def test_result_sorted_by_name_descending
    employees = [
      Employee.new(name: 'Sepp', age: 18),
      Employee.new(name: 'Mike', age: 51)
    ]
    result = EmployeeReport.new(employees).sunday_allowed_employees
    # Same here - this test doesn't rely on the attributes of an employee!
    assert_equal(
      [
        Employee.new(name: 'Sepp', age: 18),
        Employee.new(name: 'Mike', age: 51)
      ],
      result
    )
  end

  def test_results_are_uppercased
    employees = [Employee.new(name: 'Sepp', age: 18)]

    result = EmployeeReport.new(employees).sunday_allowed_employees
    assert_equal result.first.display_name, 'SEPP'
  end

  private

  def assert_contains_exactly(expected, actual)
    assert_equal(expected.sort, actual.sort)
  end
end
