require 'spec_helper'

describe Movie do
  it { should validate_presence_of :title }
  it { should validate_presence_of :year }
  it { should validate_presence_of :genre }

  it { should have_many :cast_members }
  it { should have_many :actors }
  it { should belong_to :genre }
  it { should belong_to :studio }

  describe ".search" do
    let!(:annie_hall) { FactoryGirl.create(:movie, title: "Annie Hall") }
    let!(:manhattan) { FactoryGirl.create(:movie, title: "Manhattan") }
    let!(:mystery) { FactoryGirl.create(:movie, title: "Manhattan Murder Mystery") }
    let!(:sam) do
      FactoryGirl.create(:movie,
        title: "Play It Again, Sam",
        synopsis: "Something about Casablanca in here.")
    end

    it "matches movie titles exactly" do
      results = Movie.search('Annie Hall')

      expect(results.count).to eq(1)
      expect(results.include?(annie_hall)).to be_true
    end

    it "partially matches movie titles" do
      results = Movie.search('Manhat')

      expect(results.count).to eq(2)
      expect(results.include?(manhattan)).to be_true
      expect(results.include?(mystery)).to be_true
    end

    it "is case-insensitive" do
      results = Movie.search("annie")

      expect(results.count).to eq(1)
      expect(results.include?(annie_hall)).to be_true
    end

    it "matches the synopsis" do
      results = Movie.search("Casablanca")

      expect(results.count).to eq(1)
      expect(results.include?(sam)).to be_true
    end
  end

  describe "ratings" do
    let!(:best) { FactoryGirl.create(:movie, rating: 95) }
    let!(:worst) { FactoryGirl.create(:movie, rating: 2) }
    let!(:middle) { FactoryGirl.create(:movie, rating: 75) }

    describe ".highest_rated" do
      it "returns the movies with highest rating first" do
        best_movies = Movie.highest_rated(3)

        expect(best_movies[0]).to eq(best)
        expect(best_movies[1]).to eq(middle)
        expect(best_movies[2]).to eq(worst)
      end

      it "limits the number of results returned" do
        best_movies = Movie.highest_rated(2)
        expect(best_movies.count).to eq(2)
      end
    end

    describe ".lowest_rated" do
      it "returns the movies with lowest rating first" do
        worst_movies = Movie.lowest_rated(3)

        expect(worst_movies[0]).to eq(worst)
        expect(worst_movies[1]).to eq(middle)
        expect(worst_movies[2]).to eq(best)
      end

      it "limits the number of results returned" do
        worst_movies = Movie.lowest_rated(2)
        expect(worst_movies.count).to eq(2)
      end
    end
  end

  describe ".most_recent" do
    let!(:earliest) { FactoryGirl.create(:movie, year: 1950) }
    let!(:latest) { FactoryGirl.create(:movie, year: 2003) }
    let!(:middle) { FactoryGirl.create(:movie, year: 1980) }

    it "returns the movies sorted by year" do
      most_recent_movies = Movie.most_recent(3)

      expect(most_recent_movies[0]).to eq(latest)
      expect(most_recent_movies[1]).to eq(middle)
      expect(most_recent_movies[2]).to eq(earliest)
    end

    it "limits the number of results returned" do
      most_recent_movies = Movie.most_recent(2)
      expect(most_recent_movies.count).to eq(2)
    end
  end
end
