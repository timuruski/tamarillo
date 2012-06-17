require_relative '../../../lib/tamarillo/monitor'

describe Tamarillo::Monitor do
  let(:tomato) do
    tomato = double('tomato')
    tomato.stub(:completed?).and_return(false, true)
    tomato
  end

  let(:notifier) do
    notifier = double('notifier')
    notifier.should_receive(:call)
    notifier
  end

  # XXX This test relies on system time passing,
  # so it's unfortunately slow.
  subject { Tamarillo::Monitor.new(tomato, notifier) }

  # as a result it is horrible.
  it "watches a tomato for completion" do
    pending "not sure how to test when forking"
    subject.start
    sleep 0.1
  end
end

