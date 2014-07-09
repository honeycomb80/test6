class Year < ActiveRecord::Base
  has_many :articles
  has_many :year_counts
  has_many :wordbanks, through: :year_count
end
