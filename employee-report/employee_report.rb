class EmployeeReport
  def initialize(employees)
    @employees = employees
  end

  def sunday_allowed_employees
    of_legal_age_for_sunday.sort_by { |employee| employee[:name] }
  end

  private

  attr_reader :employees

  def of_legal_age_for_sunday
    employees.select { |employee| employee[:age] >= 18 }
  end
end
