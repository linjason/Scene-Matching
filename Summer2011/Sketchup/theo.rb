#!/usr/bin/ruby
#
# Copyright:: Copyright 2008 Google Inc.
# License:: All Rights Reserved.
# Original Author:: Tricia Stahr (mailto:tricias@google.com)
#
# Theo (Test harness for exporting objects)  is utility to automate
# the testing of SketchUp exporters
#
# The utility opens models in the models_to_export directory and exports
# them to the format specifed.
#
# The user specifies preferences in the theo\prefs.dat file
#
require 'ftools'

def setup
  # Define some useful variables
  @current_dir = File.dirname(__FILE__)
  @current_dir  = File.expand_path(@current_dir)
  @model_dir = File.join(@current_dir, 'models_to_export')
  @results_dir = File.join(@current_dir, 'results')
  @prefs_file = File.join(@current_dir, 'prefs.dat')
  @settings_file = File.join(@results_dir, 'settings.txt')
  @su_ruby_script = File.join(@current_dir, 'SU_export.rb')
  # Determine current platform
  @platform = 'win'
  @platform = 'mac' if RUBY_PLATFORM.include? 'darwin'
  # Make results and models dirs if necessary
  Dir.mkdir(@results_dir) if not File.exists?(@results_dir)
  Dir.mkdir(@model_dir) if not File.exists?(@model_dir)
end

# Get user preferences
def get_user_prefs
  f = File.open @prefs_file
  lines = f.readlines
  lines.each do |line|
    line = line.chomp
    if not line.include? '#'
      if line.include? 'curr_prog='
        @current_prog = line.split('=')[1]
      end
      if line.include? 'curr_ver='
        @current_ver = line.split('=')[1]
      end
      if line.include? 'exporter_format='
        @exporter_format = line.split('=')[1]
      end
    end
  end
end

# Do some basic error checking
def check_data
  valid_exporter_formats = ['obj', 'dae', 'kmz','xsi', 'fbx','3ds', 'dxf' ]
  valid_versions = ['6', '7', '8']
  if not valid_exporter_formats.include?(@exporter_format)
    puts "\n The exporter_format in #{@prefs_file} is not valid:" +
         "#{@exporter_format}\n"
    exit
  elsif not valid_versions.include?(@current_ver)
    puts "\n The current_ver in #{@prefs_file} is not valid \n"
    exit
  elsif not File.exists?(@current_prog)
    puts "\n The current_prog  in #{@prefs_file} does not exist:" +
         "#{@current_prog}\n"
    exit
  elsif Dir.glob(File.join(@model_dir, '*.skp')).length.eql? 0
    puts "\n No skp models exist in #{@model_dir}\n"
    exit
  end
end

# Make a date specific results directory
def make_results_dir
  current_time = Time.now.strftime("%m%d%Y_%I%M%p_%S")
  @results_dir = File.join(@results_dir, current_time)
  Dir.mkdir(@results_dir)
end

# Strip funky characters from model names.  Otherwise, exporter would pop
# up a dialog on export and model would fail to open on Mac
# TODO(tricias): rewrite this
def rename_models
  arr_models = Dir.glob(File.join(@model_dir, '*.skp'))
  arr_models.each do |file_name|
    file_base= File.basename(file_name, '.skp')
    file_stripped = file_base.gsub(/[- '#'*?~!@$%^&()+=;:.,]/,'_') + '.skp'
    file_name_new = File.join(@model_dir, file_stripped)
    File.rename(file_name, file_name_new)
  end
end

# Make some useful arrays
def make_arrays
  @arr_models = Dir.glob(File.join(@model_dir, '*.skp'))
end

# On Windows, open each model and export it to the specified format
def call_su_win(prog_name, prog_identifier)

  # Write data SU needs to know to a file which will be used by the
  # SU_export.rb script
	File.open @settings_file, 'w' do |f|
		f.puts @results_dir
		f.puts @exporter_format
  end

  # Call SU to initiate the export via the SU_export.rb script
  @arr_models.each do |model|
    	    start_cmd = "#{prog_name} \"#{model}\" /RubyStartup \"#{@su_ruby_script}\""
    f = IO.popen(start_cmd)
    puts "\n  Exporting #{prog_identifier} #{@exporter_format} for #{model}"
    f.close
  end
end

# On the Mac, open each model and export it to specified format
def call_su_mac(prog_name, prog_identifier)

  # Set special variables as you can't call SU with the /RubyStartup parameter
  # on the Mac and need to write the settings file to a fixed location (i.e. the
  # plugins dir) so SU can find it
  if @platform.eql? 'mac'
    @plugins_dir = "/Library/Application Support/Google SketchUp " +
                                "#{@current_ver}/SketchUp/plugins"
    @settings_file = File.join(@plugins_dir, 'settings.txt')
  end

  # Write data SU needs to know to a file which will be used by the
  # SU_export.rb script
  File.open @settings_file, 'w' do |f|
    f.puts @results_dir
    f.puts @exporter_format
  end

  # Define a file to determine if SU is done exporting
  result_file = "#{@results_dir}/done.txt"
  File.delete(result_file) if FileTest.exist?(result_file)

  # Copy the SU_export.rb script to the plugins directories as /RubyStartup
  # works only on the PC
  File.copy(@su_ruby_script, @plugins_dir)

  #Call SU to initiate the export via the SU_exporte.rb script
  @arr_models.each do |model|
    start_cmd = "open -a '#{prog_name}' #{model}"
    f = IO.popen(start_cmd)
    puts "\n  Exporting #{prog_identifier} #{@exporter_format} for #{model}"

    # On the Mac, need to have SU (via the SU_export.rb script) write
    # a file called done.txt when completing the export and to test for the
    # existence of this file before processing the next model.  Otherwise, this
    # loop would get ahead of itself.
    counter = 0

    # Keep sleeping for up to 150 seconds waiting for exported file to exist
    while not FileTest.exist?(result_file)
      sleep 5
      counter += 5
      puts "..."
      break if counter > 150
    end
    File.delete(result_file) if FileTest.exist?(result_file)
    sleep 2
    f.close
  end

  # Clean up
  ruby_script = File.basename(@su_ruby_script)
  File.delete("#{@plugins_dir}/#{ruby_script}")
  File.delete(@settings_file)
end


# Put it all together and run everything
setup
get_user_prefs
check_data
make_results_dir
rename_models
make_arrays
if @platform.eql? 'win'
  call_su_win(@current_prog, 'current')
elsif  @platform.eql? 'mac'
  call_su_mac(@current_prog, 'current')
end
