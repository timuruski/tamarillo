require_relative '../../../lib/tamarillo/tomato_file'
require_relative '../../../lib/tamarillo/tomato2'
require_relative '../../../lib/tamarillo/clock'

describe Tamarillo::TomatoFile do
  # FIXME Timezones will change when running test, argh
  let(:time) { Time.local(2011,1,1, 6,0,0) }
  let(:tomato) { Tamarillo::Tomato2.new(time, 25 * 60) }

  subject { Tamarillo::TomatoFile.new(tomato) }

  its(:name) { should == '20110101060000' }
  its(:path) { should == '2011/0101/20110101060000' }
  its(:content) { should == <<-EOS.chomp }
#{time.iso8601}
Some task I'm working on
completed
  EOS

  it "can write an interrupted tomato" do
    tomato.interrupt!
    subject.content.should include('interrupted')
  end

  describe ".path" do
    subject { Tamarillo::TomatoFile }
    
    specify do
      path = subject.path(Time.new(1999,12,31,11,59,59))
      path.should == '1999/1231/19991231115959' 
    end

    specify do
      path = subject.path(Time.new(2012,04,10,6,0,23))
      path.should == '2012/0410/20120410060023' 
    end
  end

end
