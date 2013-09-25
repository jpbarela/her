module Her
  module Middleware
    # This middleware treat the received first-level JSON structure as the resource data.
    class FirstLevelParseJSONJsonapi < ParseJSON
      # Parse the response body
      #
      # @param [String] body The response body
      # @return [Mixed] the parsed response
      # @private
      def parse(body, status)
        json = parse_json(body)
        errors = json.delete(:errors) || {}
        metadata = json.delete(:meta) || {}
        {
          :data => json,
          :errors => errors,
          :metadata => metadata,
          :response_code => status
        }
      end

      # This method is triggered when the response has been received. It modifies
      # the value of `env[:body]`.
      #
      # @param [Hash] env The response environment
      # @private
      def on_complete(env)
        env[:body] = case env[:status]
        when 204
          parse('{}', env[:status])
        else
          parse(env[:body], env[:status])
        end
      end
    end
  end
end
