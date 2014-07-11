class CreateWeeks < ActiveRecord::Migration
  def change
    create_table :weeks do |t|
      t.date :week

      t.timestamps
    end
  end
end
