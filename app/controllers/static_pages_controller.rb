class StaticPagesController < ApplicationController
  def dashboard
    @sections_results = Section.all_public_addresses_count
  end
end
