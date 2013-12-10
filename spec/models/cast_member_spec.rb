require 'spec_helper'

describe CastMember do
  it { should belong_to :movie }
  it { should belong_to :actor }

  it { should validate_presence_of :movie }
  it { should validate_presence_of :actor }
end
