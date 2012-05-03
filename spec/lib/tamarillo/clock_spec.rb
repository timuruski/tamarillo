require_relative '../../../lib/tamarillo/clock'
require 'timecop'

include Tamarillo

describe Clock do
  after do
    Timecop.return
  end

  it "has a start_time" do
    now = Time.new(2012,4,1,6,0,0)
    clock = Clock.new(now)
    clock.start_time.should == now
  end

  it "has a start_date" do
    now = Time.new(2012,1,1,6,0,0)
    today = Date.new(2012,1,1)
    clock = Clock.new(now)
    clock.start_date.should == today
  end

  it "has an elapsed value" do
    now = Time.new(2012,1,1,6,0,0)
    clock = Clock.new(now)
    Timecop.freeze(2012,1,1,6,0,30)

    clock.elapsed.should == 30
  end

  describe "#now" do
    it "creates an instance starting at the current time" do
      Timecop.freeze(2012,1,1,6,0,30)
      clock = Clock.now
      clock.start_time.should == Time.now
    end
  end
end
