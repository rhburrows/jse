require 'optparse'

module JSE
  module CLI
    def self.execute(stdout, arguments = [])
      print = []
      parser = OptionParser.new do |opts|
        opts.banner = <<-BANNER.gsub(/^[ \t]*/, '')
        Json Stream Editor.

        Usage: #{File.basename($0)} [options]

        Options are:
      BANNER
        opts.separator ""
        opts.on("-f", "--fields a,b,c", Array,
                "List of fields to return") do |fields|
          print = fields
        end
        opts.on("-h", "--help",
                "Show this help message.") { stdout.puts opts; exit }
        opts.parse!(arguments)
      end

      if File.exist?(arguments.last)
        stream = JSE::Stream.new(File.open(arguments.pop, 'r'))
      else
        stream = JSE::Stream.new(STDIN)
      end

      arguments.each do |arg|
        field, text = arg.split(':')
        stream.filter!(field, text)
      end

      unless print.empty?
        stream.print!(*print)
      end

      begin
        stream.each_line do |line|
          stdout.puts line
        end
      rescue Errno::EPIPE
        # Catch broken pipes so we can use head etc.
      end
    end
  end
end
