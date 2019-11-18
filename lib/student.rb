class Student
  
  attr_accessor :name, :grade
  attr_reader :id
  
  def initialize(name, grade, id=nil)
    @name = name
    @grade = grade
    @id = id
  end
  
  # Create the students table in the databse
  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
      )
    SQL
    DB[:conn].execute(sql)
  end
  
  # Drop the students table from the database
  # Remove a table def and all data, idx, triggers, constraints and permission specifications for that table
  def self.drop_table
    DB[:conn].execute("DROP TABLE students;")
  end
    
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL
    
    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end
  
  # Takes in a hash of attributes and uses metaprogramming to create a new student object
  # Use #save method to save that student to the database
  def self.create(name:, grade:)
    student = Student.new(name, grade)
    student.save
    student
  end
end