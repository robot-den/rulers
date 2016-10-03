class Object
	def self.const_missing(c)
		return nil if @calling_call_missing
		@calling_call_missing = true
		require Rulers.to_underscore(c.to_s)
    klass = Object.const_get(c)
		@calling_call_missing = false
		klass
  end
end
