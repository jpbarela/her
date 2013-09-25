module Her
  class Collection < ::Array
    attr_reader :metadata, :errors, :response_code

    # @private
    def initialize(items=[], metadata={}, errors={}, response_code=200)
      super(items)
      @metadata = metadata
      @errors = errors
      @response_code = response_code
    end
  end
end
