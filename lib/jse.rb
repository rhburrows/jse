$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__))

require 'jse/stream'
require 'jse/filter'
require 'jse/regexp_filter'
require 'jse/subset_transform'
require 'jse/to_json_transform'
require 'jse/field_value_transform'

module JSE
end
