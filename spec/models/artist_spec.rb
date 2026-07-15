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

  describe ".search" do
    it "finds artists whose name matches the query" do
      match = create(:artist, name: "Componibile Sunrise")
      create(:artist, name: "Marlowe & The Tin Cans")

      expect(Artist.search("sunrise")).to eq([ match ])
    end

    it "returns none when nothing matches" do
      create(:artist, name: "Componibile Sunrise")

      expect(Artist.search("zzzznotfound")).to be_empty
    end
  end

  describe "#as_json" do
    it "never includes the internal search_vector column" do
      artist = create(:artist)

      expect(artist.as_json).not_to have_key("search_vector")
    end
  end
end
