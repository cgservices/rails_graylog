module RailsGraylog
  class Logger # < ::Logger
    def fatal(message = nil, writing_object = nil)
      log(message, writing_object)
    end

    def error(message = nil, writing_object = nil)
      log(message, writing_object)
    end

    def warn(message = nil, writing_object = nil)
      log(message, writing_object)
    end

    def info(message = nil, writing_object = nil)
      log(message, writing_object)
    end

    def debug(message = nil, writing_object = nil)
      log(message, writing_object)
    end

    private

    def log(message, writing_object)
      return if message.nil? || message.empty?
      save_to_graylog(message, writing_object) if Rails.configuration.graylog_notifier
    end

    def save_to_graylog(message, writing_object)
      params = format_message(message, writing_object)
      Rails.configuration.graylog_notifier.notify!(params)
    end

    def format_message(message, writing_object)
      return message if message.is_a?(Hash) && %i[short_message full_message].all? { |key| message.key?(key) }
      short_message = writing_object.nil? ? "#{message[0...25]}..." : "#{writing_object.class.name}_#{writing_object.id}"
      { short_message: short_message, full_message: message }
    end
  end
end
