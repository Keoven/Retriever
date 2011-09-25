module Retriever
# Instruction is used by retriever as an object that would
# store set attributes and options while specifying your
# targets in <tt>Retriever.catch!</tt>
#
class Instruction
  # Key used by instruction for storage manipulation.
  attr_accessor :key

  # Block executed to retrieve value to be cached.
  attr_accessor :block

  # Instantiate Instruction
  #
  # ==== Parameters
  #
  # * <tt>:key</tt> - Key used to store and retrieve value from cache.
  # * <tt>:options</tt> - Options defined in <tt>Retriever.catch!</tt>
  # * <tt>:block</tt> - Block is the <tt>Proc</tt> object to be executed.
  #   Resulting value would be the cached.
  #
  def initialize(key, options, block)
    @key   = key
    @block = block
    @validity = options[:validity] || 365.days
  end

  # Checks if value in storage is expired before trying to retrieve
  # a new value. Value in storage is returned if value is still valid.
  #
  # ==== Parameters
  #
  # * <tt>:storage</tt> - Instance of the storage handler.
  # * <tt>:block_parameters</tt> - Arguments sent to the block if value
  #   in storage is expired.
  #
  def execute(storage, block_parameters)
    if expired? then execute!(storage, block_parameters) else storage.get(key) end
  end

  # Cache the result of the block. Just like <tt>execute</tt> but does not
  # check cached value.
  #
  # ==== Parameters
  #
  # * <tt>:storage</tt> - Instance of the storage handler.
  # * <tt>:block_parameters</tt> - Arguments sent to the block if value
  #   in storage is expired.
  #
  def execute!(storage, block_parameters)
    @last_execution = Time.now
    storage.set(key, block.call(*block_parameters))
  end

private
  # Check if cached value is expired
  #
  def expired?
    return true unless @last_execution
    Time.now - @last_execution > @validity
  end
end
end
