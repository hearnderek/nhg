if(ARGV.count == 0)
    print "Missing console argument 'file'\n\n"
    print "Example:\n  ruby ./utf8-to-euc.rb myfile.txt\n"
    exit 1
end

file = ARGV[0]

File.readlines(file).each do |line|
    begin
    encoded_line = line.encode(Encoding::EUC_JP)
    print encoded_line
    rescue
        # just ignore it
        
    end
end
 