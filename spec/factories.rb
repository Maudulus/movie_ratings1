FactoryGirl.define do

  factory :movie do
    sequence(:title) { |n| "Movie Title #{n}" }
    year 2013
    rating 50

    genre
  end

  factory :genre do
    sequence(:name) { |n| "Genre #{n}" }
  end

end
