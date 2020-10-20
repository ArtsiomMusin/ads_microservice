module ApplicationLoader
  extend self

  def load_app!
    require_app
    init_app
    load_debugger
  end

  private

  def require_app
    require_file 'config/initializers/config'
    require_dir 'app/helpers'
    require_file 'config/application'
    require_file 'app/services/basic_service'
    require_dir 'app'
  end

  def init_app
    require_dir 'config/initializers'
  end

  def load_hooks
    UserSession.plugin :uuid, field: :uuid
    User.plugin :association_dependencies
    User.add_association_dependencies sessions: :destroy
  end

  def load_debugger
    return unless %w[test development].include?(ENV['RACK_ENV'])

    require 'byebug'
  end

  def require_file(path)
    require File.join(root, path)
  end

  def require_dir(path)
    path = File.join(root, path)
    Dir["#{path}/**/*.rb"].each {|file| require file}
  end

  def root
    File.expand_path('..', __dir__)
  end
end
