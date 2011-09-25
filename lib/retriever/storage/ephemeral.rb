# Storage handler namespace
module Retriever::Storage
# Storage handler for a Hash Backend
class Ephemeral
  # Instance of Hash
  attr_reader :storage

  # Instantiate hash object as storage of cache.
  #
  def initialize
    @storage = Hash.new
  end

  # Set record in hash.
  #
  def set(key, value)
    storage[key] = value
  end

  # Get record from hash.
  #
  def get(key)
    storage[key]
  end

  # Delete record in hash.
  #
  def delete(key)
    storage.delete(key)
  end
end
end
