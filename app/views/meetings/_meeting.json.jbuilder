json.extract! meeting, :id, :name, :location, :description, :color, :duration, :payment_required, :price, :user_id, :created_at, :updated_at
json.url meeting_url(meeting, format: :json)
json.description meeting.description.to_s
