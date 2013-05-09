class Container
  attr_reader :registry

  def initialize
    @registry = {}
  end

  def register(key, klass, scope = :per_resolution)
    @registry[key] = { 
      :klass => klass, 
      :scope => scope 
    }
  end

  def resolve(key)
    registration_metadata = @registry[key]
    raise NotRegisteredError.new key if registration_metadata == nil

    klass = registration_metadata[:klass] 
    scope = registration_metadata[:scope]

    if scope == :singleton
      if registration_metadata.has_key?(:instance)
        return registration_metadata[:instance]
      else
        registration_metadata[:instance] = hydrate(klass)
        return registration_metadata[:instance]
      end
    end

    if scope == :singleton_per_thread
      if Thread.current[:klass]
        return Thread.current[:klass]
      else
        Thread.current[:klass] = hydrate(klass)
        return Thread.current[:klass]
      end
    end

    hydrate(klass)
  end

  private

  def hydrate(klass)
    constructor_params = klass.instance_method(:initialize).parameters
    required_dependancies = constructor_params.select{|p| p.first == :req}
                                              .map{|p| resolve(p.last)}
    klass.new(*required_dependancies)
  end

end

class NotRegisteredError < StandardError  
  def initialize symbol
    @symbol = symbol
  end
  
  def to_s
    "Could not find registration for #{@symbol}."
  end
end  
