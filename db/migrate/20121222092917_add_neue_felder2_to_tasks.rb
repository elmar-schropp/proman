class AddNeueFelder2ToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :star, :string
    add_column :tasks, :done_at, :datetime
    add_column :tasks, :done_by, :integer
  end
end
