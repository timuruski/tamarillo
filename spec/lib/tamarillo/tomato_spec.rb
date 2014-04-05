require 'tamarillo/tomato'
require 'support/time_helpers'

include Tamarillo

describe Tomato do
  include TimeHelpers

  let(:now) { Time.new(2012,1,1,6,0,0) }
  let(:clock) { stub(now: now) }
  subject { Tomato.new(now, minutes(25), clock) }

  describe "basic attibutes" do
    let(:clock) { stub(now: now + minutes(5)) }

    its(:duration) { should == minutes(25) }
    its(:started_at) { should == now }
    its(:date) { should == Date.new(2012,1,1) }
    its(:elapsed) { should == minutes(5) }

    it "update the duration" do
      subject.duration = minutes(5)
      subject.duration.should == minutes(5)
    end
  end

  describe "comparison" do
    it "is the same if the start-times match" do
      time_a = Time.new(2012,1,1,6,0,0)
      time_b = Time.new(2012,1,1,6,0,0)

      tomato_a = Tomato.new(time_a, minutes(25))
      tomato_b = Tomato.new(time_b, minutes(25))

      tomato_a.should eql(tomato_b)
    end

    it "is not the same if the duration differs" do
      time_a = Time.new(2012,1,1,6,0,0)
      time_b = Time.new(2012,1,1,6,0,0)

      tomato_a = Tomato.new(time_a, minutes(15))
      tomato_b = Tomato.new(time_b, minutes(25))

      tomato_a.should_not eql(tomato_b)
    end

    it "can order tomatoes correctly" do
      time_a = Time.new(2012,1,1,6,0,0)
      time_b = Time.new(2012,1,1,7,0,0)
      time_c = Time.new(2012,1,1,8,0,0)

      tomato_a = Tomato.new(time_a, minutes(10))
      tomato_b = Tomato.new(time_b, minutes(10))
      tomato_c = Tomato.new(time_c, minutes(10))

      tomato_a.should < tomato_b
      tomato_c.should > tomato_b
    end
  end

  describe "remaining time" do
    let(:clock) { stub(now: now + elapsed) }
    let(:elapsed) { 0 }

    context "when no time has elapsed" do
      let(:elapsed) { 0 }
      its(:remaining) { should == minutes(25) }
    end

    context "if some time has elapsed" do
      let(:elapsed) { minutes(10) }
      its(:remaining) { should == minutes(15) }
    end

    context "when all time has elapsed" do
      let(:elapsed) { minutes(25) }
      its(:remaining) { should == 0 }
    end

    context "when excessive time has elapsed" do
      let(:elapsed) { minutes(30) }
      its(:remaining) { should == 0 }
    end

    context "when it has been interrupted" do
      before do
        subject.interrupt!
      end

      its(:remaining) { should == minutes(25) }
    end

  end

  describe "approximate time remaining" do
    let(:clock) { stub(now: now + elapsed) }
    subject { Tomato.new(now, minutes(10), clock) }

    context "when more than 30 seconds between minutes" do
      let(:elapsed) { minutes(5) + seconds(10) }
      its(:approx_minutes_remaining) { should == 5 }
    end

    context "when less than 30 seconds between minutes" do
      let(:elapsed) { minutes(5) + seconds(50) }
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
      let(:elapsed) { minutes(15) }
      it { should be_active }
      it { should_not be_completed }
      it { should_not be_interrupted }
    end

    context "when time has elapsed" do
      let(:elapsed) { minutes(25) }
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
    specify { subject.dump['duration'].should == minutes(25) }
    specify { subject.dump['started_at'].should == now }
    specify { subject.dump['interrupted'].should == false }
  end

  describe ".restore" do
    context "with good attributes" do
      let(:attrs) { { 'duration' => minutes(25), 'started_at' => now, 'interrupted' => true } }
      subject { Tomato.restore(attrs, clock) }

      its(:duration) { should == minutes(25) }
      its(:started_at) { should == now }
      its(:state) { should == Tomato::States::INTERRUPTED }
    end

    context "with bad attributes" do
      it "raises an error" do
        expect {
          Tomato.restore({})
        }.to raise_error(Tamarillo::TomatoNotValid)
      end
    end

    context "with a dumped tomato" do
      let(:attrs) { subject.dump }

      it "yields the equivalent tomato" do
        subject.should == Tomato.restore(attrs, clock)
      end
    end
  end

end
