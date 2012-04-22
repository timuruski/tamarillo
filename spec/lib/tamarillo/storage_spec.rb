require_relative '../../../lib/tamarillo/storage'
require 'fakefs/spec_helpers'

include Tamarillo

describe Storage do
  # include FakeFS::SpecHelpers
  before :all do
    FakeFS.activate!
  end

  after :all do
    FakeFS.deactivate!
  end

  let(:now) { Time.new(2011,1,1,6,0,0) }
  let(:today) { Date.new(2011,1,1) }
  let(:storage_path) { Pathname.new('~/.tamarillo') }
  let(:tomato_path) { storage_path.join('20110101060000') }
  let(:sample_tomato) { <<EOS }
2011-01-01T06:00:00-07:00
Some task I'm working on
completed
EOS


  subject { Storage.new(storage_path) }

  it "creates the storage directory if it is missing" do
    expect { Storage.new(storage_path) }.
      to change { File.directory?(storage_path) }
  end

  describe "writing tomatoes to the filesystem" do
    it "writes files" do
      FakeFS do
        FakeFS::FileSystem.clear
        tomato = stub(:started_at => now, :state => :active)
        expect { subject.write(tomato) }.
          to change { File.exist?(tomato_path) }
      end
    end

    describe "tomato file" do
      before do
        tomato = stub(:started_at => now, :date => today, :state => :active)
        Storage.new(storage_path).write(tomato)
      end

      subject { FakeFS { File.readlines(tomato_path.to_s) } }

      specify { subject[0].should == "2011-01-01T06:00:00-07:00" }
      specify { subject[1].should == "Some task I'm working on" }
      specify { subject[2].should == 'active' }
    end
  end

  describe "reading tomatoes from the filesystem" do
    before do
      FileUtils.mkdir_p(storage_path)
      File.open(tomato_path.to_s, 'w') { |f| f << sample_tomato }
    end

    it "can read tomatoes from the filesystem" do
      tomato = subject.read(tomato_path) # should return a tomato
      tomato.should be
    end

    describe "the tomato" do
      let(:storage) { Storage.new(storage_path) }
      subject { storage.read(tomato_path) }

      its(:started_at) { should == now }
      its(:date) { should == today }
      it { should be_completed }
    end
        
  end

  # Storage layout looks like this
  # |,tamarillo
  #   |-config
  #   |-basket.sqlite
  #   |-basket
  #     |-2012
  #       |-0401
  #         |-060101
  #

  # it "can count how many tomatoes are stored"
  # it "can find tomatoes by week"
  # it "can find tomatoes by month"
  # something can group them by day and maybe task
end
