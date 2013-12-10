require 'spec_helper'

feature 'user views movie' do

  scenario 'see list of movies' do
    movies = FactoryGirl.create_list(:movie, 5)

    visit movies_path

    movies.each do |movie|
      expect(page).to have_link(movie.title, movies_path(movie))
    end
  end
end
