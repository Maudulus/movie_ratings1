class QuerieddMovie < ActiveRecord::Base
  validates_uniqueness_of :movie_id
end
