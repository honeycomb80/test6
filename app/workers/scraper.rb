# require File.dirname(__FILE__) + '/../../lib/tasks/set_dates.rake'
# require File.dirname(__FILE__) + '/../../lib/tasks/tc_scrape.rake'
# require 'rake'

# Rake::Task.clear # necessary to avoid tasks being loaded several times in dev mode
# Test6::Application.load_tasks

# class ScraperWorker

#   module ScrapeTechCrunch
#     @queue = :send_this_email

#     def perform
#       rake :set_dates
#       rake :tc_scrape
#     end
#   end
# end

