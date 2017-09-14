class StaticPagesController < ApplicationController
  def dashboard
    @sections_public = Section.addresses_count(public: true)
    @sections_private = Section.addresses_count(public: false)

    @dedicated_hosting = DataCenter.stats
  end
end
