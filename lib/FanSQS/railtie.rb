module FanSQS
  class Railtie < Rails::Railtie
    rake_tasks do
      load "tasks/FanSQS.rake"
    end
  end
end
