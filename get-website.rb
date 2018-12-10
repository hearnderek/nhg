require 'net/http'

if(ARGV.count == 0)
    print "Missing console argument 'website-url'\n\n"
    print "Example:\n  ruby get-website.rb http://mysite\n"
    exit 1
end

link = ARGV[0]

uri = URI(link)
print (Net::HTTP.get(uri) + "\n")