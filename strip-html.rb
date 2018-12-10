if(ARGV.count == 0)
    print "Missing console argument 'file'\n\n"
    print "Example:\n  ruby ./strip-html.rb my-site.html\n"
    exit 1
end

file = ARGV[0]

inTextElement = false

print(File.read(file).gsub(/<[^>]+>/,'').gsub(/\s\s+/,''))