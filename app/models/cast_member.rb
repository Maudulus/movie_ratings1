class CastMember < ActiveRecord::Base
  belongs_to :movie
  belongs_to :actor

  validates_presence_of :character
end
