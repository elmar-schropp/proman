class AddNeueFelderToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :done, :boolean
    add_column :tasks, :url, :string
    add_column :tasks, :img, :string
  end
end
