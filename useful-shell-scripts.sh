# Find every journal file containing the word "abswl" within a certain
# directory tree.

find . -name '*.jou' | xargs grep -r '^abswl' | cut -d: -f1 | uniq

# Kill all of my processes

ps u | tr -s ' ' | cut -d' ' -f2 | tail -n +2 | xargs kill -9

