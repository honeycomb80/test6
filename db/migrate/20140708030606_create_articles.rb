class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.integer :week_id
      t.integer :month_id
      t.integer :year_id
      t.date :date
      t.string :url
      t.string :headline

      t.timestamps
    end
    add_index :articles, :week_id
    add_index :articles, :month_id
    add_index :articles, :year_id
  end
end
