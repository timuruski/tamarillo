# Tamarillo

A command line pomodoro/tomato timer.

Currently this will just keep track of whether you are in the middle of
a tomato. If you are it will display how much time remains. If you
complete to the tomato without being interrupted, it will log it as
completed for the day. You can also interrupt a tomato, which will
freeze it for later analysis.

It also makes it easy to includes the  current tomato status in your
prompt. Tomatoes are stored in `~/.tamarillo` by default.

[![Build Status](https://secure.travis-ci.org/timuruski/tamarillo.png)](http://travis-ci.org/timuruski/tamarillo)


## Why Tamarillo?

The tamarillo is a cousin to the tomato, which is also related to
eggplants,  potatoes and the deadly nightshade. When tomatoes were
first introduced to Europe, they were not popular because people
associated them with the deadly poisons of their cousins.

Also I wasn't clever enough to come up with Tomatillo at the time. In
any case, tamarillos are delicious if you can find them. I recommend
stewing them and then serving over vanilla ice cream; home made if you
can.


## Examples

These examples are just thought experiments, this interface has not been
implemented yet.

### Starting and stopping a tomato

```
  $ tam start
  > tamarillo started

  $ tam stop
  > tomato stopped around ~17m

  $ tam pause
  > tomato paused around ~16m

  $ tam interrupt
  > tomato interrupted around ~14m
```

### Status of current tomato

```
  $ tam status
  > ~19m # rough time only, don't sweat the seconds

  $ tam
  > ~19m

  $ tam status --full
  > active 19:21
```

### Configuration

```
$ tam config --duration=25
> tamarillo duration is 25 minutes

$ tam config --alert=growl
> tamarillo will use Growl for notifications

$ tam config --daemon ~/.tamarillo/pid
> tamarillo will monitor the current tomato from here
```


## Future ideas

* task management, tomatoes are assigned to a task
* daemon process for monitoring the current tomato
* notification helper app for various environments
* instaweb view of history
