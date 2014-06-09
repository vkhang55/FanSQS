namespace :FanSQS do
  task :start_polling => :environment do
    FanSQS::Poller.start
  end
end
