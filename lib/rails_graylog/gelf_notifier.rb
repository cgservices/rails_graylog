require 'gelf'
require 'forwardable'

module RailsGraylog
  class GelfNotifier
    extend Forwardable

    def_delegator :@notifier, :notify!

    def initialize(notifier = nil)
      @notifier = notifier || gelf
    end

    private

    attr_accessor :notifier

    def gelf
      GELF::Notifier.new(
        ENV['GRAYLOG_HOST'],
        ENV['GRAYLOG_PORT'],
        'WAN',
        host: Socket.gethostname,
        facility: Rails.application.class.parent_name
      )
    end
  end
end
