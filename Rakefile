desc 'Runs the tests after each change'
task 'autotest' do
  system "/usr/bin/kicker --no-growl -e 'ruby test/proxapi_test.rb' ."
end

task 'default' do
  ruby "test/proxapi_test.rb"
end