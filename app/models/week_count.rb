class WeekCount < ActiveRecord::Base
  belongs_to :week
  belongs_to :wordbank
  validates :wordbank, :wordbank_id, :total_count, :headline_count,
    presence: true
end
