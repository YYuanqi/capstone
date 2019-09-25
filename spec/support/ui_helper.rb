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

  def login credentials
    visit root_path
    find("#navbar-loginlabel", text: "Login").click
    within("#login-form") do
      fill_in("login_email", with: credentials[:email])
      fill_in("login_password", with: credentials[:password])
      click_button("Login")
    end
    using_wait_time 5 do
      expect(page).to have_no_css("#login-form")
    end

    expect(page).to have_css("#logout-form", visible: false)
    expect(page).to have_css("#navbar-loginlabel", text: /#{credentials[:name]}/)
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
