require 'active_support/core_ext/numeric/time'
require 'timecop'
require_relative '../../../lib/tamarillo/tomato'

include Tamarillo

describe Tamarillo::Tomato do
  let(:now) { Time.new(2012, 4, 15, 6, 0, 0) }
  let(:today) { Date.new(2012, 4, 15) }

  before do
    @subject = Tomato.new(25.minutes, now)
  end

  after do
    # FIXME This doesn't appear to affect subsequent tests.
    # Timecop.return
  end

  subject { @subject }

  describe "basic attibutes" do
    its(:duration) { should == 25.minutes }
    its(:started_at) { should == now }
    its(:date) { should == today }
  end

  describe "remaining time" do
    context "when no time has elapsed" do
      before do
        Timecop.freeze(now)
      end

      its(:remaining) { should == 25.minutes }
    end

    context "if some time has elapsed" do
      before do
        Timecop.freeze(now + 10.minutes)
      end

      its(:remaining) { should == 15.minutes }
    end

    context "when all time has elapsed" do
      before do
        Timecop.freeze(now + 25.minutes)
      end

      its(:remaining) { should == 0 }
    end

    context "when excessive time has elapsed" do
      before do
        Timecop.freeze(now + 30.minutes)
      end

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
    context "when just started" do
      before do
        Timecop.freeze(now)
      end

      it { should be_active }
      it { should_not be_completed }
      it { should_not be_interrupted }
    end

    context "when time remains" do
      before do
        Timecop.freeze(now + 15.minutes)
      end

      it { should be_active }
      it { should_not be_completed }
      it { should_not be_interrupted }
    end

    context "when time has elapsed" do
      before do
        Timecop.freeze(now + 25.minutes)
      end

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
