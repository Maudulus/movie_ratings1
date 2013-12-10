require 'spec_helper'

describe Genre do
  it { should have_many :movies }
  it { should validate_presence_of :name }
end
