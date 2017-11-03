require 'spec_helper'

describe RailsGraylog::AmqpNotifier do
  let(:channel) { double }
  let(:queue) { double }
  subject { described_class.new(channel: channel, exception_handler: nil) }

  before do
    allow(Socket).to receive(:gethostname).and_return('localhost')
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
      expect(queue).to receive(:publish).with({ host: 'localhost', version: '1.1', key: 'value' }.to_json)
      subject.notify!(key: 'value')
    end
  end
end
