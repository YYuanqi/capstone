require 'rails_helper'

RSpec.feature "Authns", type: :feature, :js => true do

  feature "sign-up" do
    include_context "db_cleanup_each"
    let(:user_props) {FactoryBot.attributes_for(:user)}

    feature "sign up" do
      context "valid user_props" do
        scenario "creates account and navigates away from signup page" do
          start_time = Time.now
          visit "#{ui_path}/#/singup" unless page.has_css?("#signup-form")
          expect(page).to have_css("#signup-form")

          fill_in("signup-eamil", with: user_props[:email])
          fill_in("signup-name", with: user_props[:name])
          fill_in("signup-password", with: user_props[:password])
          fill_in("signup-password-confirmation", with: user_props[:password])
          click_on("Sign Up")
          expect(page).to have_no_button("Sign Up")

          expect(page).to have_no_css("#signup-form")
          user = User.where(email: user_props[:eamil]).first
          expect(user.create).to be > start_time
        end
      end
    end

    context "rejected user_props" do
      scenario "account not created and stays on page"
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