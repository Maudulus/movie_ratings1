class Actor < ActiveRecord::Base
  validates_presence_of :name

  has_many :cast_members
  has_many :movies, through: :cast_members
end
