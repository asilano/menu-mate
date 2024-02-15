class User < ApplicationRecord
  validates :google_userid, presence: true

  def self.create_from(google_account_info)
    create(attributes_from google_account_info)
  end

  def update_from(google_account_info)
    update(User.attributes_from google_account_info)
  end

  def self.attributes_from(google_account_info)
    {
      google_userid: google_account_info["sub"],
      email: google_account_info["email"],
      name: google_account_info["name"],
      first_name: google_account_info["first_name"],
      picture_uri: google_account_info["picture"]
    }
  end
end
