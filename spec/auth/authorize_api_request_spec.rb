require 'rails_helper'

RSpec.describe AuthorizeApiRequest do
    
    # let = lazily instantiated variables 
    # let! = eagerly instantiated variables
    let(:user) { create(:user) }

    # Mock Authorization header
    let(:header) { { 'Authorization' => token_generator(user.id) } }

    # subject = lazily instantiated of the object being tested
    # subject! = eagerly instantiated of the object being tested

    # Valid request
    subject(:request_obj) { described_class.new(header) }

    # Invalid request
    subject(:invalid_request_obj) { described_class.new({}) }

    # Test suite for AuthorizeApRequest#call
    # This is the entry point of the service class  
    describe '#call' do 
        context 'when request is valid' do
            it 'returns user obejct' do
                result = request_obj.call
                expect(result[:user]).to eq(user)
            end
        end

        context 'when invalid request' do
            context 'missing token' do
                it 'raises a MissingToken error' do
                    expect { invalid_request_obj.call }
                        .to raise_error(ExceptionHandler::MissingToken, 'Missing token')
                end
            end

            context 'invalid token' do
                subject(:invalid_request_obj) do
                    described_class.new('Authorization' => token_generator(5))
                end

                it 'raises an InvalidToken error' do
                    expect { invalid_request_obj.call }
                        .to raise_error(ExceptionHandler::InvalidToken, /Invalid token/)
                end
            end

            context 'token is fake' do
                subject(:invalid_request_obj) do
                    described_class.new('Authorization' => 'foobar')
                end

                it 'raises an InvalidToken error' do
                    expect { invalid_request_obj.call }
                        .to raise_error(ExceptionHandler::InvalidToken, /Not enough or too many segments/)
                end
            end

            context 'token is expired' do
                subject(:request_obj) do
                    described_class.new('Authorization' => expired_token_generator(user.id))
                end

                it 'raises an InvalidToken error' do
                    expect { request_obj.call }
                        .to raise_error(ExceptionHandler::InvalidToken, /Signature has expired/)
                end
            end
            
        end
    end
end
