namespace :db do

  namespace :populate do
    
    # How to use:
    # bundle exec rake db:populate:development
    task :development, [:arg] => :environment do |t, args|
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

      #Fake data to validate user
      user.uid = 9999
      user.provider = "loop"
      loop_data = generate_fake_loop_data({:name => "Demo"})
      user.loop_data = loop_data.to_json
      user.save!
      puts "User '" + user.name + "' created with email '" + user.email + "' and password 'demonstration'"

      puts "Task finished. Sign in at https://idem-example.com/users/sign_in"
      t2 = Time.now - t1
      puts "Elapsed time:" + t2.to_s
    end

    def generate_fake_loop_data(options={})
      data = {}
      data["name"] = options[:name] || Faker::Name.name
      data["loop_id"] = generate_random_id
      data["loop_profile_url"] = "https://developers-registration.frontiersin.org"

      #Add publications
      data["publications"] = {
        "@odata.context"=>"https://publications-api.frontiersin.org:4438/v1/$metadata#Publications",
        "value" => []
      }
      5.times do |i|
        publication = {
          "id" => generate_random_id,
          "doi" => "",
          "title" => Faker::Book.title,
          "abstract" => Faker::Lorem.sentence(20, true, 10),
          "publicationDate" =>"2015-11-01",
          "keywords" => [],
          "urls" => [],
          "authors" => [{"fullName"=>data["name"], "userIds"=>[data["loop_id"]], "affiliations"=>[]}],
          "journal" => {"name"=>Faker::Book.publisher, "issn"=>"", "volume"=>"", "pages"=>"", "issue"=>""},
          "loopUrl" => "http://frontiersin.org/publications/" + generate_random_id(8)
        }
        data["publications"]["value"].push(publication)
      end

      data
    end

    def generate_random_id(length=9)
      id = ""
      length.times do |i|
        id = id + rand(10).to_s
      end
      id
    end

    task :install, [:arg] => :environment do |t, args|
      # Install database entities for a production instance
    end

    task :publications, [:arg] => :environment do |t, args|

    end

    # How to use:
    # bundle exec rake db:populate:clean
    task :clean => :environment do |t, args|
      puts "Removing all records from database"
      User.destroy_all
      Publication.destroy_all
      Presentation.destroy_all
      # Webinar.destroy_all
      Pdfp.destroy_all
    end

  end

end

