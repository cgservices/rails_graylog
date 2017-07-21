require 'spec_helper'

class Rails; end # monkey patch

describe RailsGraylog::GelfNotifier do
  let(:notifier) { double }

  before do
    allow(Rails).to receive(:application).and_return(double)
    allow(RSpec::Mocks::Double).to receive(:parent_name)
  end

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
