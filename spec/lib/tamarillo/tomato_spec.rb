require 'active_support/core_ext/numeric/time'
require_relative '../../../lib/tamarillo/tomato'

include Tamarillo

describe Tomato do
  subject { Tomato.new(25.minutes, clock) }

  describe "basic attibutes" do
    let(:now) { Time.new(2012,1,1,6,0,0) }
    let(:today) { Date.new(2012,1,1) }
    let(:clock) { stub(:start_time => now, :start_date => today, :elapsed => 60) }

    its(:duration) { should == 25.minutes }
    its(:started_at) { should == now }
    its(:date) { should == today }
    its(:elapsed) { should == clock.elapsed }

    it "update the duration" do
      subject.duration = 5.minutes
      subject.duration.should == 5.minutes
    end
  end

  describe "comparison" do
    it "is the same if the start-times match" do
      clock = stub(:start_time => Time.new)
      tomato_a = Tomato.new(25.minutes, clock)
      tomato_b = Tomato.new(25.minutes, clock)

      tomato_a.should eql(tomato_b)
    end

    # FIXME This ensures two tomatoes from the same
    # time cannot co-exist, but it seems confusing
    it "is the same if the duration differs" do
      clock = stub(:start_time => Time.new)
      tomato_a = Tomato.new(10.minutes, clock)
      tomato_b = Tomato.new(20.minutes, clock)

      tomato_a.should eql(tomato_b)
    end
  end

  describe "remaining time" do
    let(:clock) { stub(:elapsed => elapsed) }
    let(:elapsed) { 0 }

    context "when no time has elapsed" do
      let(:elapsed) { 0 }
      its(:remaining) { should == 25.minutes }
    end

    context "if some time has elapsed" do
      let(:elapsed) { 10.minutes }
      its(:remaining) { should == 15.minutes }
    end

    context "when all time has elapsed" do
      let(:elapsed) { 25.minutes }
      its(:remaining) { should == 0 }
    end

    context "when excessive time has elapsed" do
      let(:elapsed) { 30.minutes }
      its(:remaining) { should == 0 }
    end

    context "when it has been interrupted" do
      before do
        subject.interrupt!
      end

      its(:remaining) { should == 0 }
    end
  end

  describe "states" do
    let(:clock) { stub(:elapsed => elapsed) }
    let(:elapsed) { 0 }

    context "when just started" do
      let(:elapsed) { 0 }
      it { should be_active }
      it { should_not be_completed }
      it { should_not be_interrupted }
    end

    context "when time remains" do
      let(:elapsed) { 15.minutes }
      it { should be_active }
      it { should_not be_completed }
      it { should_not be_interrupted }
    end

    context "when time has elapsed" do
      let(:elapsed) { 25.minutes }
      it { should_not be_active }
      it { should be_completed }
      it { should_not be_interrupted }
    end

    context "when it has been interrupted" do
      before do
        subject.interrupt!
      end

      it { should be_interrupted }
      it { should_not be_completed }
    end

  end

  # it "can be distracted" ??
  
end
