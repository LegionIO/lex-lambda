# frozen_string_literal: true

module Legion
  module Extensions
    module Lambda
      module Runners
        module Management
          def create_function(function_name:, runtime:, handler:, role:, code:, **) # rubocop:disable Metrics/ParameterLists
            resp = lambda_client(**).create_function(
              function_name: function_name,
              runtime:       runtime,
              handler:       handler,
              role:          role,
              code:          code
            )
            resp.to_h
          end

          def update_function_code(function_name:, zip_file: nil, s3_bucket: nil, s3_key: nil, **)
            params = { function_name: function_name }
            params[:zip_file] = zip_file if zip_file
            params[:s3_bucket] = s3_bucket if s3_bucket
            params[:s3_key] = s3_key if s3_key
            resp = lambda_client(**).update_function_code(**params)
            resp.to_h
          end

          def update_function_configuration(function_name:, **opts)
            conn_opts = opts.slice(:region, :access_key_id, :secret_access_key)
            config_opts = opts.except(:region, :access_key_id, :secret_access_key)
            resp = lambda_client(**conn_opts).update_function_configuration(
              function_name: function_name,
              **config_opts
            )
            resp.to_h
          end

          def delete_function(function_name:, **)
            lambda_client(**).delete_function(function_name: function_name)
            { deleted: true, function_name: function_name }
          end
        end
      end
    end
  end
end
