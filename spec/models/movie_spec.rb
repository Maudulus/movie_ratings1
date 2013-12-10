require 'spec_helper'

describe Movie do
  it { should validate_presence_of :title }
  it { should validate_presence_of :year }
  it { should validate_presence_of :rating }
  it { should validate_presence_of :genre }

  it { should have_many :cast_members }
  it { should have_many :actors }
  it { should belong_to :genre }
  it { should belong_to :studio }
end
