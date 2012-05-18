require_relative '../../../lib/tamarillo/controller'

describe Tamarillo::Controller do
  let(:config) { double('config') }
  let(:storage) { double('storage') }

  subject { Tamarillo::Controller.new(config, storage) }

  describe "#status" do
    let(:tomato) { stub(:remaining => 1500, :duration => 1500) }
    let(:storage) { stub(:latest => tomato) }

    it "can return a humanized format" do
      subject.status(Tamarillo::Formats::HUMAN).should == 'About 25 minutes'
    end

    it "can return a machine optimized format" do
      subject.status(Tamarillo::Formats::PROMPT).should == '25:00 1500 1500'
    end

    it "complains if the format is invalid" do
      expect { subject.status('invalid') }
        .should raise_error
    end
  end

  describe "#start_new_tomato" do
    before do
      config.stub(:duration_in_seconds => 1500)
    end

    it "stores a new tomato" do
      storage.stub(:latest => nil)
      storage.should_receive(:write)

      subject.start_new_tomato
    end

    it "does nothing if a tomato is already in progress." do
      storage.stub(:latest => stub)
      storage.should_not_receive(:write)

      subject.start_new_tomato
    end

    it "uses the configured duration" do
      storage.stub(:latest => nil)
      storage.stub(:write)
      Tamarillo::Tomato.should_receive(:new).with(1500, anything)

      subject.start_new_tomato
    end

    it "uses a current clock" do
      storage.stub(:latest => nil)
      storage.stub(:write)
      Tamarillo::Clock.should_receive(:now)

      subject.start_new_tomato
    end
  end

  describe "#interrupt_current_tomato" do
    it "interrupts the current tomato" do
      tomato = double('tomato')
      tomato.should_receive(:interrupt!)
      storage.should_receive(:latest).and_return(tomato)

      subject.interrupt_current_tomato
    end

    it "doesn't raise if no tomato is present" do
      storage.should_receive(:latest).and_return(nil)
      expect { subject.interrupt_current_tomato }
        .should_not raise_error(NoMethodError)
    end
  end

  describe "#config" do
    it "returns the passed in config" do
      subject.config.should == config
    end
  end

  describe "#update_config" do
    it "can update the duration" do
      config.should_receive(:duration=).with(10)
      subject.update_config(:duration => 10)
    end

    it "ignores bogus arguments" do
      config.should_not_receive(:foo=).with('bar')
      subject.update_config(:foo => 'bar')
    end
  end
end
