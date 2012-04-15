require 'active_support/core_ext/numeric/time'
require 'timecop'

require_relative '../../../lib/tamarillo/pomodoro'

describe Tamarillo::Pomodoro do

  subject { Tamarillo::Pomodoro.new(25.minutes) }

  its(:duration) { should == 25.minutes }

  describe "remaining time" do
    before :all do
      Timecop.freeze
    end

    after :all do
      Timecop.return
    end

    let!(:pomodoro) { Tamarillo::Pomodoro.new(25.minutes) }

    it "can calculate the remainging time" do
      pomodoro.remaining.should == 25.minutes
    end

    it "can calculate the remainging time" do
      Timecop.travel(Time.now + 10.minutes)
      pomodoro.remaining.should == 15.minutes
    end

    it "can calculate the remainging time" do
      Timecop.travel(Time.now + 25.minutes)
      pomodoro.remaining.should == 0
    end

    it "can calculate the remainging time" do
      Timecop.travel(Time.now + 30.minutes)
      pomodoro.remaining.should == 0
    end
  end

  # it "is active then the remaining time is > 0"
  # it "can be completed"
  # it "can be on-break"
  # it "can be distracted"
  # it "can be interrupted"
  
end
