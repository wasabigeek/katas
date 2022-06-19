class EmployeeReport
  def initialize(employees)
    @employees = employees
  end

  def sunday_allowed_employees
    employees.select { |employee| employee[:age] >= 18 }
  end

  private

  attr_reader :employees
end
