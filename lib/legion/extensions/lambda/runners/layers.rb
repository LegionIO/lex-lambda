# frozen_string_literal: true

module Legion
  module Extensions
    module Lambda
      module Runners
        module Layers
          def list_layers(**)
            resp = lambda_client(**).list_layers
            { layers: resp.layers.map { |l| { name: l.layer_name, arn: l.layer_arn } } }
          end

          def get_layer_version(layer_name:, version_number:, **)
            resp = lambda_client(**).get_layer_version(layer_name: layer_name, version_number: version_number)
            resp.to_h
          end

          def publish_layer_version(layer_name:, content:, compatible_runtimes: [], **)
            params = { layer_name: layer_name, content: content }
            params[:compatible_runtimes] = compatible_runtimes unless compatible_runtimes.empty?
            resp = lambda_client(**).publish_layer_version(**params)
            resp.to_h
          end
        end
      end
    end
  end
end
