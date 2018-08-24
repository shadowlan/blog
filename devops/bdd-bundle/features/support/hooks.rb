require_relative 'aruba'
# hooks for each command
Aruba.configure do |config|
    config.before :command do |cmd|
      puts "About to run '#{cmd}'"
      puts "before the run of `#{cmd.commandline}`"
    end
end
#set option during runtime
Before '@slow-command' do
    aruba.config.exit_timeout = 5
end
