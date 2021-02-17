# Stonky Telegram Bot README

Stonky is a Telegram bot that provides access to financial informations.
It is backed by the publicly available Yahoo Finance HTTP API, it is written
in C and is released under the BSD license.

## Installation

1. Create your bot using the Telegram [@BotFather](https://t.me/botfather).
2. After obtaining your bot API key, store it into a file called `apikey.txt` inside the bot working directory. Alternatively you can use the `--apikey` command line argument to provide your Telegram API key.
3. Build Stonky: you need libcurl and libsqlite installed. Just type `make`.
4. Run Stonky with `./stonky`. There is also a debug mode if you run it using the `--debug` option. For a more moderate output use `--verbose`. Try `stonky --help` for the full list of command line options.
5. Add the bot to your Telegram channel.
6. **IMPORTANT:** The bot *must* be an administrator of the channel in order to read all the messages that are sent in such channel.

By default the bot will create an SQLite database in the working directory.
If you want to specify another path for your SQLite db, use the `--dbfile`
command line option.

## Usage

To use the bot, send messages in a Telegram channel where the bot is an
administrator, otherwise directly address the bot via a private message.
All the Stonky commands start with the "$" character.

    $AAPL           -- Reply with an update about AAPL price.
    $AAPL 1y        -- Reply with an ASCII art graph of AAPL price during
                       the past year. Valid intervals are: 1d|5d|1m|6m|1y
    $AAPL mc        -- Reply with the result of a Montecarlo simulation on
                       the 52 weeks price of the specified stock. You can
                       say "montecarlo" instead of "mc" if you want.

The `$AAPL mc` command supports a `period` and `range` option, in case you
want to perform experiments with a fixed amount of days of distance between
buying and selling, or if you want to change the default 365 days range of
analysis.

    $AAPL mc period 10 range 200

## Lists support

The bot supports the concept of "list of stocks", you can add stocks to
a list, then query the list to have all the prices with a single message:

    $mylist: +VMW +AAPL +T -KO  -- Modify the list adding/removing stocks.
    $mylist:                    -- Ask prices of stocks in a given list.
    $mylist: ?                  -- Just show the stocks in the list.
    $$ ls                       -- Show all the defined lists

## Portfolio support

Every list can be used as a portfolio for paper trading (or just to reflect
your real portfolio of stocks). For every stock it is possible to buy or
sell stocks, optionally specifying the amount and price. For instance to
add 50 AAPL stocks bought at an average price of 130.57 write:

    $myportfolio: buy AAPL 50@130.57

If just the quantity is specified, the current stock price will be used:

    $myportfolio: buy AAPL 50

If only the stock name is specified, just a single stock is bought, using
the current market price:

    $myportfolio: buy AAPL

The bot tracks the average price of your purchases, this is an example
of a chat with the bot:

    me>  $myportfolio: buy AAPL 50@120
    bot> Now you have 50 AAPL stocks at an average price of 120.00
    me>  $myportfolio: buy AAPL 30@75.40
    bot> Now you have 80 AAPL stocks at an average price of 103.28

You can see the list of stocks in your portfolio writing `$listname?`.
For example:

    me>  $myportfolio?
    bot> AAPL  | 80  | +2567.60 (+31.08%) 💚💚💚

The bot will put a green <3 for every 10% gain, a red one for every 10% loss.

Finally you can sell stocks:

    me>  $myportfolio: sell AAPL 10
    bot> You are left with 70 AAPL stocks at an average price of 103.28
    me>  $myportfolio: sell AAPL
    bot> You no longer own AAPL stocks

As you can see, selling without specifying the quantity will just sell
all the stocks.

## Profit and losses

Stonky remembers all the sell operations performed for a given portfolio.
When you sell stocks, you can tell stonky the price at which you sold. This
way it will calculate the profit & loss. Example:

    me> $newportfolio: buy AAPL 10
    bot> Now you have 10 AAPL stocks at an average price of 133.19
    me> $newportfolio: buy TSLA 10
    bot> Now you have 10 TSLA stocks at an average price of 796.22
    me> $newportfolio: sell AAPL 5@142.11
    bot> You are left with 5 AAPL stocks at an average price of 133.19

    Now with the "pl" subcommand of the portfolio visualization format,
    you can see the history of your sells:

    me> $newportfolio? pl
    bot> AAPL   : 5 sold at 710.55$ (P/L +44.60 +6.70% 🍀), 20 seconds ago
         Total portfolio performance: +44.60 USD

To get a recap of all the available commands, just send an `$HELP` message
to the bot.

## Background analysis of stocks

If the file `marketdata/symbols.txt` exists in the bot working directory,
and contains a list of stock symbols (it is included in the default
distribution, so the file exists unless you remove it intentionally), the
bot starts continuously analyzing the listed stocks, one per second, looking
for stocks that performed in specific ways.

Such stocks are put into lists that are handled by the bot itself. You
can see the stocks in this list by writing simply:

    $tothemoon:

In the channels where the bot is admin or directly to the bot itself as a
private message.

The bot handles the following lists:

* The `tothemoon` list contains stocks that performed poorly in the past, but now for some reason are showing to have a massive momentum.
* The `evenbetter` list contains stocks that are very strong performers in the past, and now are performing even better.

## Output examples

$AAPL 1y

```
AAPL 1y | min 57.31 max 136.91
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⠀⠀⡀⡀⣀⣴⣿⣾⣿
⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣾⣿⣶⣿⣿⣿⣿⣿⣿⣿⣿
⠀⠀⠀⠀⠀⠀⠀⣠⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣦⣄⠀⢀⣠⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
```

$AAPL mc

```
Buying and selling 'AAPL' at random days during 
the past year would result in 35.53% average gain/loss. 
1000 experiments with an average interval of 83.76 days.
```

$AAPL

```
Apple Inc. (AAPL) price is 136.91$ (+0.11%) |
pre-market: 136.66$ (-0.18%)
```

## Bot administration

If you are developing this bot adding features, like I'm doing right now,
every time a new feature is added to ssh to the remote server, recompile it
and execute it again can be boring. You also need to do that if you are
just a normal user and want to update the bot with the new features from
time to time. For this reason the bot has a `$$ quit <password>` feature
that let the administrator of the bot to quit it remotely.

To set the admin password use `--adminpass` option, otherwise the command
is not recognized at all. Once you do that, you can start the bot, remotely,
under a screen or tmux session, with:

    while [ 1 ]; do make; ./stonky; sleep 5; done

Every time the bot quits, it recompiles itself and restarts. The
sleep is important since if there is a problem, you don't want to burn
all your server CPU in a busy loop.
