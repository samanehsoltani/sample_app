require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "invalid signup information" do

    get signup_path

    assert_no_difference 'User.count' do
      post users_path, user: { name:  "",
                               email: "user@invalid",
                               password:              "foo",
                               password_confirmation: "bar" }
    end
    # check that a failed submission re-renders the new action
    assert_template 'users/new'

    assert_difference 'User.count', 1 do
      # post to the users path. arranges to follow the redirect after submission, resulting in a rendering of the ’users/show’ template
      post_via_redirect users_path, user: { name:  "Example User",
                                            email: "user@example.com",
                                            password:              "password",
                                            password_confirmation: "password" }
    end
    assert_template 'users/show'

  end

end

=begin
#assert_no_difference:
before_count = User.count
post users_path, ...
    after_count  = User.count
assert_equal before_count, after_count
=end
