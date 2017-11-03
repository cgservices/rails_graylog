module RailsGraylog
  class AmqpNotifier
    attr_reader :queue, :exception_handler

    def initialize(channel:, queue_name: 'logging', exception_handler:, **queue_args)
      @exception_handler = exception_handler
      raise 'No connection available' unless channel
      @queue = channel.queue(queue_name, queue_args)
    end

    def notify!(message)
      queue.publish(gelf_message.merge(message).to_json)
    rescue => e
      exception_handler.call e
    end

    private

    def gelf_message
      { host: Socket.gethostname, version: '1.1' }
    end
  end
end
