require 'rails_helper'

RSpec.describe Todo, type: :model do

  #Validation tests
  #Ensure columns are present before saving
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:created_by) }

end
