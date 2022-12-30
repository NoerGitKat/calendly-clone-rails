class Booking < ApplicationRecord
  has_person_name
  belongs_to :meeting
  has_rich_text :notes

  enum status: { pending: 0, approved: 1, rejected: 2}
end
