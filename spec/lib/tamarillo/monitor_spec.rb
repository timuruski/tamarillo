require_relative '../../../lib/tamarillo/monitor'

describe Tamarillo::Monitor do
  def completed!
    @completed = true
  end

  def completed?
    @completed
  end

  subject { Tamarillo::Monitor.new(tomato) { completed! } }

  let(:tomato) do
    values = [true, false]
    t = double('tomato')
    t.stub(:completed?) { values.pop }
    t
  end

  # XXX This test is intentionally slow, 
  # as a result it is horrible.
  it "watches a tomato for completion" do
    subject.start
    sleep 0.1
    completed?.should be_true
  end
end

