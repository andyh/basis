# Spec::Runner.configure do |config|
#   def capture(stream)
#     begin
#       stream = stream.to_s
#       eval "$#{stream} = StringIO.new"
#       yield
#       result = eval("$#{stream}").string
#     ensure 
#       eval("$#{stream} = #{stream.upcase}")
#     end
# 
#     result
#   end
#   
#   alias silence capture
# end

require "tmpdir"
require "basis"

FIXTURES_PATH = File.join(File.expand_path(File.dirname(__FILE__)), "fixtures")
