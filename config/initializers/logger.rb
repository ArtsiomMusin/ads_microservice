Application.configure do |app|
  logger = Ougai::Logger.new(
    app.root.concat('/', Settings.logger.path),
    level: Settings.logger.level
  )

  logger.before_log = lambda do |data|
    data[:service] = { name: Settings.app.name },
    data[:request_id] = Thread.current[:request_id]
  end

  app.set :logger, logger
end

Application.configure :development do |app|
  logger = Ougai::Logger.new(STDOUT)
  logger.formatter = Ougai::Formatters::Readable.new

  logger.before_log = lambda do |data|
    data[:service] = { name: Settings.app.name }
  end

  app.set :logger, logger
end
