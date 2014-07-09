class Article < ActiveRecord::Base
  belongs_to :week
  belongs_to :month
  belongs_to :year
  validates :week, :week_id, :month, :month_id, :year, :year_id,
   :url, :date, :headline, presence: true
  validates :tc_id, presence: true, uniqueness: true
end
