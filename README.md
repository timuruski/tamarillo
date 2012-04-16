# Tamarillo

A command line pomodoro/tomato timer.

Currently this will just keep track of whether you are in the middle of
a tomato or not. If you are it will display how much time remains. If
you complete to the tomato without being interrupted, it will log it as
completed for the day. If you interrupt the tomato it will prompt you to
start a new one.

Also provides a skinny API for putting tomato status into your shell
prompt, including status and time remaining, and number of tomatoes
completed for the day. 

Your tomatoes are stored in the `.tamarillo` user directory.


## Why Tamarillo?

The tamarillo is a cousin to the tomato, which is also related to
eggplants and potatoes and the deadly nightshade. When tomatoes were
first introduced to europe, they were not popular because people
associated them with the deadly poisons of their cousins.

In any case, tamarillos are delicious if you can find them.


## Examples

These examples are just thought experiments, this interface has not yet
been implemented.

### Configuration

```
$ tam config duration 25m
> tamarillo duration is 25 minutes

$ tam config alert growl
> tamarillo will use Growl for notifications

$ tam config daemon ~/.tamarillo/pid
> tamarillo will monitor the current tomato from here
```

### Starting a tomato

```
  $ tam
  > no tomatoes in progress
  > no tomatoes recorded

  $ tam start
  > tamarillo started

  $ tam stop
  > tomato stopped

  $ tam interrupt
  > tomato interrupted
```

### Status of current tomato

```
  $ tam
  > tamarillo in progress
  > 24 minutes remaining

  $ tam status --prompt
  > active 24
```


## Future ideas

* task management, tomatoes per task
* instaweb view of history
* notification helper app for various environments
* daemon process for monitoring the current tomato
