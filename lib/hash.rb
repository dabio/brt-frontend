# encoding: utf-8

class Hash
  # Return a hash that includes everything but the given keys. This is useful for
  # limiting a set of parameters to everything but a few known toggles:
  #
  #   @person.update_attributes(params[:person].except(:admin))
  #
  # If the receiver responds to +convert_key+, the method is called on each of the
  # arguments. This allows +except+ to play nice with hashes with indifferent access
  # for instance:
  #
  #   {:a => 1}.with_indifferent_access.except(:a)  # => {}
  #   {:a => 1}.with_indifferent_access.except("a") # => {}
  #
  def except(*keys)
    dup.except!(*keys)
  end

  # Replaces the hash without the given keys
  def except!(*keys)
    keys.each { |key| delete(key) }
    self
  end


  # Merges the caller into +other_hash+. For example,
  #
  #   options = options.reverse_merge(:size => 25, :velocity => 10)
  #
  # is equivalent to
  #
  #   options = {:size => 25, :velocity => 10}.merge(options)
  #
  # This is particularly useful for initializing an options hash
  # with default values.
  def reverse_merge(other_hash)
    other_hash.merge(self)
  end

  # Destructive +reverse_merge+
  def reverse_merge!(other_hash)
    # right wins if there is no left
    merge!(other_hash){ |key, left, right| left }
  end
end
