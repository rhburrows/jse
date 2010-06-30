LOG_FILE_NAME = 'log.txt'

Given /^I have a log file containing:$/ do |string|
  File.open(LOG_FILE_NAME, 'w') do |f|
    f.write(string)
  end
end

When /^I run "jse([^\"]*)" on my log file$/ do |opts|
  options = parse_options(opts)
  JSE::CLI.execute(output, options + [LOG_FILE_NAME])
end

Then /^I should see:$/ do |text|
  text.split("\n").each do |line|
    output.should include(line)
  end
end

Then /^I should not see:$/ do |text|
  text.split("\n").each do |line|
    output.should_not include(line)
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

# The shell automagically does this part
# Leave out some stuff like escaping quotes
# Just don't nest string or quotes in tests!
def parse_options(opt_string)
  options = []
  word = ""
  in_string = false
  string_delimiter = ""

  opt_string.each_char do |c|
    if !in_string && (c == '"' || c == '\'')
      in_string = true
      string_delimiter = c
    elsif in_string && c == string_delimiter
      in_string = false
    elsif c =~ /\s/ && !in_string
      options << word unless word.chomp == ''
      word = ""
    else
      word << c
    end
  end

  # Add the last argument
  if in_string
    raise "Unterminated string!"
  else
    options << word
  end

  options
end
