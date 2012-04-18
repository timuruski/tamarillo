require 'active_support/core_ext/numeric/time'
require_relative '../../../lib/tamarillo/tomato'

include Tamarillo

describe Tomato do
  subject { Tomato.new(25.minutes, clock) }

  describe "basic attibutes" do
    let(:now) { Time.new(2012,1,1,6,0,0) }
    let(:today) { Date.new(2012,1,1) }
    let(:clock) { stub(:start_time => now, :start_date => today) }

    its(:duration) { should == 25.minutes }
    its(:started_at) { should == now }
    its(:date) { should == today }
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
