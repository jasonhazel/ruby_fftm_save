#!/usr/bin/env ruby
require 'fileutils'
require "mp3info"

home_path = Dir.home
save_path = "#{home_path}/TTFM/"
chrome_cache_path = "#{home_path}/.cache/google-chrome/Default/Cache/"

Dir.mkdir(save_path) unless File.directory? save_path

Dir.entries("#{chrome_cache_path}").each do |file|
  file_path = "#{chrome_cache_path}#{file}"
  if file =~ /^f_/ and File.size(file_path) >= 1024000
    begin
      Mp3Info.open(file_path) do |info|
        unless info.tag.empty?
          new_file_path = "#{save_path}#{info.tag.artist} - #{info.tag.title}.mp3"
          puts new_file_path
          FileUtils.mv(file_path, new_file_path)
        end
      end
    rescue
      puts "error on #{file_path}"
    end
  end
end
