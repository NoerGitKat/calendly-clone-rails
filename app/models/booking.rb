class Booking < ApplicationRecord
  has_person_name
  belongs_to :meeting
  has_rich_text :notes
end
