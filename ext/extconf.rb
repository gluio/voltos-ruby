require 'rbconfig'
# Cross-platform way of finding an executable in the $PATH.
#
#   which('ruby') #=> /usr/bin/ruby
def which(cmd)
  exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
  ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
    exts.each { |ext|
      exe = File.join(path, "#{cmd}#{ext}")
      return exe if File.executable?(exe) && !File.directory?(exe)
    }
  end
  return nil
end

module OS
  def self.platform
    case ::RbConfig::CONFIG['host_os']
    when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
      :windows
    when /darwin|mac os/
      :osx
    when /linux/
      :linux
    when /solaris|bsd/
      :unix
    else
      return nil
    end
  end
end

if which('voltos')
  puts "Voltos binary already installed on system, skipping re-compilation."
  exit(0)
else
  print "Preparing Voltos binary..."
  case OS.platform
  when :osx
    puts " done."
  when :linux, :unix
    puts " done."
  else
    puts " #{OS.platform} does not current have binary support for Voltos. Skipping."
  end
  exit(0)
end
