require "rails_helper"

RSpec.describe Like, type: :model do
  subject { create(:like) }

  describe "associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:track) }
  end

  describe "validations" do
    it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:track_id) }
  end
end
