module Retriever
# Configuration Namespace
module Config
class << self
  # Boolean value to indicate whether or not key used for cache is encrypted or not.
  attr_reader :encrypt

  # Set encryption to boolean specified
  #
  # ==== Examples
  #
  #   Retriever.config.encrypt = true
  #   Retriever.config.encrypt = false
  #
  def encrypt=(boolean)
    require 'digest/sha1' if boolean
    @encrypt = boolean
  end

  # Set storage handler to be used by retriever.
  # This is a requirement to be set so that you
  # can use retriever.
  #
  # ==== Storage Handlers (Built-in)
  #
  # * <tt>:ephemeral</tt> - Uses a ruby hash to store cache.
  # * <tt>:redis</tt> - Use redis. (Requires <tt>redis</tt> gem.)
  #
  # ==== Custom Storage Handlers
  # You can supply your own storage handler. In the class you supply,
  # you need to specify the following methods:
  #
  # * <tt>set(key, value)</tt> - Used to set value in the cache store.
  # * <tt>get(key)</tt> - Used to retrieve value from cache store.
  # * <tt>delete(key)</tt> - Used to delete a record from cache store.
  #
  # ==== Examples
  #
  #   Retriever.config.storage(:ephemeral) # Set storage to memory.
  #   Retriever.config.storage(:redis)  # Set storage to redis.
  #
  #   class CustomStorageHandler
  #     def set(key, value)
  #       ...
  #     end
  #
  #     def get(key)
  #       ...
  #     end
  #
  #     def delete(key)
  #       ...
  #     end
  #   end
  #
  #   Retriever.config.storage(CustomStorageHandler) # Set storage to a custom storage.
  #
  def storage(type)
    if type.is_a? Class
      ::Retriever.storage = type.new if type.is_a?(Class)
    else
      case type
      when :ephemeral
        require File.join(File.dirname(__FILE__), 'storage', 'ephemeral')
        ::Retriever.storage = Retriever::Storage::Ephemeral.new
      when :redis
        require File.join(File.dirname(__FILE__), 'storage', 'redis')
        ::Retriever.storage = Retriever::Storage::Redis.new
      end
    end
  end
end
end
end
