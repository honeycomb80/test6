class Wordbank < ActiveRecord::Base
  has_many :week_counts
  has_many :month_counts
  has_many :year_counts
  has_many :weeks, through: :week_count
  has_many :months, through: :month_count
  has_many :years, through: :year_count
  validates :word, presence: true, uniqueness: true
end
