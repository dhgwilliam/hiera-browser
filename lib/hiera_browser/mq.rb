class MQ
  attr_reader :queue

  def initialize
    @queue = {}
  end

  def topics
    @queue.keys
  end

  def push(*args)
    topic = args[0] || 'default'
    msg   = args[1] || 'something broke'
    @queue[topic] ? @queue[topic] << msg : @queue[topic] = [ msg ]
  end

  def pop(topic)
    @queue.delete(topic).uniq
  end

  def write
    file = File.open('./queue.log', 'w')
    @queue.each do |topic, messages|
      messages.each {|msg| file << "#{topic} found in #{msg}\n" } 
    end
    file.close
  end

  def dump
    write
    @queue = {}
  end
end

$mq = MQ.new
