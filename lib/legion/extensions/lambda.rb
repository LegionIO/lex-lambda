# frozen_string_literal: true

require 'legion/extensions/lambda/version'
require 'legion/extensions/lambda/helpers/client'
require 'legion/extensions/lambda/runners/functions'
require 'legion/extensions/lambda/runners/management'
require 'legion/extensions/lambda/runners/layers'
require 'legion/extensions/lambda/client'

module Legion
  module Extensions
    module Lambda
      extend Legion::Extensions::Core if Legion::Extensions.const_defined? :Core
    end
  end
end
