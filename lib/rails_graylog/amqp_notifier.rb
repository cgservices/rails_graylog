require 'mq'

module RailsGraylog
  class AmqpNotifier
    attr_reader :queue, :channel, :host

    def initialize(channel: nil, queue_name: 'logging', host: nil, **queue_kwargs)
      @host = host || Socket.gethostname
      @channel = channel || Mq.channel
      raise 'No connection available' unless @channel
      @queue = channel.queue(queue_name, queue_kwargs)
    end

    def notify!(message)
      queue.publish(gelf_message.merge(message).to_json)
    end

    private

    def gelf_message
      { host: host, version: '1.1' }
    end
  end
end
