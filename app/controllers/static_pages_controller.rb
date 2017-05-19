class StaticPagesController < ApplicationController
  def dashboard
    @sections = Section.all
  end
end
