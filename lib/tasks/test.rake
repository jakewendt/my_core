namespace :test do

#	rake test:match pattern=boards_c

  Rake::TestTask.new(:match => "db:test:prepare") do |t|
    t.libs << "test"
    t.pattern = "test/**/*#{ENV['pattern']}*test.rb"
    t.verbose = true
  end
  Rake::Task['test:match'].comment = "Run the tests that match in test/"

end
