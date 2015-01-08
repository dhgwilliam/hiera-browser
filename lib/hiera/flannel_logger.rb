require 'hiera_browser/mq'

class Hiera::Flannel_logger
  def self.warn(msg)
    p "WARN: #{msg}"
  end

  def self.debug(msg)
    matches = msg.match(/^Found ([a-z_:]+) in (.*)$/)
    $mq.push(matches[1], matches[2]) if matches
  end
end
