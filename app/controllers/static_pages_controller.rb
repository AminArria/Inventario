class StaticPagesController < ApplicationController
  def dashboard
    @sections = Section.all
  end

  def generate
    render xlsx: 'generate'
  end

end
