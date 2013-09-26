module Her
  class Collection < ::Array
    attr_reader :metadata, :response_errors, :response_code

    # @private
    def initialize(items=[], metadata={}, errors={}, response_code=200)
      super(items)
      @metadata = metadata
      @response_errors = errors
      @response_code = response_code
    end
  end
end
