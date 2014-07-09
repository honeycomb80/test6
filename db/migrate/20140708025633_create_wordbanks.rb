class CreateWordbanks < ActiveRecord::Migration
  def change
    create_table :wordbanks do |t|
      t.string :word
      t.boolean :brand

      t.timestamps
    end
  end
end
