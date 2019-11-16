module UiHelper
  def create_user
    user_props = FactoryBot.attributes_for(:user)
    user = FactoryBot.create(:user, user_props)
    user_props.merge(id: user.id, uid: user.uid)
  end

  def signup registration, success: true
    fillin_signup registration
    expect(page).to have_button("Sign Up", disabled: false) if success
    click_on("Sign Up")
    sleep(3.seconds)

    if success
      expect(page).to have_no_button("Sign Up")
    else
      expect(page).to have_button("Sign Up")
    end
  end

  def fillin_login credentials
    visit root_path unless page.has_css?('#navbar-loginlabel')
    find("#navbar-loginlabel", text: "Login").click
    within("#login-form") do
      fill_in("login_email", with: credentials[:email])
      fill_in("login_password", with: credentials[:password])
    end
  end

  def login credentials
    fillin_login(credentials)

    within("#login-form") do
      click_button("Login")
    end

    expect(page).to have_no_css("#login-form", wait: 5)

    expect(page).to have_css("#logout-form", visible: false)
    expect(page).to have_css("#navbar-loginlabel", text: /#{credentials[:name]}/)
  end

  def logged_in? account = nil
    account ?
        page.has_css?("#navbar-loginlabel", text: /#{account[:name]}/) :
        page.has_css?("#user_id", text: /.+/, visible: false)
  end

  def logout
    if logged_in?
      find("#navbar-loginlabel").click unless page.has_button?("Logout")
      find_button("Logout").click

      expect(page).to have_no_css("#user_id")
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

  def wait_until
    Timeout.timeout(Capybara.default_max_wait_time) do
      sleep(0.1) until value = yield
      value
    end
  end
end
