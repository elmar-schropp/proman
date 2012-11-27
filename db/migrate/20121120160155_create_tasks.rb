class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.integer :projekt_id
      t.string :tasktype
      t.string :tag
      t.string :wichtig
      t.string :titel
      t.string :kommentar
      t.integer :autor
      t.string :autor2
      t.integer :assigned_to
      t.string :priority
      t.string :status

      t.timestamps
    end
  end
end
