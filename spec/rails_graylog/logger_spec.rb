require 'spec_helper'

describe RailsGraylog::Logger do
  let(:notifier) { double }
  let(:message) { Faker::Lorem.sentence }
  let(:data_hash) { { short_message: message, full_message: message, writing_object: writing_object } }
  let(:writing_object) { OpenStruct.new(id: 1) }

  subject { described_class.new(notifier) }

  it { is_expected.to respond_to(:add, :datetime_format, :debug?) }

  describe '#initialize' do
    it 'initializes the default notifier' do
      expect(RailsGraylog::GelfNotifier).to receive(:new)
      described_class.new
    end
  end

  describe '#error' do
    it 'logs a message when a block is passed' do
      expect(subject).to receive(:log).with('ERROR', message)
      subject.error { message }
    end
  end

  describe '#fatal' do
    it 'logs a message' do
      expect(subject).to receive(:log).with('FATAL', message)
      subject.fatal(message)
    end
  end

  describe '#info' do
    context 'when logging a string message' do
      it 'calls the graylog notifier' do
        expect(notifier).to receive(:notify!).with(short_message: "#{message[0...25]}...", full_message: message, severity: 'INFO')
        subject.info(message)
      end
    end

    context 'when logging a message with related writing object' do
      it 'calls the graylog notifier' do
        expect(notifier).to receive(:notify!).with(message: message, full_message: message, short_message: 'OpenStruct_1', severity: 'INFO')
        subject.info(message: message, writing_object: writing_object)
      end
    end

    context 'when logging hash data including short and full message' do
      it 'calls the graylog notifier' do
        expect(notifier).to receive(:notify!).with(data_hash.reject { |k| k == :writing_object }.merge(severity: 'INFO'))
        subject.info(data_hash)
      end
    end

    context 'when logging hash data without short and full message' do
      let(:data_hash) { { foo: 'bar' } }

      it 'calls the graylog notifier and composes a customized short and full message' do
        expect(notifier).to receive(:notify!).with(data_hash.merge(short_message: "#{data_hash.to_s[0...25]}...",
                                                                   severity: 'INFO'))
        subject.info(data_hash)
      end
    end
  end
end
