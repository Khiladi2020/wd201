require "date"

class Todo
  def initialize(name, due_date, completed)
    @name = name
    @due_date = due_date
    @completed = completed
  end

  def overdue?
    Date.today > @due_date
  end

  def due_today?
    Date.today == @due_date
  end

  def due_later?
    Date.today < @due_date
  end

  def get_formated_due_date
    @due_date.strftime("%Y-%m-%d")
  end

  def completion_status
    @completed ? "[X]" : "[ ]"
  end

  def to_displayable_String
    if due_today?
      return "#{completion_status} #{@name}"
    else
      return "#{completion_status} #{@name} #{get_formated_due_date}"
    end
  end
end

class TodoList
  def initialize(todos)
    @todos = todos
  end

  def add(todo)
    @todos.push(todo)
  end

  def overdue
    TodoList.new(@todos.filter { |todo| todo.overdue? })
  end

  def due_today
    TodoList.new(@todos.filter { |todo| todo.due_today? })
  end

  def due_later
    TodoList.new(@todos.filter { |todo| todo.due_later? })
  end

  def to_displayable_list
    @todos.map { |todo| todo.to_displayable_String }.join("\n")
  end
end

date = Date.today
todos = [
  { text: "Submit assignment", due_date: date - 1, completed: false },
  { text: "Pay rent", due_date: date, completed: true },
  { text: "File taxes", due_date: date + 1, completed: false },
  { text: "Call Acme Corp.", due_date: date + 1, completed: false },
]

todos = todos.map { |todo|
  Todo.new(todo[:text], todo[:due_date], todo[:completed])
}

todos_list = TodoList.new(todos)

todos_list.add(Todo.new("Service Vehicle", date, false))
# todos_list.add(Todo.new("Masti karo", Date.new(2021, 5, 2), true))

puts "My Todo-list\n\n"

puts "Overdue\n"
puts todos_list.overdue.to_displayable_list
puts "\n\n"

puts "Due Today\n"
puts todos_list.due_today.to_displayable_list
puts "\n\n"

puts "Due Later\n"
puts todos_list.due_later.to_displayable_list
puts "\n\n"
