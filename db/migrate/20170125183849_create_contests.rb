class CreateContests < ActiveRecord::Migration[5.0]
  def change
    create_table :contests do |t|
      t.string :name
      t.text :description
      t.timestamp :duedate

      t.timestamps
    end
  end
end
