# encoding: utf-8

namespace :fix do

  # Usage
  # Development: bundle exec rake fix:something
  # Production: bundle exec rake fix:something RAILS_ENV=production
  #
  task :something => :environment do
    printTitle("Task Started")
    # Write fix here...
    printTitle("Task Finished")
  end



  ####################
  # Fix Utils
  ####################

  def printTitle(title)
    unless title.nil?
      puts "#####################################"
      puts title
      puts "#####################################"
    end
  end

  def printSeparator
    puts ""
    puts "--------------------------------------------------------------"
    puts ""
  end

end

