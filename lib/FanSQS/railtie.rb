module FanSQS
  class Railtie < Rails::Railtie
    rake_tasks do
      load File.expand_path(File.dirname(__FILE__) + "/tasks/FanSQS.rake")
    end
  end
end
