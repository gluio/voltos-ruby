require 'open3'
require 'readline'
Gem.execute do |original_file|
  version = ">= 0.a"
  gem 'voltos', version
  bin = Gem.bin_path('voltos', 'voltos', version)
  process = nil
  Open3.popen3(bin, *ARGV) do |stdin, stdout, stderr, thread|
    Thread.new do
      while !stdin.closed? do
        input = Readline.readline("", true).strip
        stdin.puts input
      end
    end

    errThread = Thread.new do
      while !stderr.eof?  do
        putc stderr.readchar
      end
    end

    outThread = Thread.new do
      while !stdout.eof?  do
        putc stdout.readchar
      end
    end

    Process::waitpid(thread.pid) rescue nil
    errThread.join
    outThread.join
    process = thread.value
  end
  exit(process.exitstatus)
end
