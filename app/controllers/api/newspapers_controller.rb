class Api::NewspapersController < ApplicationController
  respond_to :json

  def newspapers
    result = Newspaper.all
    respond_with result
  end

  def current_newspaper
    respond_with current_user.current_newspaper
  end

  def save_current_newspaper
    current_user.current_newspaper_id = params[:newspaper_id]
    if current_user.save
      respond_with current_user.current_newspaper
    end
  end

end