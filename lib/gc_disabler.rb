class GCDisabler
  def initialize(app)
    @app = app
    Rails.logger.info 'Initialize GC disabler'
  end

  def call(env)
    Rails.logger.info 'START GCDisabler call(env)'
    GC.start
    GC.disable
    response = @app.call(env)
    GC.enable
    Rails.logger.info 'END GCDisabler call(env)'
    response
  end
end