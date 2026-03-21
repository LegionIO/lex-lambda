# frozen_string_literal: true

require_relative 'helpers/client'
require_relative 'runners/functions'
require_relative 'runners/management'
require_relative 'runners/layers'

module Legion
  module Extensions
    module Lambda
      class Client
        include Helpers::Client
        include Runners::Functions
        include Runners::Management
        include Runners::Layers

        attr_reader :opts

        def initialize(region: 'us-east-1', access_key_id: nil, secret_access_key: nil, **extra)
          @opts = { region: region, access_key_id: access_key_id, secret_access_key: secret_access_key,
                    **extra }.compact
        end

        def lambda_client(**override)
          super(**@opts, **override)
        end

        def settings
          { options: @opts }
        end
      end
    end
  end
end
