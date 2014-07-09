class Month < ActiveRecord::Base
  has_many :articles
  has_many :month_counts
  has_many :wordbanks, through: :month_count
end
