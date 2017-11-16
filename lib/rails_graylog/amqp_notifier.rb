module RailsGraylog
  class AmqpNotifier
    attr_reader :exchange, :exception_handler

    def initialize(channel:, exchange_name: 'logging', exception_handler:, **exchange_args)
      @exception_handler = exception_handler
      raise 'No connection available' unless channel
      @exchange = channel.exchange(exchange_name, exchange_args)
    end

    def notify!(message, routing_key = 'log_write')
      exchange.publish(gelf_message.merge(message).to_json, routing_key: routing_key)
    rescue => e
      exception_handler.call e
    end

    private

    def gelf_message
      { host: Socket.gethostname, version: '1.1' }
    end
  end
end
