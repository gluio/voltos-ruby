require 'voltos/logger'
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
      logger.debug "Storing spawned process pid: #{pid}"
      @pid = pid
    end

    def pid
      @pid
    end

    def run(command, *args)
      logger.debug "Running: #{command} #{args.join(' ')}"
      Signal.trap('INT') do
        ctrl_c!
      end
      Signal.trap('TERM') do
        ctrl_c!
      end
      if tty?
        run_as_tty(command, *args)
      else
        run_as_daemon(command, *args)
      end
    end

    def ctrl_c!
      pid_to_kill = pid || ::Process.pid
      logger.debug "Sending ^C to: #{pid_to_kill}"
      ::Process.kill('TERM', pid_to_kill)
      ::Process.waitall
    end

    def ctrl_d!
      logger.debug "Sending ^D"
      @process_stdin.close if @process_stdin
      @process_stdout.close if @process_stdout
      logger.debug "Sent."
    end

    private
    def logger
      return @logger if @logger
      @logger = Voltos::Logger
    end

    def run_as_tty(bin, *args)
      @out.sync = true
      status = PTY.spawn(bin, *args) do |stdout, stdin, pid|
        self.pid = pid
        @process_stdin = stdin
        @process_stdout = stdout
        stdout.sync = true
        Thread.new do
          loop do
            @out.print stdout.getc
          end
        end
        Thread.new do
          loop do
            input = Readline.readline('', true)
            if input.nil?
              logger.debug "Cleaning up STDIN & STDOUT..."
              stdout.flush
              stdout.close
              stdin.close
            end
            stdin.puts input.strip
          end
        end
        begin
          logger.debug "Waiting for process to finish: #{pid}"
          ::Process::waitpid(pid) rescue nil
          ::Process.waitall
          logger.debug "Process finished."
          while out = stdout.getc do
            @out.print out
          end
        rescue SystemExit, Interrupt
          logger.debug "Rescued interrupt."
          ctrl_c!
          retry
        rescue EOFError
          logger.debug "Rescued EOF."
        rescue IOError, Errno::EIO
          logger.debug "Rescued IOError."
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
            input = Readline.readline('', true).strip
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
          logger.debug "Waiting for process to finish #{thread.pid}."
          Process::waitpid(thread.pid) rescue nil
          errThread.join
          outThread.join
          logger.debug "Process finished."
          process = thread.value
        rescue SystemExit, Interrupt
          logger.debug "Rescued interrupt."
          retry
        end
      end
      return process.exitstatus if process
    end
  end
end
