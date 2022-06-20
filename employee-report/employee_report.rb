class Employee
  attr_reader :age

  def initialize(name:, age:)
    @name = name
    @age = age
  end

  def name
    @name.upcase
  end
end

class EmployeeReport
  def initialize(employee_hashes)
    @employees = employee_hashes.map do |employee_hash|
      Employee.new(**employee_hash)
    end
  end

  def sunday_allowed_employees
    of_legal_age_for_sunday
      .sort_by(&:name)
  end

  private

  attr_reader :employees

  def of_legal_age_for_sunday
    employees.select { |employee| employee.age >= 18 }
  end
end
