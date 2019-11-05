# frozen_string_literal: true

require "active_model/naming"

class ApplicationPoro
  include Conjunction::Conjunctive
end

module GalacticFederation
  class Satellite < ApplicationPoro; end
end

class Starlight < ApplicationPoro; end
class HighFrequencyRadioBurst < ApplicationPoro
  conjoins GenericFleeb
end

class Luna
  include Conjunction::Conjunctive

  conjoins GenericFleeb
end
