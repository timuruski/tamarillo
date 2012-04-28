require 'active_support/core_ext/numeric/time'
require_relative '../../../lib/tamarillo/config'

describe Tamarillo::Config do
  let(:default_duration) { Tamarillo::Config::DEFAULT_DURATION_IN_MINUTES }

  describe "empty config" do
    subject { Tamarillo::Config.new }
    its(:duration_in_minutes) { should == default_duration }
    its(:duration_in_seconds) { should == default_duration * 60 }
  end

  describe "duration_in_minutes" do
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

  describe "duration_in_seconds" do
    it "converts the duration in minutes into seconds" do
      config = Tamarillo::Config.new(duration_in_minutes: 15)
      config.duration_in_seconds.should == 15 * 60
    end
  end

  describe "read from YAML" do
    it "can read the duration from YAML" do
      config_path = Pathname.new('spec/support/sample-config.yml')
      config = Tamarillo::Config.load(config_path)
      config.duration_in_seconds.should == 30 * 60
    end

    it "uses the default duration if the YAML is malformed" do
      config_path = Pathname.new('spec/support/invalid-config.yml')
      config = Tamarillo::Config.load(config_path)
      config.duration_in_seconds.should == default_duration * 60
    end

    it "creates a default config when path is missing" do
      config_path = Pathname.new('some/invalid/path')
      config = Tamarillo::Config.load(config_path)
      config.duration_in_seconds.should == default_duration * 60
    end
  end

  describe "write to YAML" do
    it "can be written to YAML"
  end
end
