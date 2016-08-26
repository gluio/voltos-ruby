require 'open-uri'
require 'fileutils'
require 'rbconfig'
require 'rubygems/package'
require 'zip'
require 'zlib'

def download_binary(platform)
  local_bin_path = File.expand_path("../exe")
  latest_binary = "https://voltos.io/v1/download/#{platform}"
  open(latest_binary) do |remote_file|
    case platform
    when :osx
      Zip.on_exists_proc = true
      Zip::File.open(remote_file) do |zip_file|
        zip_file.each do  |f|
          if f.file?
            name = f.name == 'voltos' ? 'voltos-cli' : f.name
            local_file_name = File.join(local_bin_path, name)
            f.extract(local_file_name)
            FileUtils.chmod 0711, local_file_name
          end
        end
      end
    else
      gzip = Zlib::GzipReader.new(remote_file)
      tar_extract = Gem::Package::TarReader.new(gzip)
      tar_extract.rewind
      tar_extract.each do |entry|
        if entry.file?
          name = entry.full_name == 'voltos' ? 'voltos-cli' : entry.full_name
          local_file_name = File.join(local_bin_path, name)
          open(local_file_name, 'w') do |local_file|
            local_file.write(entry.read)
          end
          FileUtils.chmod 0711, local_file_name
        end
      end
      tar_extract.close
    end
  end
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

print "Preparing Voltos binary..."
case OS.platform
when :osx
  download_binary(:osx)
when :linux, :unix
  download_binary(:linux64)
else
  puts " #{OS.platform} does not current have binary support for Voltos. Skipping."
end
exit(0)
