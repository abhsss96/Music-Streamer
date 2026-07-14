require "rails_helper"

RSpec.describe Artist, type: :model do
  subject { build(:artist) }

  describe "associations" do
    it { is_expected.to have_many(:albums).dependent(:destroy) }
    it { is_expected.to have_many(:tracks).dependent(:destroy) }
    it { is_expected.to have_many(:follows).dependent(:destroy) }
    it { is_expected.to have_many(:followers).through(:follows) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
  end
end
