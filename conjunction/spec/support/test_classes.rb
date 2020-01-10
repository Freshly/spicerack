# frozen_string_literal: true

require "active_model/naming"

# ================================= #
#             JUNCTIONS             #
# ================================= #

class ApplicationFleeb
  include Conjunction::Junction

  suffixed_with "Fleeb"
end

class ApplicationChumble
  include Conjunction::Junction

  prefixed_with "Chumble::"
end

class ApplicationFroodNoop
  include Conjunction::Junction

  prefixed_with "Frood"
  suffixed_with "Noop"
end

class ApplicationDingleBop
  include Conjunction::Junction

  class << self
    def junction_key
      :fully_custom
    end

    def prototype_name
      chomped_name = name.chomp("Fiddlesticks")
      chomped_name unless chomped_name == name
    end

    private

    def conjunction_name_for(other_prototype, other_prototype_name)
      "#{other_prototype.prototype_name || other_prototype_name}Fiddlesticks"
    end
  end
end

# ================================= #
#        CONJUNCTIONS: Fleeb        #
# ================================= #

module GalacticFederation
  class EarthlingFleeb < ApplicationFleeb; end
  class SatelliteFleeb < ApplicationFleeb; end
end

class PlanetaryAddressFleeb < ApplicationFleeb; end

class StarlightFleeb < ApplicationFleeb; end
class GenericFleeb < ApplicationFleeb; end

# ================================= #
#       CONJUNCTIONS: Chumble       #
# ================================= #

module Chumble
  module GalacticFederation
    class Earthling < ApplicationChumble; end
    class Satellite < ApplicationChumble; end
  end

  class Generic < ApplicationChumble; end

  class Starlight < ApplicationChumble; end
  class Martian < ApplicationChumble; end
  class Luna < ApplicationChumble; end
end

# ================================= #
#      CONJUNCTIONS: FroodNoop      #
# ================================= #

module FroodGalacticFederation
  class EarthlingNoop < ApplicationFroodNoop; end
end

class CommonFroodNoop < ApplicationFroodNoop; end

class FroodStarlightNoop < ApplicationFroodNoop; end
class FroodMartianNoop < ApplicationFroodNoop; end

# ================================= #
#      CONJUNCTIONS: DingleBop      #
# ================================= #

module GalacticFederation
  class SatelliteFiddlesticks < ApplicationDingleBop; end
end

class GenericDingleBop < ApplicationDingleBop; end
class MartianFiddlesticks < ApplicationDingleBop; end

# ================================= #
#               MODELS              #
# ================================= #

class ApplicationSchmodel
  extend ActiveModel::Naming

  include Conjunction::Conjunctive
end

module GalacticFederation
  class Earthling < ApplicationSchmodel; end
end

class Martian < ApplicationSchmodel; end

class PlanetaryAddress < ApplicationSchmodel
  conjoins Chumble::Generic
  conjoins CommonFroodNoop
end

# ================================= #
#               POROS               #
# ================================= #

class ApplicationPoro
  include Conjunction::Conjunctive
end

module GalacticFederation
  class Satellite < ApplicationPoro; end
end

class Starlight < ApplicationPoro; end
class HighFrequencyRadioBurst < ApplicationPoro
  conjoins GenericFleeb
  conjoins Chumble::Generic
  conjoins CommonFroodNoop
  conjoins GenericDingleBop
end

class Luna
  include Conjunction::Conjunctive

  conjoins GenericFleeb
end
