module SessionTestHelper
  module Request
    def sign_in_as(user)
      Current.session = user.active_sessions.create!

      ActionDispatch::TestRequest.create.cookie_jar.tap do |cookie_jar|
        cookie_jar.signed[:session_id] = Current.session.id
        cookies["session_id"] = cookie_jar[:session_id]
      end
    end

    def sign_out
      Current.session&.destroy!
      cookies.delete("session_id")
    end
  end

  module Feature
    def sign_in_as(user)
      Current.session = user.active_sessions.create!

      ActionDispatch::TestRequest.create.cookie_jar.tap do |cookie_jar|
        cookie_jar.signed[:session_id] = Current.session.id
        browser.cookies.set(name: "session_id", value: cookie_jar[:session_id], domain: Capybara.server_host)
      end
    end

    def sign_out
      Current.session&.destroy!
      browser.cookies.remove(name: "session_id")
    end

    def browser = Capybara.current_session.driver.browser
  end
end
