require "active_record"

class Todo < ActiveRecord::Base
  def due_today?
    due_date == Date.today
  end

  def to_displayable_string
    display_status = completed ? "[X]" : "[ ]"
    display_date = due_today? ? nil : due_date
    "#{id}. #{display_status} #{todo_text} #{display_date}"
  end

  def self.to_displayable_list
    all.map { |todo| todo.to_displayable_string }
  end

  def self.show_list
    puts "My Todo-list"
    puts "\nOverdue"
    puts Todo.where("due_date < ?", Date.today).to_displayable_list
    puts "\n\nDue Today"
    puts Todo.where("due_date = ?", Date.today).to_displayable_list
    puts "\n\nDue Later"
    puts Todo.where("due_date > ?", Date.today).to_displayable_list
  end

  def self.add_task(data)
    new_todo = Todo.create!(
      todo_text: data[:todo_text],
      due_date: Date.today + data[:due_in_days],
      completed: false,
    )
    new_todo
  end

  def self.mark_as_complete(todo_id)
    todo = Todo.find(todo_id)
    todo.completed = true
    todo.save
    todo
  end
end
