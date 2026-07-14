require "rails_helper"

RSpec.describe Album, type: :model do
  subject { build(:album) }

  describe "associations" do
    it { is_expected.to belong_to(:artist) }
    it { is_expected.to have_many(:tracks).dependent(:destroy) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:title) }
  end
end
