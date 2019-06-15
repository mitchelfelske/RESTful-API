require 'rails_helper'

RSpec.describe 'Authentication', type: :request do
      # Authentication test suite
    let(:user) { create(:user) }
        
    path '/auth/login' do
        post 'Retrives user\'s token' do
            tags 'Login'
            consumes 'application/json'
            parameter name: :credentials, in: :body, schema: {
                type: :object,
                properties: {
                    email: { type: :string },
                    password: { type: :string }
                }, required: [ 'email', 'password' ]
            }
    
            response '200', 'User logged in successfully' do
                let(:credentials) do
                    {
                        email: user.email,
                        password: user.password
                    }
                end

                run_test! do
                    expect(json['auth_token']).not_to be_nil 
                end
            end
        
            # returns failure message when request is invalid
            response '401', "Invalid credentials" do
                let(:credentials) do
                    {
                        email: Faker::Internet.email,
                        password: Faker::Internet.password
                    }
                end
                            
                run_test! do
                    expect(json['message']).to match(/Invalid credentials/)
                end
            end
        end
    end
end
