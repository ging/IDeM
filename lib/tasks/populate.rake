namespace :db do
  namespace :populate do

    desc "Populate initial data"
    namespace :create do
			#Usage
      #Development:   bundle exec rake db:populate:create:licenses
      #In production: bundle exec rake db:populate:create:licenses RAILS_ENV=production
      desc "Create Licenses"
      task :licenses => :environment do
          licenseKeys = []
          licenseKeys.push("public")
          licenseKeys.push("cc-by")
          licenseKeys.push("cc-by-sa")
          licenseKeys.push("cc-by-nd")
          licenseKeys.push("cc-by-nc")
          licenseKeys.push("cc-by-nc-sa")
          licenseKeys.push("cc-by-nc-nd")
          licenseKeys.push("other")
          licenseKeys.push("private") #none (All rights reserved)

          licenseKeys.each do |key|
            if License.find_by_key(key).nil?
              puts "Creating license: " + key
              l = License.new
              l.key = key
              l.save!
            end
          end
      end
    end
  end
end