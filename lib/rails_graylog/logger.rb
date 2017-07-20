require 'logger'
require 'rails_graylog/notifier'

module RailsGraylog
  class Logger < ::Logger
    def initialize(name, notifier = nil)
      @notifier = notifier || Notifier.new
      super name
    end

    def fatal(message = nil, writing_object = nil, &block)
      message = yield if block_given? && message.nil?
      log('FATAL', message, writing_object)
    end

    def error(message = nil, writing_object = nil, &block)
      message = yield if block_given? && message.nil?
      log('ERROR', message, writing_object)
    end

    def warn(message = nil, writing_object = nil, &block)
      message = yield if block_given? && message.nil?
      log('WARN', message, writing_object)
    end

    def info(message = nil, writing_object = nil, &block)
      message = yield if block_given? && message.nil?
      log('INFO', message, writing_object)
    end

    def debug(message = nil, writing_object = nil, &block)
      message = yield if block_given? && message.nil?
      log('DEBUG', message, writing_object)
    end

    private

    def log(severity, message = nil, writing_object = nil)
      return if message.nil? || message.empty?
      save_to_graylog(severity, message, writing_object) if @notifier
    end

    def save_to_graylog(severity, message, writing_object)
      params = normalize_message(severity, message, writing_object)
      @notifier.notify!(params)
    end

    def normalize_message(severity, message, writing_object)
      if message.is_a?(Hash)
        raise(ArgumentError, 'short_message and full_message are required logger params.') unless message_hash_valid?(message)
        return message.merge(severity: severity)
      end

      short_message = writing_object.nil? ? "#{message[0...25]}..." : "#{writing_object.class.name}_#{writing_object.id}"
      { short_message: short_message, full_message: message, severity: severity }
    end

    def message_hash_valid?(message_hash)
      %i[short_message full_message].all? { |key| message_hash.key?(key) }
    end
  end
end
