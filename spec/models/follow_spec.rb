require "rails_helper"

RSpec.describe Follow, type: :model do
  subject { create(:follow) }

  describe "associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:artist) }
  end

  describe "validations" do
    it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:artist_id) }
  end
end
