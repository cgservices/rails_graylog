require 'spec_helper'

class Rails; end # monkey patch

describe RailsGraylog::UDPNotifier do
  let(:notifier) { double }
  subject { described_class.new(notifier) }

  before do
    allow(Rails).to receive(:application).and_return(double)
    allow(RSpec::Mocks::Double).to receive(:parent_name)
  end

  describe '#initialize' do
    it 'requires a notifier parameter' do
      expect { described_class.new }.to raise_error(ArgumentError)
    end
  end

  describe '#notify!' do
    it 'delegates to the notifier instance' do
      expect(notifier).to receive(:notify!)
      subject.notify!('')
    end
  end
end
