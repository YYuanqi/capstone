require 'rails_helper'

RSpec.feature "Authns", type: :feature, :js => true do

  feature "sign-up" do
    include_context "db_cleanup_each"
    let(:user_props) {FactoryBot.attributes_for(:user)}

      context "valid user_props" do
        scenario "creates account and navigates away from signup page" do
          start_time = Time.now
          signup user_props

          user = User.where(email: user_props[:email]).first
          expect(page).to have_no_css("#signup-form")
          expect(user.created_at).to be > start_time
        end
      end

      context "rejected user_props" do
        before(:each) do
          signup user_props
          expect(page).to have_no_css("#signup-form")
        end

        scenario "account not created and stays on page" do
          dup_user = FactoryBot.attributes_for(:user, email: user_props[:email])
          signup dup_user, sucess: false

          expect(page).to have_css("#signup-form")
          expect(User.where(email: user_props[:email], name: user_props[:name])).to exist
          expect(User.where(email: dup_user[:email], name: dup_user[:name])).to_not exist
        end
        scenario "displays error messages"
      end

      context "invalid field" do
        scenario "bad email"
        scenario "missing password"
      end
  end

  feature "anonymous user" do
    scenario "shown login form"
  end

  feature "login" do
    context "valid user login" do
      scenario "closes form and displays current user name"
      scenario "menu shows logout option"
      scenario "can access authenticated resources"
    end

    context "invalid login" do
      scenario "error message displayed and leaves user unauthenticated"
    end
  end

  feature "logout" do
    scenario "closes form and removes user name"
    scenario "can no longer access authenticated resources"
  end
end
