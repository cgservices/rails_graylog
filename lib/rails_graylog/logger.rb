require 'logger'

module RailsGraylog
  class Logger < ::Logger
    attr_accessor :formatter, :default_formatter, :progname

    alias add log

    def initialize(notifier = nil)
      @notifier = notifier || GelfNotifier.new
      @progname = @formatter = @default_formatter = nil
    end

    def fatal(message = nil, &_block)
      message = yield if block_given? && message.nil?
      log(::Logger::FATAL, message)
    end

    def error(message = nil, &_block)
      message = yield if block_given? && message.nil?
      log(::Logger::ERROR, message)
    end

    def warn(message = nil, &_block)
      message = yield if block_given? && message.nil?
      log(::Logger::WARN, message)
    end

    def info(message = nil, &_block)
      message = yield if block_given? && message.nil?
      log(::Logger::INFO, message)
    end

    def debug(message = nil, &_block)
      message = yield if block_given? && message.nil?
      log(::Logger::DEBUG, message)
    end

    def log(severity, message = nil, _progname = nil, &_block)
      return if message.nil? || message.empty? || severity < level
      notify_message(SEV_LABEL[severity], message)
    end

    private

    def notify_message(severity, message)
      params = normalize_message(severity, message)
      @notifier.notify!(params)
    end

    def normalize_message(severity, message)
      if message.is_a?(Hash)
        message[:full_message] = message[:message] if message.key?(:message)
        writing_object = message.key?(:writing_object) ? message[:writing_object] : nil
        message[:short_message] = generate_short_message(message, writing_object) unless message.key?(:short_message)
        return message.reject { |k| k == :writing_object }.merge(severity: severity)
      end

      short_message = generate_short_message(message)
      { short_message: short_message, full_message: message, severity: severity }
    end

    def generate_short_message(message, writing_object = nil)
      writing_object.nil? ? "#{message.to_s[0...25]}..." : "#{writing_object.class.name}_#{writing_object.id}"
    end
  end
end
