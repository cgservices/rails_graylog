module RailsGraylog
  class Logger
    def initialize(notifier = nil)
      @notifier = notifier || GelfNotifier.new
    end

    def fatal(message = nil)
      message = yield if block_given? && message.nil?
      log('FATAL', message)
    end

    def error(message = nil)
      message = yield if block_given? && message.nil?
      log('ERROR', message)
    end

    def warn(message = nil)
      message = yield if block_given? && message.nil?
      log('WARN', message)
    end

    def info(message = nil)
      message = yield if block_given? && message.nil?
      log('INFO', message)
    end

    def debug(message = nil)
      message = yield if block_given? && message.nil?
      log('DEBUG', message)
    end

    private

    def log(severity, message = nil)
      return if message.nil? || message.empty?
      notify_message(severity, message)
    end

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
