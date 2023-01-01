class BookingsController < ApplicationController
  before_action :set_booking, only: %i[ show edit update destroy ]


  # GET /bookings/1 or /bookings/1.json
  def show
    @user = User.find_by(email: "noer@noer.com")
  end

  # GET /bookings/new
  def new
    @booking = Booking.new
    @meeting = Meeting.find_by(name: params[:meeting])
  end

  # GET /bookings/1/edit
  def edit
  end

  # POST /bookings or /bookings.json
  def create
    @booking = Booking.new(booking_params)
    @meeting = Meeting.find(params[:booking][:meeting_id])

    respond_to do |format|
      if @booking.save

        if @meeting.payment_required?
          @booking.approved!
        end
        format.html { redirect_to root_url, notice: "Booking was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bookings/1 or /bookings/1.json
  def update
    respond_to do |format|
      if @booking.update(booking_params)
        format.html { redirect_to booking_url(@booking), notice: "Booking was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bookings/1 or /bookings/1.json
  def destroy
    @booking.destroy

    respond_to do |format|
      format.html { redirect_to bookings_url, notice: "Booking was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # POST
  def intent
    @meeting = Meeting.find(params[:_json])
    amount = @meeting.price * 100

    payment_intent = Stripe::PaymentIntent.create(
      amount: amount,
      currency: "USD",
      automatic_payment_methods: {
        enabled: true
      },
      metadata: {
        user_id: @meeting.user.id,
        meeting_id: @meeting.id
      }
    )

    respond_to do |format|
      format.json { render json: { clientSecret: payment_intent["client_secret" ] }}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_booking
      @booking = Booking.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def booking_params
      params.require(:booking).permit(:meeting_id, :status, :name, :email, :start_at, :end_at, :notes)
    end
end
