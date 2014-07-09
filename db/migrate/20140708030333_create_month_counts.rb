class CreateMonthCounts < ActiveRecord::Migration
  def change
    create_table :month_counts do |t|
      t.integer :wordbank_id
      t.integer :month_id
      t.integer :total_count
      t.integer :headline_count

      t.timestamps
    end
    add_index :month_counts, :wordbank_id
    add_index :month_counts, :month_id
  end
end
