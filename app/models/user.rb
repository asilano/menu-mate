class User < ApplicationRecord
  has_many :active_sessions, dependent: :destroy
  has_many :recipes, dependent: :destroy
  has_many :tags, dependent: :destroy
  has_many :leftovers, dependent: :destroy
  has_one  :menu_plan, dependent: :destroy
  has_many :plan_days, through: :menu_plan

  validates :google_userid, presence: true

  GOOGLE_TO_DB_ATTRIB_MAP = {
    "sub" => :google_userid,
    "email" => :email,
    "name" => :name,
    "first_name" => :first_name,
    "picture" => :picture_uri
  }.freeze

  def self.create_from(google_account_info)
    create(attributes_from google_account_info)
  end

  def update_from(google_account_info)
    update(User.attributes_from(google_account_info).except(:google_userid))
  end

  def self.attributes_from(google_account_info)
    GOOGLE_TO_DB_ATTRIB_MAP
      .keys
      .select { |k| google_account_info.key?(k) }
      .map { |k| [GOOGLE_TO_DB_ATTRIB_MAP[k], google_account_info[k]] }
      .to_h
  end
end
