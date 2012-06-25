# Tamarillo

A command line [pomodoro/tomato](http://www.pomodorotechnique.com/) timer.

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

### Starting and stopping a tomato

```
  $ tam start
  > Pomodoro started, about 25 minutes.

  $ tam stop
  > Pomorodo stopped, around 17 minutes.
```

### Status of current tomato

```
  $ tam status
  > About 19 minutes.

  $ tam status --prompt
  > 19:21 1161 1500
```

### Configuration

```
  $ tam config
  > --
  > duration: 25
  > notifier: bell

  $ tam config duration=10
  > --
  > duration: 10
  > notifier: bell

  $ tam config notifier=growl
  > --
  > duration: 10
  > notifier: growl
```


## Future ideas

* task management, tomatoes are assigned to a task
* instaweb view of history
* helpers for shell and prompt integration
