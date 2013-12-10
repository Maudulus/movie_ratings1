class CastMember < ActiveRecord::Base
  belongs_to :movie
  belongs_to :actor

  validates_presence_of :movie
  validates_presence_of :actor
end
