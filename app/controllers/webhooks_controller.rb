class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  def create
    payload  = request.body.read
    signature_header = request.env["HTTP_STRIPE_SIGNATURE"]
    endpoint_secret = Rails.application.credentials.dig(:stripe, :whsc)
    event = nil

    # Exception handling
    begin
      event = Stripe::Webhook.construct_event(payload, signature_header, endpoint_secret)
    rescue JSON::ParserError => error
      render json: { message: error }, status: 400
    rescue JSON::SignatureVerificationError => error
      render json: { message: error }, status: 403
      return
    end

    # 
    case event.type
    when "payment_intend.succeeded"
      # Find booking
      @user = User.find(event.data.object)
      @bookings = Booking.where(meeting_id: @user.meeting_ids)
      @current_booking = @bookings.last
      @current_booking.update(customer_paid: true, status: 1)
    when "payment_intend.processing"
      # Send email for pending booking
    when "payment_intend.payment_failed"
      # Send email for rejected booking
    else
      puts "Unhandled  event type: #{event.type}"
  end
end