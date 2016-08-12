require 'spec_helper'
require 'pty'
require 'timeout'

describe Voltos do
  it 'has a version number' do
    expect(Voltos::VERSION).not_to be nil
  end

  describe 'running the binary' do
    let(:stdin) { STDIN }
    let(:stdout) { StringIO.new }
    let(:stderr) { StringIO.new }
    let(:process) { Voltos::Process.new(stdin, stdout, stderr) }

    before do
      $stdout = stdout
    end

    it 'knows if terminal is tty' do
      expect(process).to be_tty
    end

    describe 'within a tty' do
      it 'runs command in interactive mode' do
        expect(PTY).to receive(:spawn).with("echo", "foo")
        process.run("echo","foo")
      end

      xit 'passes input from STDIN to process' do
        # No idea how to simulate this :(
        # process.run("read", "foo")
      end

      it 'syncs STDOUT' do
        process.run("echo","foo")
        stdout.rewind
        expect(stdout.read.chomp).to eq("foo")
      end

      xit 'syncs STDERR' do
        # Can't get this test to work either, urgh
      end

      it 'passes through CTRL^C' do
        ::Process.fork do
          Thread.new do
            process.run("sleep", "30")
          end
          read = IO.popen("ps -ef | grep #{::Process.pid}")
          child_pid = read.readlines.map do |line|
            parts = line.split(/\s+/)
            parts[2] if parts[3] == Process.pid.to_s and parts[2] != read.pid.to_s
          end.compact.first

          expect(::Process).to receive(:kill).with('TERM', child_pid.to_i).and_call_original
          process.ctrl_c!
        end
        ::Process.waitall
      end

      it 'passes through CTRL^D' do
        Timeout::timeout 2 do
          Thread.new do
            sleep(0.5)
            process.ctrl_d!
          end
          process.run("read", "foo")
          ::Process.waitall
        end
      end

      it 'terminates any orphaned or zombie child processes' do
        ::Process.fork do
          Thread.new do
            sleep(0.5)
            process.ctrl_c!
          end
          process.run("spec/fixtures/bin/forked_sleep")
        end
        sleep(1)
        sleeps = IO.popen("ps -ef | grep sleep")
        child_pids = sleeps.readlines.map do |line|
          parts = line.split(/\s+/)
          if parts[3] == ::Process.pid.to_s && !(line =~ /grep sleep/)
            parts[2]
          end
        end.compact
        ::Process.waitall
        expect(child_pids.size).to eq(0)
      end

      it 'flushes any remaining STDOUT content before exiting'
      it 'returns exit status from process'
    end

    describe 'when not a tty' do
      it 'runs command as non-interactive process'
      it 'syncs STDOUT'
      it 'syncs STDERR'
      it 'terminates any orphaned or zombie child processes'
      it 'flushes any remaining STDOUT content before exiting'
      it 'returns exit status from process'
    end
  end
end

