class Movie < ActiveRecord::Base
  validates_presence_of :title
  validates_presence_of :year
  validates_presence_of :synopsis
  validates_presence_of :rating
end
