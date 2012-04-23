require_relative '../../../lib/tamarillo/storage'
require 'fakefs/spec_helpers'
require 'active_support/core_ext/numeric/time'

include Tamarillo

# Storage layout looks like this
# |,tamarillo
#   |-config
#   |-basket.sqlite
#   |-basket
#     |-2012
#       |-0401
#         |-060101

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
  let(:storage_path) { Pathname.new('tmp/tamarillo') }
  let(:tomato_path) { storage_path.join('20110101060000') }
  let(:sample_tomato) { <<EOS }
2011-01-01T06:00:00-07:00
Some task I'm working on
completed
EOS

  def create_tomato_file(time)
    folder_path = storage_path.join(time.strftime('%Y/%m%d'))
    tomato_path = folder_path.join(time.strftime('%Y%m%d%H%M%S'))

    FileUtils.mkdir_p(folder_path)
    File.open(tomato_path, 'w') { |f| f << <<EOS }
#{time.iso8601}
Some task I'm working on
completed
EOS
  end


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
      create_tomato_file(now)
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

  describe "finding most recent tomato" do
    context "when there are many tomatoes" do
      before do
        create_tomato_file(Date.today.to_time + 6.hours)
        create_tomato_file(Date.today.to_time + 6.hours + 15.minutes)
      end

      subject { Storage.new(storage_path).latest }
      # its(:started_at) { should == Date.today.to_time + 6.hours + 15.minutes }
    end

    context "when there are no tomatoes for the day" do
      before do
        create_tomato_file(Date.today.to_time - 2.days)
      end
      it "returns nil"
    end
  end

  # it "can count how many tomatoes are stored"
  # it "can find tomatoes by week"
  # it "can find tomatoes by month"
  # something can group them by day and maybe task
end
