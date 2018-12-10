if(ARGV.count == 0)
    print "Missing console argument 'file'\n\n"
    print "Example:\n  ruby ./utf8-to-euc.rb myfile.txt\n"
    exit 1
end

file = ARGV[0]

countHash = {}
totalWords = 0
unknownWords = 0

File.readlines(file).each do |line|
    
    # just the first word
    edited = line.gsub(/	.+$/,'').strip

    
    next if (edited == '')
    next if (edited == 'EOS')
    
    white_space_split = line.split(/\s/)
    
    
    if(edited.length == 1)
        
        next if(/[・、〇]/ =~ white_space_split[0])

        # no simply alphanumeric 'words'
        next if(/^[a-zA-Z0-9あ-んア-ン]$/ =~ edited)

        # 助詞,記号,助動詞 無し
        next if(/^(助動?詞|記号)/ =~ white_space_split[3])
        
        # word != 辞書形
        next if(white_space_split[0] != white_space_split[2])

        # remove non-acsii utf8 numbers
        next if(edited.scan(/[[:digit:]]/).length > 0)
    end

    # remove latin words
    next if(/^\w+$/ =~ edited)

    #辞書形!
    if(white_space_split.length >= 4 && white_space_split[2].length > 0)
        reading = white_space_split[1]
        if(reading == white_space_split[0] || /^[あ-んア-ン]+$/ =~ white_space_split[2])
            reading = '同'
        end
        #print ("#{white_space_split[0]} -> #{white_space_split[2]}: #{white_space_split[2].length}\n")
        edited = "#{white_space_split[2]}, #{reading}"
    else
        edited = "#{edited}, 同"
    end

    #edited = white_space_split[2] if(!(/未知語\s*$/ =~ line))

    if (countHash[edited] == nil)
        countHash[edited] = 0
    end
    countHash[edited] += 1
    totalWords += 1
end

trueFrequency = File.readlines('doc/jp-20000-frequency.txt').map {|l| l.strip}

# using a hash to increase lookup speed
knownWordsHash = {}
File.readlines('doc/known-dict.txt').each do |l| 
    word = l.strip
    knownWordsHash[word]=true #any value works
end


print ("word, reading, count, frequency\n")

countHash.sort_by{|k,v| v}.reverse.each do |key,value|
    word = key.split(',')[0]
    if(!(knownWordsHash.key?(word)))
        unknownWords += value
        frequencyNumber = trueFrequency.index(word)
        print ("#{key}, #{value}, #{frequencyNumber}\n")
    else
        # print ("KNOWN #{key}, #{value}, #{frequencyNumber}\n")
    end
end


print ("total words, total unknown, %\n")
print ("#{totalWords}, #{unknownWords}, #{(unknownWords/totalWords.to_f).round(2)}\n")