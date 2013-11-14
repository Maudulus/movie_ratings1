class Movie < ActiveRecord::Base
  validates_presence_of :title
  validates_presence_of :year
  validates_presence_of :rating

  has_many :cast_members
  has_many :actors, through: :cast_members

  has_many :movie_genres
  has_many :genres, through: :movie_genres
end
