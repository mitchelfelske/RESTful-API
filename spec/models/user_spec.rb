require 'rails_helper'

RSpec.describe User, type: :model do
  # Association test
  # ensure User model has a 1:n relationship with the Todo model
  it { should have_many(:todos) }

  # Validation test
  # ensure presence before saving
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password_digest) }
end

