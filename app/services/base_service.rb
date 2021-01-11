class BaseService
  include ApiErrors

  def self.call(*args, &block)
    new(*args, &block).call
  end
end
