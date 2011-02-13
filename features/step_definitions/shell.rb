When 'I run the rake task "$task_name"' do |task_name|
  Dir.chdir('test_project') do
    system("rake #{task_name}")
  end
end

When 'I generate "$generator_with_args"' do |generator_with_args|
  Dir.chdir('test_project') do
    system("rails generate #{generator_with_args}")
  end
end

When 'I create a file named "$filename" with:' do |filename, content|
  File.open("test_project/#{filename}", "w") do |file|
    file.write(content)
  end
end

Then 'I see a successful response in the shell' do
  $?.to_i.should == 0
end

When 'I drop and create the required databases' do
  Dir.chdir('test_project') do
    system("rake db:drop RAILS_ENV=test")
    system("rake db:drop")
    system("rake db:create RAILS_ENV=test")
    system("rake db:create")
  end
end
