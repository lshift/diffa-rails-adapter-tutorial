require 'digest'

module Diffa
  class TokenGenerator
    def self.generate
      return Digest::SHA1.hexdigest(rand(36**8).to_s(36))
    end
  end
end

