# Tamarillo

A command line pomodoro/tomato timer. 

Runs a daemon for observing the current tomato. Includes a skinny API
for populating your command prompt and attaching various notifications
to the end of a tomato. Also provides storage of past tomatoes for
analysis, etc.

Your tomatoes are stored in a flat file in the user directory
`~/.tamarillo`. 


## Why Tamarillo?

The tamarillo is a cousin to the tomato, which is also related to
eggplants and potatoes and the deadly nightshade. When tomatoes were
first introduced to europe, they were not popular because people
associated them with the deadly poisons of their cousins.

In any case, tamarillos are delicious if you can find them.

## Examples

### Configuration

  $ tam config duration 25m
  > tamarillo duration is 25 minutes

  $ tam config alert growl
  > tamarillo will use Growl for notifications

  $ tam config daemon ~/.tamarillo/pid
  > tamarillo will monitor the current tomato from here

### Starting a tomato

  $ tam
  > no tomatoes in progress
  > no tomatoes recorded

  $ tam start
  > tamarillo started

  $ tam stop
  > tomato stopped

  $ tam interrupt
  > tomato interrupted

### Status of current tomato

  $ tam
  > tamarillo in progress
  > 24 minutes remaining

  $ tam status --prompt
  > active 24


## Future ideas

* instaweb display of tomatoes with analysis
* notification helper app for various environments
* daemon process for monitoring the current tomato
