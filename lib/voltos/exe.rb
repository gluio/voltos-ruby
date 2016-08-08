require 'pty'
require 'open3'
require 'readline'

module Voltos
  class Process
    def initialize(input = STDIN, output = STDOUT, err = STDOUT)
      Readline.input = input
      @in  = input
      @out = output
      @err = err
    end

    def tty?
      STDIN.tty?
    end

    def pid=(pid)
      @pid = pid
    end

    def pid
      @pid
    end

    def run(command, *args)
      if tty?
        run_as_tty(command, *args)
      else
        run_as_daemon(command, *args)
      end
    end

    def ctrl_c!
      ::Process.kill('INT', pid)
    end

    private

    def run_as_tty(bin, *args)
      @out.sync = true
      status = PTY.spawn(bin, *args) do |stdout, stdin, pid|
        self.pid = pid
        stdout.sync = true
        Thread.new do
          loop do
            @out.print stdout.getc
          end
        end
        Thread.new do
          loop do
            input = Readline.readline("", true)
            if input.nil?
              stdout.flush
              stdout.close
              stdin.close
            end
            stdin.puts input.strip
          end
        end
        begin
          ::Process::waitpid(pid) rescue nil
          while out = stdout.getc do
            @out.print out
          end
        rescue SystemExit, Interrupt
          ctrl_c!
          retry
        rescue EOFError
        rescue IOError, Errno::EIO
        end
      end
      status
    end

    def run_as_daemon(bin, *args)
      process = nil
      Open3.popen3(bin, *args) do |stdin, stdout, stderr, thread|
        self.pid = thread.pid
        Thread.new do
          while !stdin.closed? do
            input = Readline.readline("", true).strip
            stdin.puts input
          end
        end

        errThread = Thread.new do
          while !stderr.eof?  do
            @err.putc stderr.readchar
          end
        end

        outThread = Thread.new do
          while !stdout.eof?  do
            putc stdout.readchar
          end
        end

        begin
          Process::waitpid(thread.pid) rescue nil
          errThread.join
          outThread.join
          process = thread.value
        rescue SystemExit, Interrupt
          retry
        end
      end
      return process.exitstatus if process
    end
  end
end
