class MeetingsController < ApplicationController
  before_action :set_meeting, only: %i[ show edit update destroy ]

  # GET /meetings or /meetings.json
  def index
    @meetings = current_user.meetings
  end

  # GET /meetings/1 or /meetings/1.json
  def show
  end

  # GET /meetings/new
  def new
    @meeting = current_user.meetings.new
  end

  # GET /meetings/1/edit
  def edit
  end

  # POST /meetings or /meetings.json
  def create
    @meeting = current_user.meetings.new(meeting_params.merge(user: current_user))

    respond_to do |format|
      if @meeting.save
        format.html { redirect_to root_path, notice: "Meeting was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /meetings/1 or /meetings/1.json
  def update
    respond_to do |format|
      if @meeting.update(meeting_params)
        format.html { redirect_to meeting_url(@meeting), notice: "Meeting was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /meetings/1 or /meetings/1.json
  def destroy
    @meeting.destroy

    respond_to do |format|
      format.html { redirect_to root_url, notice: "Meeting was successfully destroyed." }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_meeting
      @meeting = Meeting.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def meeting_params
      params.require(:meeting).permit(:name, :location, :description, :color, :duration, :payment_required, :price)
    end
end
