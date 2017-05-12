require 'rails_helper'

RSpec.describe "sections/new", type: :view do
  before(:each) do
    assign(:section, Section.new(
      :api_id => 1,
      :name => "MyString",
      :description => "MyText"
    ))
  end

  it "renders new section form" do
    render

    assert_select "form[action=?][method=?]", sections_path, "post" do

      assert_select "input[name=?]", "section[api_id]"

      assert_select "input[name=?]", "section[name]"

      assert_select "textarea[name=?]", "section[description]"
    end
  end
end
