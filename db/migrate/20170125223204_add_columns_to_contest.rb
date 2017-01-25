class AddColumnsToContest < ActiveRecord::Migration[5.0]
  def change
    add_column :contests, :Timeout, :integer
    add_column :contests, :MemLimit, :integer
    add_column :contests, :Command, :string
    add_column :contests, :Stdin, :string
  end
end
