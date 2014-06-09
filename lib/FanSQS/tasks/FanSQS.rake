namespace :FanSQS do
  desc "FanSQS constantly polls for new job from all queues in SQS and execute jobs"
  task :start_polling => :environment do
    puts "FanSQS polling starts ..."
    FanSQS::Poller.start
  end
end
