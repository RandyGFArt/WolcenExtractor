require 'fileutils'

class PakIO
  attr_reader :dos_source, :dos_dest, :posix_source, :posix_dest

  def initialize(dos_source, dos_dest)
    @dos_source = dos_source
    @posix_source = dos_source.gsub('\\','/')
    @dos_dest = dos_dest
    @posix_dest = dos_dest.gsub('\\','/')
  end

  def find_files(extension, dest: false)
    Dir.glob("#{dest ? posix_dest : posix_source}/**/*.#{extension}")
  end

  def format_path(path, posix: true, with_source: false, with_dest: false)
    formatted_path = path
    src = posix ? posix_source : dos_source
    dst = posix ? posix_dest : dos_dest
    escape = ->(s) { posix ? s.gsub!('\\', '/') : s.gsub!('/', '\\') }

    escape.(path)
    formatted_path.sub!(src, '')
    formatted_path.sub!(dst, '')

    if with_source
      formatted_path = "#{src}#{formatted_path}"
    elsif with_dest
      formatted_path = "#{dst}#{formatted_path}"
    end
    formatted_path
  end

  def create_dest_folder
    puts "Creating destination folder and replicating source hierarchy..."
    folders = Dir.glob("#{posix_source}/**/")
    folders.each do |folder|
      FileUtils.mkdir_p(format_path(folder, posix: true, with_dest: true))
    end
    puts "Done!"
  end
end