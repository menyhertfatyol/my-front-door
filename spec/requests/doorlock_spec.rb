require 'rails_helper'

RSpec.describe 'Doorlocks', type: :request do
  include_context 'dynamodb user'

  describe 'GET /' do
    it 'returns http success' do
      get '/'
      expect(response).to have_http_status(:success)
    end
  end
end
