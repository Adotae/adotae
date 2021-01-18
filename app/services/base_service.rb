class BaseService
  include ApiErrors

  def self.call(...)
    new(...).call
  end
end
