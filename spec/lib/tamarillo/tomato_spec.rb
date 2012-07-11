require 'active_support/core_ext/numeric/time'
require 'tamarillo/tomato'

include Tamarillo

describe Tomato do
  let(:now) { Time.new(2012,1,1,6,0,0) }
  let(:clock) { stub(now: now) }
  subject { Tomato.new(now, 25.minutes, clock) }

  describe "basic attibutes" do
    let(:clock) { stub(now: now + 5.minutes) }

    its(:duration) { should == 25.minutes }
    its(:started_at) { should == now }
    its(:date) { should == Date.new(2012,1,1) }
    its(:elapsed) { should == 5.minutes }

    it "update the duration" do
      subject.duration = 5.minutes
      subject.duration.should == 5.minutes
    end
  end

  describe "comparison" do
    it "is the same if the start-times match" do
      time_a = Time.new(2012,1,1,6,0,0)
      time_b = Time.new(2012,1,1,6,0,0)

      tomato_a = Tomato.new(time_a, 25.minutes)
      tomato_b = Tomato.new(time_b, 25.minutes)

      tomato_a.should eql(tomato_b)
    end

    it "is not the same if the duration differs" do
      time_a = Time.new(2012,1,1,6,0,0)
      time_b = Time.new(2012,1,1,6,0,0)

      tomato_a = Tomato.new(time_a, 15.minutes)
      tomato_b = Tomato.new(time_b, 25.minutes)

      tomato_a.should_not eql(tomato_b)
    end
  end

  describe "remaining time" do
    let(:clock) { stub(now: now + elapsed) }
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

      its(:remaining) { should == 25.minutes }
    end

  end

  describe "approximate time remaining" do
    let(:clock) { stub(now: now + elapsed) }
    subject { Tomato.new(now, 10.minutes, clock) }

    context "when more than 30 seconds between minutes" do
      let(:elapsed) { 5.minutes + 10.seconds }
      its(:approx_minutes_remaining) { should == 5 }
    end

    context "when less than 30 seconds between minutes" do
      let(:elapsed) { 5.minutes + 50.seconds }
      its(:approx_minutes_remaining) { should == 4 }
    end
  end

  describe "states" do
    let(:clock) { stub(now: now + elapsed) }
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

  describe "#dump" do
    specify { subject.dump['duration'].should == 25.minutes }
    specify { subject.dump['started_at'].should == now }
    specify { subject.dump['interrupted'].should == false }
  end

  describe ".restore" do
    context "with good params" do
      let(:params) { { 'duration' => 25.minutes, 'started_at' => now, 'interrupted' => true } }
      subject { Tomato.restore(params, clock) }

      its(:duration) { should == 25.minutes }
      its(:started_at) { should == now }
      its(:state) { should == Tomato::States::INTERRUPTED }
    end
  end

end
