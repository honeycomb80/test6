class AddTcIdToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :tc_id, :integer
  end
end
