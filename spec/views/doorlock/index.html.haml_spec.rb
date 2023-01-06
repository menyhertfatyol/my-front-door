require 'rails_helper'

RSpec.describe 'doorlock/index.html.haml', type: :view do
  context 'when lock state information is outdated' do
    let(:doorlock) { OpenStruct.new(updated_at: 3.minutes.ago.to_s) }

    before { assign :doorlock, doorlock }

    it 'renders a warning message about the outdated data' do
      render
      expect(rendered).to match(/Missing status updates since/)
    end
  end

  context 'when doorlock is open' do
    let(:doorlock) { OpenStruct.new(lock_state: 'open', updated_at: 1.minute.ago.to_s) }

    before { assign :doorlock, doorlock }

    it 'renders page content referring to open door' do
      render
      expect(rendered).to match(/The front door is:/)
      expect(rendered).to match(/open/)
    end
  end

  context 'when doorlock is locked' do
    let(:doorlock) { OpenStruct.new(lock_state: 'locked', updated_at: 1.minute.ago.to_s) }

    before { assign :doorlock, doorlock }

    it 'renders page content referring to locked door' do
      render
      expect(rendered).to match(/The front door is:/)
      expect(rendered).to match(/locked/)
    end
  end
end
