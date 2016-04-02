namespace :db do
  namespace :seed do
    task :all => :environment do
      Dir[File.join(Rails.root, 'db', 'seeds', '*.rb')].each do |filename|
        load(filename) if File.exist?(filename)
      end
    end

    Dir[File.join(Rails.root, 'db', 'seeds', '*.rb')].each do |filename|
      task File.basename(filename, '.rb').intern => :environment do
        load(filename) if File.exist?(filename)
      end
    end
  end
end