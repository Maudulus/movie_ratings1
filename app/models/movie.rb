class Movie < ActiveRecord::Base
  validates_presence_of :title
  validates_presence_of :year
  validates_presence_of :genre

  has_many :cast_members
  has_many :actors, through: :cast_members

  belongs_to :genre
  belongs_to :studio

  def self.search(query)
    # Replace this with the appropriate ActiveRecord calls...
    all
  end

  def self.highest_rated(count)
    # Replace this with the appropriate ActiveRecord calls...
    all
  end

  def self.lowest_rated(count)
    # Replace this with the appropriate ActiveRecord calls...
    all
  end

  def self.most_recent(count)
    # Replace this with the appropriate ActiveRecord calls...
    all
  end
end
