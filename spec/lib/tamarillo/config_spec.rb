require 'active_support/core_ext/numeric/time'
require_relative '../../../lib/tamarillo/config'

describe Tamarillo::Config do
  describe "empty config" do
    subject { Tamarillo::Config.new }
    its(:duration_in_minutes) { should == 25 }
    its(:duration_in_seconds) { should == 25 * 60 }
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
    it "can be read from YAML"
  end

  describe "write to YAML" do
    it "can be written to YAML"
  end
end
