require_relative '../../../lib/tamarillo/controller'

describe Tamarillo::Controller do
  let(:attributes) { {} }
  let(:config) { double('config', :attributes => attributes) }
  let(:storage) { double('storage') }

  subject { Tamarillo::Controller.new(config, storage) }

  describe "#status" do
    let(:tomato) do
      stub(:remaining => 1500, :duration => 1500, :active? => true)
    end
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

    it "returns nil if no active tomato" do
      tomato.stub(:active?) { false }
      subject.status(Tamarillo::Formats::HUMAN).should == 'No pomodoro in progress.'
    end
  end

  describe "#start_new_tomato" do
    let(:attributes) { { 'duration' => 25, 'notifier' => nil } }
    before do
      # config.stub(:duration_in_seconds => 1500)
      # config.stub(:notifier => nil)
      storage.stub(:write_monitor)
      # Prevent monitor forking while testing.
      Tamarillo::Monitor.any_instance.stub(:start)
    end

    it "stores a new tomato" do
      storage.stub(:latest => nil)
      storage.should_receive(:write_tomato)

      subject.start_new_tomato
    end

    it "does nothing if a tomato is already in progress." do
      tomato = stub(:active? => true)
      storage.stub(:latest => tomato)
      storage.should_not_receive(:write_tomato)

      subject.start_new_tomato
    end

    it "uses the configured duration" do
      storage.stub(:latest => nil)
      storage.stub(:write_tomato)
      Tamarillo::Tomato.should_receive(:new).with(1500, anything)

      subject.start_new_tomato
    end

    it "uses a current clock" do
      storage.stub(:latest => nil)
      storage.stub(:write_tomato)
      Tamarillo::Clock.should_receive(:now)

      subject.start_new_tomato
    end

    it "returns the started tomato" do
      storage.stub(:latest => nil)
      storage.stub(:write_tomato)
      subject.start_new_tomato.should be_a(Tamarillo::Tomato)
    end
  end

  describe "#interrupt_current_tomato" do
    before do
      storage.stub(:read_monitor)
    end

    it "interrupts the current tomato" do
      tomato = double('tomato')
      tomato.stub(:interrupted?) { false }
      tomato.should_receive(:interrupt!)
      storage.stub(:write_tomato)
      storage.should_receive(:latest).and_return(tomato)

      subject.interrupt_current_tomato
    end

    it "doesn't raise if no tomato is present" do
      storage.should_receive(:latest).and_return(nil)
      expect { subject.interrupt_current_tomato }
        .should_not raise_error(NoMethodError)
    end

    it "returns nil if the tomato is already interrupted" do
      tomato = double('tomato')
      tomato.stub(:interrupted?) { true }
      storage.stub(:latest => tomato)
      subject.interrupt_current_tomato.should be_nil
    end

    it "writes the tomato" do
      tomato = double('tomato')
      tomato.stub(:interrupted?) { false }
      tomato.stub(:interrupt!)
      storage.stub(:latest => tomato)
      storage.should_receive(:write_tomato).with(tomato)

      subject.interrupt_current_tomato
    end

    it "returns the interrupted tomato" do
      tomato = double('tomato').as_null_object
      tomato.stub(:interrupted?) { false }
      storage.stub(:latest => tomato, :write_tomato => nil)

      subject.interrupt_current_tomato.should == tomato
    end
  end

  describe "#config" do
    it "returns the passed in config" do
      subject.config.should == config
    end
  end

  describe "#update_config" do
    before do
      config.stub(:attributes=)
      config.stub(:save)
      storage.stub(:write_config)
    end

    it "can update the duration" do
      config.should_receive(:attributes=).with({'duration' => 10})
      subject.update_config('duration' => 10)
    end

    it "writes the config" do
      config.should_receive(:save)
      subject.update_config
    end
  end
end
