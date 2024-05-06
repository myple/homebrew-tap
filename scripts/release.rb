# frozen_string_literal: true

require "net/http"
require "json"
require "digest"

version = ARGV[0]
if version.nil?
  abort "Usage: release.rb [x.y.z]"
else
  version = version.gsub(/[a-z-]*/i, "")
end

puts "Releasing Myple on Homebrew: v#{version}"

url = "https://api.github.com/repos/myple/cli/releases/tags/v#{version}"
response = Net::HTTP.get_response(URI(url))
abort "Did not find release: v#{version} [status: #{response.code}]" unless response.is_a?(Net::HTTPSuccess)

release = JSON.parse(response.body)
puts "Found release: #{release["name"]}"

assets = {}
release["assets"].each do |asset|
  filename = asset["name"]
  if !filename.end_with?(".tar.gz") || filename.include?("-profile")
    puts "Skipped asset: #{filename}"
    next
  end

  url = asset["browser_download_url"]
  loop do
    response = Net::HTTP.get_response(URI(url))
    url = response["location"]
    break unless response.is_a?(Net::HTTPRedirection)
  end

  abort "Did not find asset: #{filename} [status: #{response.code}]" unless response.is_a?(Net::HTTPSuccess)

  sha256 = Digest::SHA256.hexdigest(response.body)
  puts "Found asset: #{filename} [sha256: #{sha256}]"

  assets[filename] = sha256
end

formula = ""
File.open("Formula/myple.rb", "r") do |file|
  file.each_line do |line|
    query = line.strip

    new_line = if query.start_with?("version")
      line.gsub(/"[0-9\.]{1,}"/, "\"#{version}\"")
    elsif query.start_with?("sha256")
      asset = query[(query.index("#") + 2)..].strip # ex darwin-v0.4.0-arm64.tar.gz
      asset = asset.gsub(/v[0-9\.]{1,}/, "v#{version}")
      sha256 = assets[asset]
      abort "Did not find sha256: #{asset}" if sha256.nil?
      line = line.gsub(/"[A-Fa-f0-9]{1,}"/, "\"#{sha256}\"")
      line.gsub(/# [A-Za-z0-9\.\-]{1,}$/, "# #{asset}")
    else
      line
    end

    formula += new_line
  end
end

versioned_class = "class MypleAT#{version.delete(".")}"
versioned_formula = formula.gsub("class Myple", versioned_class)
File.write("Formula/myple@#{version}.rb", versioned_formula)
puts "Saved Formula/myple@#{version}.rb"

File.write("Formula/myple.rb", formula)
puts "Saved Formula/myple.rb"

readme = File.read("README.md")
new_readme = readme.gsub(/myple@[0-9]{1,}\.[0-9]{1,}\.[0-9]{1,}/, "myple@#{version}")
File.write("README.md", new_readme)
puts "Saved README.md"

puts "Done"
