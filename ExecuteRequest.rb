###
# next_request_template:
#   description: Name of request template
# next_request_id:
#   description: ID of a specific request
###
# Load the input parameters file and parse as yaml.
require 'rubygems'
require 'net/http'
require 'uri'
params["direct_execute"] = true

token="7e3041ebc2fc05a40c60028e2c4901a"
@ss_url = params["SS_base_url"] 

def fetch_url(path, testing=false)
  tmp = "#{@ss_url}/#{path}".gsub(" ", "%20") #.gsub("&", "&amp;")
  jobUri = URI.parse(tmp)
  puts "Fetching: #{jobUri}"
  request = Net::HTTP.get(jobUri) unless testing
end

# Pre URL stuff
base_url = "REST/requests"
task = "none"
req_id = params["next_request_id"]
template_name = params["next_request_template"]
if req_id.to_i > 0
  task = template_name.length > 1 ? "template" : "id"
else
  task = "template" if template_name.length > 1
end
case task
when "template"
  routine_part = "/create_request_from_template?token=#{token}&"
  rest_url = "#{base_url}#{routine_part}request_template=#{template_name}"
  rest_url += "&auto_start=yes"
  write_to "REST Call: #{rest_url}"
  rest_result = fetch_url(rest_url)
  write_to "==== New Request Response ===="
  write_to rest_result
when "id"
  routine_part = "/update_state?token=#{token}&"
  rest_url = "#{base_url}/#{req_id}#{routine_part}transition=start"
  write_to "REST Call: #{rest_url}"
  rest_result = fetch_url(rest_url)
  write_to "==== Start Request Response ===="
  write_to rest_result
  
end
# Test the results for success or failure
success = "App:"
unless results.include?(success)
  write_to "Success test, looking for #{success}: Success!"
else
  write_to "Success test, looking for #{success}: Command_Failed"
end
