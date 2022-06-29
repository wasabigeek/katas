class Employee
  attr_reader :age

  def initialize(name:, age:)
    @name = name
    @age = age
  end

  def display_name
    @name.upcase
  end

  def <=>(other)
    other.display_name <=> display_name
  end
end

class EmployeeReport
  # Imagine that there is a new class that will take the array
  # of hashes and split out an array of Employees. That output
  # goes into this class.
  def initialize(employees)
    @employees = employees
  end

  def sunday_allowed_employees
    of_legal_age_for_sunday.sort
  end

  private

  attr_reader :employees

  def of_legal_age_for_sunday
    employees.select { |employee| employee.age >= 18 }
  end
end
