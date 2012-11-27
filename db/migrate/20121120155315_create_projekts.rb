class CreateProjekts < ActiveRecord::Migration
  def change
    create_table :projekts do |t|
      t.string :name
      t.string :kommentar
      t.string :icon

      t.timestamps
    end
  end
end
