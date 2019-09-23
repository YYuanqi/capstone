module UiHelper
  def signup registration, success: true
    fillin_signup registration
    click_on("Sign Up")
    sleep(3.seconds)

    if success
      expect(page).to have_no_button("Sign Up")
    else
      expect(page).to have_button("Sign Up")
    end
  end

  def fillin_signup registration
    visit "#{ui_path}/#/signup" unless page.has_css?("#signup-form")
    using_wait_time 5 do
      expect(page).to have_css("#signup-form")
    end

    fill_in("signup-email", with: registration[:email])
    fill_in("signup-name", with: registration[:name])
    fill_in("signup-password", with: registration[:password])
    registration[:password_confirmation] ||= registration[:password]
    fill_in("signup-password_confirmation", with: registration[:password_confirmation])
  end
end
