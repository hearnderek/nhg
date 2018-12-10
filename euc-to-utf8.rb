if(ARGV.count == 0)
    print "Missing console argument 'file'\n\n"
    print "Example:\n  ruby ./euc-to-utf8.rb myfile.txt\n"
    exit 1
end

file = ARGV[0]

File.readlines(file, :encoding => 'EUC-JP').each do |line|
    encoded_line = line.encode(Encoding::UTF_8)
    print encoded_line
end