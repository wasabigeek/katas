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

    assert_equal ['Sepp', 'Mike'], result.map { |employee| employee[:name] }
  end
end
