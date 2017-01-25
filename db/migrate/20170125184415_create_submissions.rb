class CreateSubmissions < ActiveRecord::Migration[5.0]
  def change
    create_table :submissions do |t|
      t.string :submitter
      t.string :BinUri
      t.string :RootfsUri
      t.references :contest, foreign_key: true

      t.timestamps
    end
  end
end
