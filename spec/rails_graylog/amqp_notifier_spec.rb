require 'spec_helper'

describe RailsGraylog::AmqpNotifier do
  let(:notifier) { double }

  describe '#initialize' do
    it 'initializes the GELF notifier by default' do
      expect(GELF::Notifier).to receive(:new)
      subject
    end
  end

  describe '#notify!' do
    subject { described_class.new(notifier) }

    it 'delegates to the notifier instance' do
      expect(notifier).to receive(:notify!)
      subject.notify!('')
    end
  end
end
