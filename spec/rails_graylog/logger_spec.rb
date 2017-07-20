require 'spec_helper'

describe RailsGraylog::Logger do
  let(:notifier) { double }
  let(:message) { Faker::Lorem.sentence }
  let(:data_hash) { { short_message: message, full_message: message } }

  subject { described_class.new(STDOUT, notifier) }

  describe '#initialize' do
    it 'initializes the default notifier' do
      expect(RailsGraylog::Notifier).to receive(:new)
      described_class.new(STDOUT)
    end
  end

  describe '#error' do
    it 'logs a message when a block is passed' do
      expect(subject).to receive(:log).with('ERROR', message, nil)
      subject.error { message }
    end
  end

  describe '#fatal' do
    it 'logs a message' do
      expect(subject).to receive(:log).with('FATAL', message, nil)
      subject.fatal(message)
    end
  end

  describe '#info' do
    context 'when logging a string message' do
      it 'calls the graylog notifier' do
        expect(notifier).to receive(:notify!).with(short_message: "#{message[0...25]}...", full_message: message, severity: 'INFO')
        subject.info(message, nil)
      end
    end

    context 'when logging a message with related writing object' do
      let(:writing_object) { OpenStruct.new(id: 1) }

      it 'calls the graylog notifier' do
        expect(notifier).to receive(:notify!).with(short_message: 'OpenStruct_1', full_message: message, severity: 'INFO')
        subject.info(message, writing_object)
      end
    end

    context 'when logging hash data including short and full message' do
      it 'calls the graylog notifier' do
        expect(notifier).to receive(:notify!).with(data_hash.merge(severity: 'INFO'))
        subject.info(data_hash)
      end
    end

    context 'when logging hash data without short and full message' do
      let(:data_hash) { { foo: 'bar' } }

      it 'calls the graylog notifier and composes a customized short and full message' do
        expect(notifier).to receive(:notify!).with(data_hash.merge(short_message: "#{data_hash.to_json[0...25]}...",
                                                                   full_message: data_hash.to_json,
                                                                   severity: 'INFO'))
        subject.info(data_hash)
      end
    end
  end
end
