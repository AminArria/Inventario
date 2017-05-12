require 'rails_helper'

RSpec.describe "sections/edit", type: :view do
  before(:each) do
    @section = assign(:section, Section.create!(
      :api_id => 1,
      :name => "MyString",
      :description => "MyText"
    ))
  end

  it "renders the edit section form" do
    render

    assert_select "form[action=?][method=?]", section_path(@section), "post" do

      assert_select "input[name=?]", "section[api_id]"

      assert_select "input[name=?]", "section[name]"

      assert_select "textarea[name=?]", "section[description]"
    end
  end
end
