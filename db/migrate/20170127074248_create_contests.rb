class CreateContests < ActiveRecord::Migration[5.0]
  def change
    create_table :contests do |t|
      t.string :name
      t.text :description
      t.timestamp :duedate
      t.integer :Timeout
      t.integer :MemLimit
      t.string :Command
      t.string :Stdin

      t.timestamps
    end
  end
end
