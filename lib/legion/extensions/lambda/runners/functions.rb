# frozen_string_literal: true

require 'json'

module Legion
  module Extensions
    module Lambda
      module Runners
        module Functions
          def list_functions(**)
            resp = lambda_client(**).list_functions
            { functions: resp.functions.map { |f| { name: f.function_name, runtime: f.runtime, arn: f.function_arn } } }
          end

          def get_function(function_name:, **)
            resp = lambda_client(**).get_function(function_name: function_name)
            resp.configuration.to_h
          end

          def invoke_function(function_name:, payload: nil, invocation_type: 'RequestResponse', **)
            params = { function_name: function_name, invocation_type: invocation_type }
            params[:payload] = payload.is_a?(Hash) ? ::JSON.dump(payload) : payload if payload
            resp = lambda_client(**).invoke(**params)
            body = resp.payload&.string
            parsed = begin
              ::JSON.parse(body) if body
            rescue ::JSON::ParserError
              body
            end
            { status_code: resp.status_code, payload: parsed, function_error: resp.function_error }
          end

          def invoke_async(function_name:, payload: nil, **)
            params = { function_name: function_name, invocation_type: 'Event' }
            params[:payload] = payload.is_a?(Hash) ? ::JSON.dump(payload) : payload if payload
            resp = lambda_client(**).invoke(**params)
            { status_code: resp.status_code, function_name: function_name, async: true }
          end
        end
      end
    end
  end
end
