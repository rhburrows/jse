$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__))

require 'jse/stream'
require 'jse/filter'
require 'jse/regexp_filter'

module JSE
end
