require 'tamarillo/storage/file_system'
require 'fakefs/spec_helpers'
require 'active_support/core_ext/numeric/time'

include Tamarillo::Storage

# File system storage layout looks like this
# |,tamarillo
#   |-config
#   |-basket.sqlite
#   |-basket
#     |-2012
#       |-0401
#         |-060101

describe FileSystem do
  include FakeFS::SpecHelpers

  let(:time) { Time.local(2011,1,1,6,0,0) }
  let(:date) { Date.new(2011,1,1) }
  let(:config) { stub(:attributes => { 'duration' => 10.minutes }) }
  let(:storage_path) { Pathname.new( File.expand_path('tmp/tamarillo')) }
  let(:tomato_path) { storage_path.join('2011/0101/20110101060000') }
  let(:sample_tomato) { <<EOS }
#{time.iso8601}
Some task I'm working on
completed
EOS

  def create_tomato_file(time, options = {})
    folder_path = storage_path.join(time.strftime('%Y/%m%d'))
    tomato_path = folder_path.join(time.strftime('%Y%m%d%H%M%S'))
    state = options.fetch(:state) { 'completed' }

    FileUtils.mkdir_p(folder_path)
    File.open(tomato_path, 'w') { |f| f << <<EOS }
#{time.iso8601}
Some task I'm working on
#{state}
EOS

    tomato_path
  end


  subject { FileSystem.new(storage_path, config) }

  it "creates the storage directory if it is missing" do
    expect { FileSystem.new(storage_path, config) }.
      to change { File.directory?(storage_path) }
  end

  it "has a path to the storage directory" do
    subject.path.should == storage_path
  end

  describe "writing tomatoes to the filesystem" do
    it "writes files to the right place" do
      FakeFS::FileSystem.clear
      FakeFS do
        tomato = stub(:started_at => time, :state => :active)
        expect { subject.write_tomato(tomato) }.
          to change { File.exist?(tomato_path) }
      end
    end

    it "returns a path to the tomato" do
      tomato = stub(:started_at => time, :state => :active)
      path = subject.write_tomato(tomato)
      path.should == subject.path.join(tomato_path)
    end

    describe "tomato file" do
      before do
        tomato = stub(:started_at => time, :date => date, :state => :active)
        FileSystem.new(storage_path, config).write_tomato(tomato)
      end

      subject { FakeFS { File.readlines(tomato_path.to_s) } }

      specify { subject[0].should == time.iso8601}
      specify { subject[1].should == "Some task I'm working on" }
      specify { subject[2].should == 'active' }
    end
  end

  describe "reading tomatoes from the filesystem" do
    before do
      create_tomato_file(time)
    end

    it "can read tomatoes from the filesystem" do
      tomato = subject.read_tomato(tomato_path)
      tomato.should be
    end

    it "returns nil of not found" do
      tomato = subject.read_tomato('NOTHING')
      tomato.should be_nil
    end

    describe "the tomato" do
      let(:config) { stub(:attributes => { 'duration' => 10 }) }
      let(:storage) { FileSystem.new(storage_path, config) }
      subject { storage.read_tomato(tomato_path) }

      its(:started_at) { should == time }
      its(:date) { should == date }
      its(:duration) { should == 600 }
      it { should be_completed }
    end

    it "handles interrupted tomatoes" do
      create_tomato_file(time, :state => 'interrupted')
      tomato = subject.read_tomato(tomato_path)
      tomato.should be_interrupted
    end
  end

  describe "finding most recent tomato" do
    subject { FileSystem.new(storage_path, config).latest }

    context "when there are many tomatoes" do
      before do
        create_tomato_file(Date.today.to_time + 6.hours)
        create_tomato_file(Date.today.to_time + 6.hours + 15.minutes)
      end

      its(:started_at) { should == Date.today.to_time + 6.hours + 15.minutes }
    end

    context "when there are no tomatoes for the day" do
      before do
        create_tomato_file(Date.today.to_time - 1.days)
      end

      it { should be_nil }
    end
  end

  # it "can count how many tomatoes are stored"
  # it "can find tomatoes by week"
  # it "can find tomatoes by month"
  # something can group them by day and maybe task
end
