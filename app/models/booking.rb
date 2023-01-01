class Booking < ApplicationRecord
  has_person_name
  belongs_to :meeting
  has_rich_text :notes

  validates :name, :email, :start_at, :end_at, :meeting_id, presence: true

  enum status: { pending: 0, approved: 1, rejected: 2}
end
