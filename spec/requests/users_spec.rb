require 'rails_helper'

RSpec.describe 'Users API', type: :request do
    let(:user) { build(:user) }
    let!(:users) { create_list(:user, 10) }

    path '/users' do
        get 'Retrieves all users' do
          tags 'User'
          produces 'application/json'
                    
          response '200', 'Users list retrieved successfully' do
            schema type: :array,
                   properties: {
                    name: { type: :string},
                    email: { type: :string },
                    password: { type: :string }
                   }
    
            run_test! do            
              expect(json).not_to be_empty
              expect(json.size).to eq(10)
            end
          end
        end
    end

    path '/signup' do
        post 'Creates an user account' do
            tags 'Signup'
            consumes 'application/json'
            parameter name: :account, in: :body, schema: {
                type: :object,
                properties: {
                    name: { type: :string},
                    email: { type: :string },
                    password: { type: :string }
                }, required: [ 'name', 'email', 'password' ]
            }
    
            response '201', 'User\'s account created successfully' do
                let(:account) do
                    {
                        name: user.name,
                        email: user.email,
                        password: user.password,
                        password_confirmation: user.password
                    }
                end
                    
                run_test! do
                    expect(json['message']).to match(/Account created successfully/) 
                    expect(json['auth_token']).not_to be_nil
                end
            end

            response '422', "Invalid user account" do
                let(:account) { {} }
                
                run_test! do
                    expect(json['message']).to match(/Validation failed: Password can't be blank, Name can't be blank, Email can't be blank/)
                end
            end
        end
    end
end
