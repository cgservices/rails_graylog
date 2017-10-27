require 'spec_helper'

describe RailsGraylog::AmqpNotifier do
  let(:channel) { double }
  let(:queue) { double }

  before do
    allow(Mq).to receive(:channel).and_return(channel)
    allow(channel).to receive(:queue).and_return(queue)
  end

  describe '#initialize' do
    it 'initializes the GELF notifier by default' do
      expect(channel).to receive(:queue)
      subject
    end
  end

  describe '#notify!' do
    it 'delegates to the notifier instance' do
      expect(queue).to receive(:publish)
      subject.notify!({})
    end
  end
end
