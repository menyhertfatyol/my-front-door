require 'rails_helper'

RSpec.describe DoorlockHelper, type: :helper do
  let(:helper) { Class.new }
  before { helper.extend DoorlockHelper }

  describe '#lock_state' do
    subject(:lock_state) { helper.lock_state(last_lock_state) }

    context 'when the last database entry is older than 2 minutes' do
      let(:last_lock_state) { OpenStruct.new(updated_at: 3.minutes.ago.to_s) }

      it { is_expected.to eq 'error' }
    end

    context 'when the last database entry was within 2 minutes' do
      let(:last_lock_state) { OpenStruct.new(lock_state: 'open', updated_at: 1.minute.ago.to_s) }

      it 'returns the last lock state' do
        expect(lock_state).to eq last_lock_state.lock_state
      end
    end
  end

  describe '#background_color' do
    context 'when door is open' do
      it 'sets the background color to warning' do
        expect(helper.background_color('open')).to eq 'bg-warning'
      end
    end

    context 'when door is locked' do
      it 'sets the background color to info' do
        expect(helper.background_color('locked')).to eq 'bg-info'
      end
    end

    context 'when no data received' do
      it 'sets the background color to danger' do
        expect(helper.background_color('No data received...')).to eq 'bg-danger'
      end
    end
  end

  describe '#translate' do
    subject(:translation) { helper.translate(last_lock_state) }

    context 'when no data received' do
      let(:timestamp) { 3.minutes.ago.to_s }
      let(:last_lock_state) { OpenStruct.new(lock_state: 'open', updated_at: timestamp) }
      it { is_expected.to eq "Missing status updates since #{Date.strptime(timestamp, '%F %R')}" }
    end

    context 'when door is open' do
      let(:last_lock_state) { OpenStruct.new(lock_state: 'open', updated_at: 1.minute.ago.to_s) }
      it { is_expected.to eq 'open' }
    end

    context 'when door is locked' do
      let(:last_lock_state) { OpenStruct.new(lock_state: 'locked', updated_at: 1.minute.ago.to_s) }
      it { is_expected.to eq 'locked' }
    end
  end
end
