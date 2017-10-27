require 'spec_helper'

class Rails; end # monkey patch

describe RailsGraylog::UDPNotifier do
  before do
    allow(Rails).to receive(:application).and_return(double)
    allow(RSpec::Mocks::Double).to receive(:parent_name)
  end

  describe '#initialize' do
    it 'sets the gelf notifier by default' do
      expect(GELF::Notifier).to receive(:new)
      subject
    end
  end

  describe '#notify!' do
    it 'delegates to the notifier instance' do
      expect_any_instance_of(GELF::Notifier).to receive(:notify!)
      subject.notify!('')
    end
  end
end
