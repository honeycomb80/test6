class YearCount < ActiveRecord::Base
  belongs_to :year
  belongs_to :wordbank
  validates :wordbank, :wordbank_id, :total_count, :headline_count,
    presence: true
end
