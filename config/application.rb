require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module GameCzas
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    
    # 日本時間に設定
    # https://qiita.com/shimadama/items/7e5c3d75c9a9f51abdd5を参照
    config.time_zone = 'Tokyo'
    config.active_record.default_timezone = :local
    
    # デフォルトを日本語に設定
    config.i18n.default_locale = :ja
    # 複数のロケールファイルが読み込まれるようにpathを通す記述
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]

    
    
    # 週の始まりの曜日の設定を日曜日に変える→カレンダーの曜日のスタートを日曜日に
    # https://railsdoc.com/page/config_beginning_of_weekを参照
    config.beginning_of_week = :sunday
  end
end
