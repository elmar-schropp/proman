class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :passwort
      t.integer :is_admin
      t.string :fullname

      t.timestamps
    end
  end
end
