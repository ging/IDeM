namespace :db do

  namespace :populate do
    
    # How to use:
    # bundle exec rake db:populate:start
    task :start, [:arg] => :environment do |t, args|
      puts "Populating database"
      t1 = Time.now
      args.with_defaults(:arg => "Default arg value")

      #Clean
      Rake::Task["db:populate:clean"].invoke

      #Populate here

      #Populate Users
      user = User.new
      user.email = "demo@idem.com"
      user.password = "demonstration"
      user.name = "Demo"
      user.ui_language = I18n.default_locale
      user.save!
      puts "User '" + user.name + "' created with email '" + user.email + "' and password 'demonstration'"

      puts "Task finished"
      t2 = Time.now - t1
      puts "Elapsed time:" + t2.to_s
    end

    # How to use:
    # bundle exec rake db:populate:clean
    task :clean => :environment do |t, args|
      puts "Removing all records from database"
      User.destroy_all
    end

  end

end

