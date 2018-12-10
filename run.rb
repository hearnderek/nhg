if(ARGV.count == 0)
  print "**************************************\n"
  print "If you're working with a utf8 file...\n\n"
  print "Missing console argument 'file'\n\n"
  print "Example:\n  ruby ./run.rb myUtf8Article.txt\n"
  print "\n**************************************\n"
  print "If you're working with a website...\n\n"
  print "Missing console argument 'website-url'\n"
  print "Missing console argument 'name'\n\n"
  print "Example:\n  ruby ./run.rb http://example example-name\n"
  exit 1
end

file = ARGV[0]

filename = File.basename(file)
fileext = File.extname(file)
filedir = File.dirname(file)

scriptdir = File.dirname(__FILE__)
tmpdir = "#{scriptdir}/tmp"
outdir = "#{scriptdir}/out"

if (file.start_with?("http"))
  url = ARGV[0]
  if(ARGV.length == 1)
    print "It looks like you're trying to work with a website...\n\n"
    print "Missing console argument 'name'\n\n"
    print "Example:\n  ruby ./run.rb http://example example-name\n"
    exit 1
  end
  file = "#{tmpdir}/#{ARGV[1]}.txt"
  filename = ARGV[1]
  fileext = ".txt"
  filedir = tmpdir
  `ruby get-website.rb #{url} > #{file}` 
end

print "dir: #{filedir}, name: #{filename} \n"
print "scriptdir: #{scriptdir}\n"
print "scriptdir: #{tmpdir}\n"
print "file ext: #{fileext}\n"

if(fileext == '.html')
  # when it's an html file strip out the html first
  filename = "#{filename}.txt"
  `ruby strip-html.rb #{file} > #{tmpdir}/#{filename}`
  `ruby utf8-to-euc.rb #{tmpdir}/#{filename} > #{tmpdir}/euc-#{filename}`
  `rm  #{tmpdir}/#{filename}`
else
  # this is a text version of the article we want to parse
  `ruby utf8-to-euc.rb #{file} > #{tmpdir}/euc-#{filename}`
end

# get a word list from the program chasen
`chasen #{tmpdir}/euc-#{filename} > #{tmpdir}/split-euc-#{filename}`

# turn that word list into an easy to digest frequency list of words I care about
`ruby euc-to-utf8.rb #{tmpdir}/split-euc-#{filename} > #{tmpdir}/split-utf8-#{filename}`
`ruby word-frequency.rb #{tmpdir}/split-utf8-#{filename} > #{outdir}/frequency-#{filename}`

`rm  #{tmpdir}/euc-#{filename}`
`rm  #{tmpdir}/split-euc-#{filename}`
`rm  #{tmpdir}/split-utf8-#{filename}`

# example of how to run a single word through chasen
# word = '名詞'
# (`echo #{word} | chasen`).encode('utf-8','EUC-JP')