class ReaderController < ApplicationController
  def home
    @newspapers = Newspaper.all
  end

end