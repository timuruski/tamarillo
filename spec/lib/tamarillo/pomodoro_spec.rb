require 'active_support/core_ext/numeric/time'
require 'timecop'

require_relative '../../../lib/tamarillo/pomodoro'
include Tamarillo

describe Tamarillo::Pomodoro do
  before :all do
    Timecop.freeze
  end

  after :all do
    Timecop.return
  end

  subject { Pomodoro.new(25.minutes) }

  describe "basic attibutes" do
    its(:duration) { should == 25.minutes }
    its(:started_at) { should == Time.now }
    its(:date) { should == Date.today }
    its(:state) { should == Pomodoro::States::ACTIVE }
  end

  describe "remaining time" do
    let!(:pomodoro) { Pomodoro.new(25.minutes) }

    it "works if no time has elapsed" do
      pomodoro.remaining.should == 25.minutes
    end

    it "works if time has elapsed" do
      Timecop.travel(10.minutes)
      pomodoro.remaining.should == 15.minutes
    end

    it "works if all time has elapsed" do
      Timecop.travel(25.minutes)
      pomodoro.remaining.should == 0
    end

    it "works if more time has elapsed" do
      Timecop.travel(30.minutes)
      pomodoro.remaining.should == 0
    end
  end

  describe "states" do
    it "is active when time remains" do
      pomodoro = Pomodoro.new(25.minutes)
      Timecop.travel(10.minutes)
      pomodoro.state.should == Pomodoro::States::ACTIVE
    end

    it "is completed when time has elapsed" do
      pomodoro = Pomodoro.new(25.minutes)
      Timecop.travel(25.minutes)
      pomodoro.state.should == Pomodoro::States::COMPLETED
    end

    it "is interrupted when interrupted" do
      pomodoro = Pomodoro.new(25.minutes)
      pomodoro.interrupt!
      pomodoro.state.should == Pomodoro::States::INTERRUPTED
    end

  end

  # it "is active when the remaining time is > 0"
  # it "can be completed"
  # it "can be on-break"
  # it "can be distracted"
  # it "can be interrupted"
  
end
