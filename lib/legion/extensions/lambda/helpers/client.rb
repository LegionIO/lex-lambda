# frozen_string_literal: true

require 'aws-sdk-lambda'

module Legion
  module Extensions
    module Lambda
      module Helpers
        module Client
          def lambda_client(region: 'us-east-1', access_key_id: nil, secret_access_key: nil, **_opts)
            config = { region: region }
            config[:access_key_id] = access_key_id if access_key_id
            config[:secret_access_key] = secret_access_key if secret_access_key
            Aws::Lambda::Client.new(**config)
          end
        end
      end
    end
  end
end
