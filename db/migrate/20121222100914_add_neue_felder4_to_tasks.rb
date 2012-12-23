class AddNeueFelder4ToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :trash, :string
    add_column :tasks, :trash_at, :datetime
    add_column :tasks, :trash_by, :integer
    add_column :tasks, :timing, :string
    add_column :tasks, :highlight, :string
  end
end
