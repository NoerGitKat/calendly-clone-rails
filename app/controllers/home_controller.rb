class HomeController < ApplicationController
  def index 
  end

  def dashboard
    @meetings = current_user.meetings
    @bookings = Booking.where(meeting_id: current_user.meeting_ids)
  end
end
