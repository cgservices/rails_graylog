module RailsGraylog
  class AmqpNotifier
    attr_reader :queue

    def initialize(channel:, queue_name: 'logging', **queue_args)
      raise 'No connection available' unless channel
      @queue = channel.queue(queue_name, queue_args)
    end

    def notify!(message)
      queue.publish(gelf_message.merge(message).to_json)
    end

    private

    def gelf_message
      { host: Socket.gethostname, version: '1.1' }
    end
  end
end
