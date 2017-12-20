module RailsGraylog
  class AmqpNotifier
    attr_reader :exchange

    def initialize(channel:, exchange_name: 'logging', **exchange_args)
      raise 'No connection available' unless channel
      @exchange = channel.exchange(exchange_name, exchange_args)
    end

    def notify!(message, routing_key = 'log_write')
      exchange.publish(gelf_message.merge(message).to_json, routing_key: routing_key)
    end

    private

    def gelf_message
      { host: Socket.gethostname, version: '1.1' }
    end
  end
end
