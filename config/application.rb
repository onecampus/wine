require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Wine
  class Application < Rails::Application
    config.before_initialize do
      ENV['APP_ID'] = 'wxa2bbd3b7a22039df'
      ENV['APP_SECRET'] = '724bbaea1bce4c09865c2c47acbf450d'
      ENV['APP_JS_URL'] = 'zhonglian.thecampus.cc'
    end

    config.generators do |g|
      g.orm             :active_record
      g.template_engine :erb
      # g.test_framework  :test_unit, fixture: false
      g.test_framework  nil
      g.stylesheets     false
      g.javascripts     false
      #g.jbuilder        false
      g.helper          false
    end

    config.i18n.available_locales = [:'zh-CN', :zh]
    config.i18n.default_locale = :'zh-CN'

    config.active_record.default_timezone = :local
    config.time_zone = 'Beijing'
    config.encoding = 'utf-8'

    config.middleware.insert_after ActionDispatch::ParamsParser, ActionDispatch::XmlParamsParser
  end
end
