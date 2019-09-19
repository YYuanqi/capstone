module UiHelper
  def signup registration, sucess: true
    visit "#{ui_path}/#/signup" unless page.has_css?("#signup-form")
    expect(page).to have_css("#signup-form")

    fill_in("signup-email", with: registration[:email])
    fill_in("signup-name", with: registration[:name])
    fill_in("signup-password", with: registration[:password])
    registration[:password_confirmation] ||= registration[:password]
    fill_in("signup-password_confirmation", with: registration[:password_confirmation])
    click_on("Sign Up")
    sleep(3.seconds)

    if sucess
      expect(page).to have_no_button("Sign Up")
    else
      expect(page).to have_button("Sign Up")
    end
  end
end
