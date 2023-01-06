require 'rails_helper'

RSpec.describe 'Doorlocks', type: :request do
  include_context 'dynamodb user'

  describe 'GET /' do
    let(:lock_state) { { item: { lock_state: 'locked', updated_at: Time.now } } }
    before { allow(StatusStorage).to receive(:read_state).and_return lock_state }

    it 'returns http success' do
      get '/'
      expect(response).to have_http_status(:success)
    end
  end
end
