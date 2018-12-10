get-article :: Wikipedia => url -> utf8-jp-article.txt 
get-article url = TODO -- get-article.rb url > utf8-jp-article.txt

utf8-to-euc :: utf8-jp-article.txt -> euc-jp-article.txt
utf8-to-euc file = utf8-to-euc.rb file > euc-jp-article.txt

split-words :: euc-jp-article.txt -> euc-jp-split.txt
split-words = chasen euc-jp-article.txt > euc-jp-split.txt

euc-to-utf8 :: euc-jp-split.txt -> utf8-jp-split.txt
euc-to-utf8 file = euc-to-utf8.rb file -> utf8-jp-split.txt

word-frequency :: utf8-jp-split.txt -> utf8-jp-frequency.csv
word-frequency file = word-frequency.rb file > utf8-jp-frequency.csv

study-word :: IO(study-dict.txt) -> word -> IO(study-dict.txt)
study-word word = study-word.rb word

known-word :: IO(study-dict.txt, known-dict.txt) -> word -> IO(study-dict.txt, known-dict.txt)
known-word word = known-word.rb word

