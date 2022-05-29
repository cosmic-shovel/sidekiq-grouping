module Sidekiq
  module Grouping
    class Railtie < ::Rails::Railtie
      config.after_initialize do
        Sidekiq.configure_client do |config|
          config.client_middleware do |chain|
            chain.add Sidekiq::Grouping::Middleware
          end
        end
        
        Sidekiq.configure_server do |config|
          config.client_middleware do |chain|
            chain.add Sidekiq::Grouping::Middleware
          end
        
          if Sidekiq.options[:lifecycle_events].key?(:leader)
            config.on(:leader) do
              Sidekiq::Grouping.start!
            end
          else
            Sidekiq::Grouping.start! if Sidekiq.server?
          end
        end
      end
    end
  end
end
