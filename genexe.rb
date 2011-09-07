#!/usr/bin/ruby

# This script is meant to run on windows only,
# with the purpose of running InstallShield.
#
require 'rubygems'
require 'fileutils'
require 'digest/sha1'
require 'rake'
require 'erb'
require 'util'
require 'pathname'

DESTDIR_PREFIX = ARGV[0] || "."
WIN_PYTHON     = "/cygdrive/c/Python26/python"

BIN_PATH = ["/mingw/bin",
            "/usr/bin",
            "/msys/1.0/bin",
            "/sw/bin",
            "/bin",
            "/msysgit/msysgit/bin",
            "/c/msysgit/msysgit/bin"].
           concat((ENV['PATH'] || "").
                  split(";")).
           map {|x| x + '/'}

def bin(prog)
  p = BIN_PATH.find {|b| (File.directory?(b)) and
                         (File.exists?(b + "/#{prog}") or
                          File.exists?(b + "/#{prog}.exe"))}
  (p || '') + prog
end

def py2exe(scriptToConvert)
  cwd = Dir.getwd()

  p = Pathname.new(scriptToConvert)

  Dir.chdir(p.dirname)

  x = "from distutils.core import setup\n" +
      "import py2exe\n" +
      "setup(console=['#{p.basename}'],\n" +
      "      options={'py2exe': {'bundle_files': 1}},\n" +
      "      zipfile=None)\n"

  File.open("dist_setup.py", 'w') {|fw| fw.write(x)}

  hard_sh("#{WIN_PYTHON} dist_setup.py py2exe")

  FileUtils.cp_r(Dir.glob("dist/*"), ".")

  FileUtils.rm_rf("build")
  FileUtils.rm_rf("dist")
  FileUtils.rm_r("dist_setup.py")

  Dir.chdir(cwd)
end

# Convert python scripts that don't end with .py
#
Dir.glob("#{DESTDIR_PREFIX}/*").
  select {|x| !x.match('.py$') && !File.directory?(x)}.
  select {|x| (File.open(x) {|f| f.readline}).match(/python/)}.
  each {|x| py2exe(x)}


