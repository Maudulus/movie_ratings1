require 'spec_helper'

describe Actor do
  it { should have_many :movies }
  it { should have_many :cast_members }

  it { should validate_presence_of :name }
end
