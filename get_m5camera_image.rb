#!/usr/bin/ruby
# vim: ts=2 sw=2 et si ai : 

require 'pp'
require 'open-uri'
require 'fileutils'
require 'logger'
require 'base64'
require 'json'

def usage
  $stderr.puts "usage #{$0} ipaddress"
  exit
end
usage if ARGV.size == 0

Dir.chdir(File.dirname($0))

$log = Logger.new(STDERR)
$log.level = Logger::DEBUG

host =  ARGV[0]
m5camera_capture_url = "http://#{host}/capture"
m5camera_control_url = "http://#{host}/control?var=framesize&val=5"

begin
  # capture setting....
  open(m5camera_control_url).read

  sleep 0.5

  open(m5camera_capture_url) do |f|
    img = f.read
  
    b64 = Base64.strict_encode64(img)
    data_uri_scheme = "data:image/jpeg;base64," + b64

    h = {}
    h["image"] = data_uri_scheme
    json_str = h.to_json
    puts(json_str)
  end
rescue Exception => e
  $log.error(e)
end
