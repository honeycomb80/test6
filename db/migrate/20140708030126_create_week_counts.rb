class CreateWeekCounts < ActiveRecord::Migration
  def change
    create_table :week_counts do |t|
      t.integer :wordbank_id
      t.integer :week_id
      t.integer :total_count
      t.integer :headline_count

      t.timestamps
    end
    add_index :week_counts, :wordbank_id
    add_index :week_counts, :week_id
  end
end
