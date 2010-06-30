LOG_FILE_NAME = 'log.txt'

Given /^I have a log file containing:$/ do |string|
  File.open(LOG_FILE_NAME, 'w') do |f|
    f.write(string)
  end
end

When /^I run "jse([^\"]*)" on my log file$/ do |opts|
  JSE::CLI.execute(output, opts.split(' ') + [LOG_FILE_NAME])
end

Then /^I should see:$/ do |text|
  text.split("\n").each do |line|
    output.should include(line)
  end
end

class Output
  def messages
    @messages ||= []
  end

  def puts(message)
    messages << message.chomp
  end

  def include?(message)
    messages.include?(message.chomp)
  end
end

def executable_path
  File.expand_path(File.join(__FILE__, '..', '..', 'bin', 'jse'))
end

def output
  @output ||= Output.new
end
