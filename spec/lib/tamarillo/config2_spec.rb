require 'tamarillo/config2'

describe Tamarillo::Config2 do
  # it { should be }

  describe "#attributes" do
    let(:attributes) { subject.attributes }
    let(:config_path) { Pathname.new('spec/support/sample_config.json') }

    subject { Tamarillo::Config2.new(config_path) }

    context "clean slate" do
      before do
        File.delete(config_path) if File.exist?(config_path)
      end

      after do
        File.delete(config_path) if File.exist?(config_path)
      end

      let(:config_path) { Pathname.new('spec/support/invalid_path') }

      specify { attributes['duration'].should == 25 }
      specify { attributes['notifier'].should == 'bell' }
    end

    context "existing config file" do
      let(:config_path) { Pathname.new('spec/support/sample_config.json') }

      specify { attributes['duration'].should == 9 }
      specify { attributes['notifier'].should == 'growl' }
    end

    context "empty config file" do
      before do
        File.open(config_path, 'w') do; end
      end

      after do
        File.delete(config_path) if File.exist?(config_path)
      end

      let(:config_path) { Pathname.new('spec/support/empty_file') }

      specify { attributes['duration'].should == 25 }
      specify { attributes['notifier'].should == 'bell' }
    end

    describe "default injection" do
      it "injects missing duration" do
        subject.attributes = { 'notifier' => 'growl' }
        subject.attributes['duration'].should == 25
      end

      it "injects missing notifier" do
        subject.attributes = { 'duration' => 10 }
        subject.attributes['notifier'].should == 'bell'
      end

      it "injects invalid duration" do
        subject.attributes = { 'duration' => 'invalid' }
        subject.attributes['duration'].should == 25
      end
    end

    describe "attribute coercion" do
      it "coerces the duration field into an integer" do
        subject.attributes = { 'duration' => '10' }
        subject.attributes['duration'].should == 10
      end

      it "coerces the notifier field into a string" do
        subject.attributes = { 'notifier' => :bell }
        subject.attributes['notifier'].should == 'bell'
      end
    end

  end
end
