require 'spec_helper'

class Rails; end # monkey patch

describe RailsGraylog::AmqpNotifier do
  before do
    allow(Rails).to receive(:application).and_return(double)
    allow(RSpec::Mocks::Double).to receive(:parent_name)
  end

  let(:channel) { double }
  let(:exchange) { double }
  subject { described_class.new(channel: channel, exchange: exchange, exception_handler: nil) }

  before do
    allow(Socket).to receive(:gethostname).and_return('localhost')
    allow(channel).to receive(:exchange).and_return(exchange)
  end

  describe '#initialize' do
    it 'initializes the GELF notifier by default' do
      expect(channel).to receive(:exchange)
      subject
    end
  end

  describe '#notify!' do
    it 'delegates to the notifier instance' do
      expect(exchange).to receive(:publish).with({ host: 'localhost', version: '1.1', facility: nil, key: 'value' }.to_json, routing_key: 'log_write')
      subject.notify!(key: 'value')
    end
  end
end
