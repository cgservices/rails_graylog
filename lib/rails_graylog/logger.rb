require 'logger'

module RailsGraylog
  class Logger < ::Logger
    attr_accessor :formatter, :default_formatter, :progname, :error_handler

    alias add log

    def initialize(notifier, error_handler = nil)
      @notifier = notifier
      @error_handler = error_handler
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
      return if message.nil? || message.to_s.empty? || severity < level
      notify_message(SEV_LABEL[severity], message)
    end

    private

    def notify_message(severity, message)
      params = normalize_message(severity, message)
      @notifier.notify!(params)
    end

    def normalize_message(severity, message)
      message_hash = { severity: severity }

      if message.is_a?(Hash)
        message[:full_message] = message[:message] if message.key?(:message)
        writing_object = message.key?(:writing_object) ? message[:writing_object] : nil
        message[:short_message] = generate_short_message(message, writing_object) unless message.key?(:short_message)
        message.reject { |k| k == :writing_object }.merge(message_hash)
      elsif message.is_a?(Exception)
        extract_hash_from_exception(message).merge(severity: severity)
      else
        short_message = generate_short_message(message)
        message_hash.merge(short_message: short_message, full_message: message.to_s)
      end
    end

    def generate_short_message(message, writing_object = nil)
      return message[:short_message] if message.is_a?(Hash) && message.key?(:short_message)
      m = message.is_a?(Hash) && message.key?(:message) ? message[:message] : message
      writing_object.nil? ? "#{m.to_s[0...25]}..." : "#{writing_object.class.name}_#{writing_object.id}"
    end

    def extract_hash_from_exception(exception)
      bt = exception.backtrace || ["Backtrace is not available."]
      {
        short_message: "#{exception.class}: #{exception.message}",
        full_message: "Backtrace:\n" + bt.join("\n")
      }
    end
  end
end
