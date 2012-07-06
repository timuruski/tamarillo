require 'tamarillo/config2'

describe Tamarillo::Config2 do
  # it { should be }

  describe "#attributes" do
    subject { Tamarillo::Config2.new(config_path) }
    let(:attributes) { subject.attributes }

    context "clean slate" do
      before do
        File.delete(config_path) if File.exist?(config_path)
      end

      after do
        File.delete(config_path) if File.exist?(config_path)
      end

      let(:config_path) { Pathname.new('spec/support/invalid_path') }

      specify { attributes['duration'].should == (25 * 60) }
      specify { attributes['notifier'].should == 'bell' }
    end

    context "existing config file" do
      let(:config_path) { Pathname.new('spec/support/sample_config.json') }

      specify { attributes['duration'].should == (9 * 60) }
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

      specify { attributes['duration'].should == (25 * 60) }
      specify { attributes['notifier'].should == 'bell' }
    end

  end
end
