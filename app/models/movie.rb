class Movie < ActiveRecord::Base
  validates_presence_of :title
  validates_presence_of :year
  validates_presence_of :genre

  has_many :cast_members
  has_many :actors, through: :cast_members

  belongs_to :genre
  belongs_to :studio
end
