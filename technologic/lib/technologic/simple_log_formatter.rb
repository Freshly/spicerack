# frozen_string_literal: true

class SimpleLogFormatter < ::Logger::Formatter
  FORMAT = "\n[%s] %5s -- %s\n"

  def initialize
    @datetime_format = "%H:%M:%S:%3N"
  end

  def call(severity, time, _, msg)
    FORMAT % [ format_datetime(time), severity, msg2str(msg) ]
  end

  private

  def msg2str(msg)
    case msg
    when ::String
      msg
    when ::Hash
      msg.map { |k, v| "\n :#{k} => #{v}" }.join
    when ::Exception
      "#{msg.message} (#{msg.class})\n#{(msg.backtrace || []).join("\n")}"
    else
      msg.inspect
    end
  end
end
