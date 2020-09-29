require 'rails_helper'

RSpec.describe TokenService, type: :service do
  describe '#create_jwt_token' do
    it 'returns a string' do
      expect(TokenService.create_jwt_token({ a: 1, b: 2 })).to be_a(String)
    end
  end

  describe '#user_token_error' do
    context 'with message' do
      it 'raise a BadRequestException with message' do
        expect { TokenService.user_token_error('custom message') }.to raise_error(BadRequestException, 'custom message')
      end
    end

    context 'without message' do
      it 'raise a BadRequestException with message' do
        expect { TokenService.user_token_error }.to raise_error(BadRequestException, 'Invalid User Token')
      end
    end
  end

  describe '#decode_jwt' do
    [
        { a: 4, b: 6 },
        { 'a' => 4, 'b' => 6 },
        [1, 1, 2, 3, 5, 8],
        'Test String',
    ].each do |value|
      context "decoding a #{value.class}" do
        it 'returns the correct value' do
          if value.is_a? Hash
            expect(TokenService.send(:decode_jwt, TokenService.create_jwt_token(value)).first).to eq(value.stringify_keys)
          else
            expect(TokenService.send(:decode_jwt, TokenService.create_jwt_token(value)).first).to eq(value)
          end
        end
      end
    end

    [
        nil,
        5,
        5.5,
        true,
        false
    ].each do |value|
      context "decoding invalid encoded class #{value.class}" do
        it 'raises exception' do
          expect { TokenService.send(:decode_jwt, TokenService.create_jwt_token(value)) }.to raise_error(NoMethodError)
        end
      end
    end

    context 'Invalid token' do
      it 'calls user_token_error' do
        expect(TokenService).to receive(:user_token_error)
        TokenService.send(:decode_jwt, '1234')
      end
    end
  end
end
