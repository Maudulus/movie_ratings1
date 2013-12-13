class MoviesController < ApplicationController
  def index
    @movies = filter_movies(params)
  end

  def show
    @movie = Movie.find(params[:id])
  end

  private

  def filter_movies(params)
    if params[:filter] == 'highest-rated'
      Movie.highest_rated(params[:count].to_i)
    elsif params[:filter] == 'lowest-rated'
      Movie.lowest_rated(params[:count].to_i)
    elsif params[:filter] == 'most-recent'
      Movie.most_recent(params[:count].to_i)
    elsif params[:filter] == 'search'
      Movie.search(params[:query])
    else
      Movie.all
    end
  end
end
