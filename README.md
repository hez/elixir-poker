# ElixirPoker

Poker hand evaulator. Built to see what the comparisons with the following previous art would be.

- https://github.com/gmacdougall/ruby-poker
- https://github.com/snarfmason/crystal-poker

# Running

Takes a bunch of poker hands and outputs the winners

```bash
$ echo "KS 4S AD 4C 7D|TD 6S 4H 4D KC|8C 3C 3S AS TS|2S JH 2H 8H TH|6C QS 2C 5H 9C|5C JS 2D 7C QH" | mix run run.exs
KS 4S AD 4C 7D|TD 6S 4H 4D KC|8C 3C 3S AS TS|2S JH 2H 8H TH|6C QS 2C 5H 9C|5C JS 2D 7C QH, Winner: TD 6S 4H 4D KC, Rank: One Pair
```
