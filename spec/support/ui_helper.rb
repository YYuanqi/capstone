module UiHelper
  def signup user_props, sucess: true
    visit "#{ui_path}/#/signup" unless page.has_css?("#signup-form")
    expect(page).to have_css("#signup-form")

    fill_in("signup-email", with: user_props[:email])
    fill_in("signup-name", with: user_props[:name])
    fill_in("signup-password", with: user_props[:password])
    fill_in("signup-password_confirmation", with: user_props[:password])
    click_on("Sign Up")
    sleep(3.seconds)

    if sucess
      expect(page).to have_no_button("Sign Up")
    else
      expect(page).to have_button("Sign Up")
    end
  end
end
