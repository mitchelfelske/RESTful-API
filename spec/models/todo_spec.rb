require 'rails_helper'

RSpec.describe Todo, type: :model do

  #Association tests
  # Ensure Todo model has a 1:m relationship with the Item model
  it { should have_many(:items).dependent(:destroy)}

  #Validation tests
  #Ensure columns are present before saving
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:created_by) }

end
