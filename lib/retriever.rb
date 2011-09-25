require File.join('retriever', 'version')
require File.join('retriever', 'config')
require File.join('retriever', 'instruction')

# Main Retriever Entry Point
module Retriever
class << self
  # Instance of storage handler.
  attr_accessor :storage

  # Array of instructions.
  attr_accessor :instructions

  # Setup targets for retriever to cache.
  #
  # ==== Example
  #
  #   Retriever.catch! do
  #     target :bone do
  #       'wishbone'
  #     end
  #   end
  #
  def catch!(&block)
    @instance_timestamp = Time.now
    @instructions       = Hash.new
    self.instance_eval &block
  end

  # Setup a new <tt>target</tt> for retriever to catch.
  #
  # ==== Parameters
  #
  # * <tt>:name</tt> - Identifier used to call the block whenever you call
  #   <tt>fetch</tt> or <tt>fetch!</tt>.
  # * <tt>:options</tt> - Options that modify basic instruction of simply
  #   caching the result of the block.
  # * <tt>:block</tt> - The block to be executed with it's result being cached.
  #
  # ==== Options
  #
  # * <tt>:validity</tt> - Sets length of validity of a certain cache.
  #   After the cache expires, retriever simply executes the block again.
  #
  #     target :bone, :validity => 10.minutes
  #
  # ==== Example
  #
  #   Retriever.catch! do
  #     @counter = 0
  #     target :bone, :validity => 10.minutes do
  #       @counter += 1
  #     end
  #   end
  #
  #   Retriever.fetch(:bone) # => 1
  #   # After 10 minutes
  #   Retreiver.fetch(:bone) # => 2
  #
  def target(name, options = {}, &block)
    key = keyify(name)
    instructions[key] = Instruction.new(key, options, block)
  end

  # Fetch data based upon the execution result of the corresponding
  # instruction identified by the <tt>target_name</tt>. If data cached
  # is still valid, that data would be returned.
  #
  # ==== Parameters
  #
  # * <tt>:target_name</tt> - The name used to identify the instruction.
  # * <tt>:*block_parameters</tt> - Parameters passed on to the block
  #   that is part of the instruction.
  #
  # ==== Examples
  #
  #   Retriever.fetch(:bone)
  #
  def fetch(target_name, *block_parameters)
    key = keyify(target_name)
    instruction = instructions[key]
    instruction.execute(storage, block_parameters)
  end

  # Fetch data based upon the execution result of the corresponding
  # instruction identified by the <tt>target_name</tt>.
  #
  # ==== Parameters
  #
  # * <tt>:target_name</tt> - The name used to identify the instruction.
  # * <tt>:*block_parameters</tt> - Parameters passed on to the block
  #   that is part of the instruction.
  #
  # ==== Examples
  #
  #   Retriever.fetch(:bone)
  #
  def fetch!(target_name, *block_parameters)
    key = keyify(target_name)
    instruction = instructions[key]
    instruction.execute!(storage, block_parameters)
  end

  # Check if keys used for the cache store is encrypted or not encrypted.
  # Basis of key is namespaced to retriever as well as timestamped.
  # (Timestamp comes from the instance start.)
  #
  def encrypted?
    config.encrypt || false
  end

  # Returns config namespace.
  #
  def config
    Config
  end

  # Delete all cache. Automatically run on instance process termination.
  #
  def clean!
    return unless instructions
    instructions.keys.each do |key|
      storage.delete(key)
    end
  end

private
  # Namespaces <tt>target_name</tt> to retriever as well as timestamped
  # with the instance start timestamp. This key is also encrypted using
  # SHA1 if set to be encrypted.
  #
  # ==== Examples
  #
  #   To set encryption:
  #   Retriever.config.encrypt = true  # Set encryption to true
  #   Retriever.config.encrypt = false # Set encryption to false
  #
  def keyify(target_name)
    key = "Retriever::#{target_name}::#{@instance_timestamp}"
    key = Digest::SHA1.hexdigest(key) if encrypted?
    return key
  end

end
end

at_exit do
  Retriever.clean!
end
