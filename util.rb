STARTDIR = Dir.getwd()

def os
  `uname -s`.chomp.downcase
end

def os_short
  os().gsub(/[0-9\.]/, '').
       gsub(/mswin*/i, 'win').
       gsub(/mingw*/i, 'win').
       gsub(/cygwin*/i, 'win').
       gsub(/_nt-/i, '').
       gsub(/-wow/i, '')
end

def os_nbits
  # Note that we might be running a 32-bit OS on a 64-bit processor.
  # Here we want to number of OS bits.
  case os_short()
    when 'win'
      # The pa looks like "AMD64" on a 64-bit box.
      pa = ENV["PROCESSOR_ARCHITEW6432"] || ""
      wd = ENV["WINDIR"] || "/Windows"
      # One day, the directory check will break when MSFT
      # removes 32-bit backwards compatibility.
      if pa.match(/64/) and File.directory?(wd + "/SysWOW64")
        '64'
      else
        '32'
      end
    when 'sunos'
      `isainfo -b`.chomp()
    when 'linux'
      if `uname -m`.chomp() == "x86_64"
        '64'
      else
        '32'
      end
    when 'darwin'
      print "WARNING: Reporting this as a 32 bit platform..\n"
      '32'
    else
      print "ERROR: Don't know to detect the number of bits on this platform.\n"
      exit(1)
  end
end

def scan_check(distdir)
  # Check if there are any text editor backup files here.
  drafts = Dir.glob('#{distdir}/**/*~')

  # Some autotools leave around harmless config.h.in~ files.
  drafts = drafts.delete_if {|x| x.match(/\/config.h.in~$/) }

  if drafts.length > 0
    print("ERROR: There are editor draft files here: #{drafts}\n")
    exit(1)
  end
end

def bin(x) # Possibly overridden by platform-specific code.
  x
end

def hard_sh(cmd)
  sh cmd do |ok, res|
    if not ok
      e = "ERROR: cmd failed: #{cmd}\nERROR: with result: #{ok}, #{res}\n"
      raise e
    end
  end
end

