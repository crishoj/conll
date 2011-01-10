
module Conll
  module Version
    MAJOR = 0
    MINOR = 2
    PATCH = 0
    BUILD = nil

    STRING = [MAJOR, MINOR, PATCH, BUILD].compact.join('.')  
  end
  VERSION = Version::STRING
end
