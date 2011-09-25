require 'redis'
require 'json'

module Retriever::Storage
# Storage handler for a Redis Backend
class Redis
  # Instance of Redis
  attr_reader :storage

  # Instantiate Redis Connection (Default Settings Used)
  #
  def initialize
    @storage = ::Redis.new
  end

  # Set record in storage.
  # Serializes value to JSON if applicable.
  #
  def set(key, value)
    value = serialize(value)
    storage.set(key, value)
    JSON.parse(value) rescue value
  end

  # Get record from storage.
  # Deserialize value from JSON if applicable.
  #
  def get(key)
    value = storage.get(key)
    JSON.parse(value) rescue value
  end

  # Delete record from storage.
  #
  def delete(key)
    storage.del key
  end

private
  # Serialize value by converting it to JSON if possible.
  #
  def serialize(value)
    case value.class.to_s
    when 'String' then value
    else
      value.to_json rescue value.to_s
    end
  end

end
end
