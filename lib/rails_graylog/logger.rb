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
        json_message = message.to_json
        message[:full_message] = json_message unless message.key?(:full_message)
        message[:short_message] = generate_short_message(json_message, writing_object) unless message.key?(:short_message)
        return message.merge(severity: severity)
      end

      short_message = generate_short_message(message, writing_object)
      { short_message: short_message, full_message: message, severity: severity }
    end

    def generate_short_message(message, writing_object)
      writing_object.nil? ? "#{message[0...25]}..." : "#{writing_object.class.name}_#{writing_object.id}"
    end
  end
end
