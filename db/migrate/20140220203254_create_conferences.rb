class CreateConferences < ActiveRecord::Migration
  def change
    create_table :conferences do |t|
      t.string :name
      t.string :webExt
      t.string :logo

      t.timestamps
    end
  end
end
