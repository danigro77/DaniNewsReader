class Api::NewspapersController < ApplicationController
  respond_to :json

  def newspapers
    result = Newspaper.all
    respond_with result
  end

end