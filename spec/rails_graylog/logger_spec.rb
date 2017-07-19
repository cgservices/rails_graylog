require 'spec_helper'

class Rails; end

describe RailsGraylog::Logger do
  let(:config) { double }
  let(:notifier) { double }
  let(:message) { Faker::Lorem.sentence }
  let(:data_hash) { { short_message: message, full_message: message } }

  before do
    allow(Rails).to receive(:configuration).and_return(config)
    allow(config).to receive(:graylog_notifier).and_return(notifier)
  end

  describe '#fatal' do
    it 'logs a message' do
      expect(subject).to receive(:log).with(message, nil)
      subject.fatal(message)
    end
  end

  describe '#info' do
    context 'when logging a string message' do
      it 'calls the graylog notifier' do
        expect(notifier).to receive(:notify!).with(short_message: "#{message[0...25]}...", full_message: message)
        subject.info(message, nil)
      end
    end

    context 'when logging hash data' do
      it 'calls the graylog notifier' do
        expect(notifier).to receive(:notify!).with(short_message: "#{message[0...25]}...", full_message: message)
        subject.info(data_hash)
      end
    end

    context 'when logging a message with related writing object' do
      let(:writing_object) { OpenStruct.new(id: 1) }

      it 'calls the graylog notifier' do
        expect(notifier).to receive(:notify!).with(short_message: 'OpenStruct_1', full_message: message)
        subject.info(message, writing_object)
      end
    end
  end
end
