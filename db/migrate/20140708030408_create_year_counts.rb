class CreateYearCounts < ActiveRecord::Migration
  def change
    create_table :year_counts do |t|
      t.integer :wordbank_id
      t.integer :year_id
      t.integer :total_count
      t.integer :headline_count

      t.timestamps
    end
    add_index :year_counts, :wordbank_id
    add_index :year_counts, :year_id
  end
end
