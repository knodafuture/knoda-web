class ChallengesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_challenge, only: [:show, :edit, :update, :destroy]

  # GET /challenges
  def index
    @challenges = Challenge.all
  end

  # POST /challenges
  def create
    c = challenge_params
    prediction = Prediction.find(c['prediction_id'])
    if (current_user.id != prediction.user_id) && !prediction.is_expired? && !prediction.is_closed?   
     @challenge = current_user.challenges.where(prediction: prediction).first
      if @challenge
        @challenge.update(c)
      else
        @challenge = current_user.challenges.create(c)
      end
      render :status => :created
    else
      render :json => {success: false}, :status => :ok
    end
  end

  # PATCH/PUT /challenges/1
  def update
    if @challenge.update(challenge_params)
      redirect_to @challenge, notice: 'Challenge was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /challenges/1
  def destroy
    @challenge.destroy
    redirect_to challenges_url, notice: 'Challenge was successfully destroyed.'
  end

  private
    def set_challenge
      @challenge = Challenge.find(params[:id])
    end

    def challenge_params
      params.permit(:prediction_id, :agree)
    end
end
