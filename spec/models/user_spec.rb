require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { create(:user) }

  it { should validate_presence_of :google_userid }
  it { should validate_uniqueness_of :google_userid }

  context "creating a user via Google" do
    context "with full information" do
      let(:google_data) do
        {
          "sub" => "123",
          "email" => "bob@example.com",
          "name" => "Bob Robson",
          "first_name" => "Eric",
          "picture" => "www.example.com/pic.png"
        }
      end

      it "saves the relevant data" do
        user = User.create_from(google_data)
        expect(user.attributes).to match hash_including({
          "google_userid" => "123",
          "email" => "bob@example.com",
          "name" => "Bob Robson",
          "first_name" => "Eric",
          "picture_uri" => "www.example.com/pic.png"
        })
        expect(user).to be_persisted
      end
    end

    context "with partial information" do
      let(:google_data) do
        {
          "sub" => "123",
          "email" => "bob@example.com"
        }
      end

      it "saves the relevant data" do
        user = User.create_from(google_data)
        expect(user.attributes).to match hash_including({
          "google_userid" => "123",
          "email" => "bob@example.com"
        })
        expect(user).to be_persisted
      end
    end

    context "missing the Google sub id" do
      let(:google_data) do
        {
          "email" => "bob@example.com",
          "name" => "Bob Robson",
          "first_name" => "Eric",
          "picture" => "www.example.com/pic.png"
        }
      end

      it "saves the relevant data" do
        user = User.create_from(google_data)
        expect(user.attributes).to match hash_including({
          "email" => "bob@example.com",
          "name" => "Bob Robson",
          "first_name" => "Eric",
          "picture_uri" => "www.example.com/pic.png"
        })
        expect(user).not_to be_persisted
        expect(user).to be_invalid
      end
    end
  end

  context "updating a pre-existing user" do
    context "with full information" do
      let(:google_data) do
        {
          "sub" => "1122334455",
          "email" => "dave@example.com",
          "name" => "Dave Lister",
          "first_name" => "John",
          "picture" => nil
        }
      end

      it "updates all fields except the Google sub" do
        user.update_from(google_data)
        expect(user.attributes).to match hash_including({
          "google_userid" => "987abc",
          "email" => "dave@example.com",
          "name" => "Dave Lister",
          "first_name" => "John",
          "picture_uri" => nil
        })
      end
    end

    context "with only partial information" do
      let(:google_data) do
        {
          "sub" => "1122334455",
          "email" => "dave@example.com",
          "picture" => nil
        }
      end

      it "only updates the information provided" do
        user.update_from(google_data)
        expect(user.attributes).to match hash_including({
          "google_userid" => "987abc",
          "email" => "dave@example.com",
          "name" => "Astarion Ancunin",
          "first_name" => "Astarion",
          "picture_uri" => nil
        })
      end
    end
  end
end
