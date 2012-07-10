require 'active_support/core_ext/numeric/time'
require 'tamarillo/config'

describe Tamarillo::Config do
  let(:default_duration) { Tamarillo::Config::DEFAULT_DURATION_IN_MINUTES }

  describe "empty config" do
    subject { Tamarillo::Config.new }
    its(:duration_in_minutes) { should == default_duration }
    its(:duration_in_seconds) { should == default_duration * 60 }
    its(:notifier) { should == Tamarillo::Notification::BELL }
  end

  describe "#duration_in_minutes" do
    it "can be read" do
      config = Tamarillo::Config.new(duration_in_minutes: 15)
      config.duration_in_minutes.should == 15
    end

    it "can be assigned" do
      subject.duration_in_minutes = 10
      subject.duration_in_minutes.should == 10
    end

    it "assigns the default when value is nil" do
      subject.duration_in_minutes = nil
      subject.duration_in_minutes.should == default_duration
    end

    it "affects the duration in seconds" do
      subject.duration_in_minutes = 30
      subject.duration_in_seconds.should == 30 * 60
    end
  end

  describe "#duration" do
    it "aliases duration_in_minutes" do
      expect { subject.duration = 10 }
        .to change { subject.duration_in_minutes }
    end
  end

  describe "duration_in_seconds" do
    it "converts the duration in minutes into seconds" do
      config = Tamarillo::Config.new(duration_in_minutes: 15)
      config.duration_in_seconds.should == 15 * 60
    end
  end

  describe "#notifier" do
    it "can be read" do
      config = Tamarillo::Config.new(notifier: Tamarillo::Notification::SPEECH)
      config.notifier.should == Tamarillo::Notification::SPEECH
    end

    it "can be assigned" do
      config = Tamarillo::Config.new
      config.notifier = 'Growl'
      config.notifier.should == Tamarillo::Notification::GROWL
    end

    it "falls back to the existing value if a new value is invalid" do
      config = Tamarillo::Config.new(notifier: Tamarillo::Notification::SPEECH)
      config.notifier = 'bogus'
      config.notifier.should == Tamarillo::Notification::SPEECH
    end

    it "has a default value" do
      config = Tamarillo::Config.new
      config.notifier.should == Tamarillo::Notification::BELL
    end
  end

  describe "read from YAML" do
    let(:sample_config_path) { Pathname.new('spec/support/sample-config.yml') }
    let(:invalid_config_path) { Pathname.new('spec/support/invalid-config.yml') }

    describe "duration value" do
      it "can read the duration from YAML" do
        config = Tamarillo::Config.load(sample_config_path)
        config.duration_in_seconds.should == 30 * 60
      end

      it "uses the default duration if the YAML is malformed" do
        config = Tamarillo::Config.load(invalid_config_path)
        config.duration_in_seconds.should == default_duration * 60
      end
    end

    describe "notifier value" do
      it "can read the notifier from YAML" do
        config = Tamarillo::Config.load(sample_config_path)
        config.notifier.should == Tamarillo::Notification::GROWL
      end

      it "uses the default value if the YAML is malformed" do
        config = Tamarillo::Config.load(invalid_config_path)
        config.notifier.should == Tamarillo::Notification::BELL
      end
    end

    it "creates a default config when path is missing" do
      config_path = Pathname.new('some/invalid/path')
      config = Tamarillo::Config.load(config_path)
      config.duration_in_seconds.should == default_duration * 60
    end
  end

  describe "write to YAML" do
    before do
      FileUtils.mkdir('tmp') unless File.directory?('tmp')
    end

    it "can be written to YAML" do
      config = Tamarillo::Config.new
      config.duration_in_minutes = 5
      config.write('tmp/write-test.yml')

      File.read('tmp/write-test.yml').should include('duration: 5')
    end
  end

  describe "dumping YAML" do
    it "outputs a YAML format" do
      config = Tamarillo::Config.new
      yaml = config.to_yaml
      yaml.should == <<EOS
---
duration: 25
notifier: bell
EOS
    end
  end
end
