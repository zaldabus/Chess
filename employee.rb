class Employee

  attr_reader :salary, :boss

  def initialize(name, title, salary, boss = nil)
    @name, @title, @salary, @boss = name, title, salary, boss
  end

  def bonus(multiplier)
    salary * multiplier
  end

  def add_manager(mgr)
    @boss = mgr
    mgr.add_employee(self)
  end

end

class Manager < Employee

  attr_reader :employees, :name

  def initialize(name, title, salary)
    super(name, title, salary, nil)
    @employees = []
  end

  def add_employee(employee)
    @employees << employee
  end

  def bonus(multiplier)
    bonus = @employees.inject(0) { |total, employee| total += employee.salary }
    bonus * multiplier
  end

end
