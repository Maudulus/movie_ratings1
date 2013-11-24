class QueriedMovie < ActiveRecord::Base
  validates_uniqueness_of :movie_id
end
