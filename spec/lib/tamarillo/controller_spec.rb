require_relative '../../../lib/tamarillo/controller'

describe Tamarillo::Controller do
  let(:config) { stub }
  let(:storage) { stub }

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
  end

  describe "#config" do
  end

  describe "#update_config" do
  end
end
