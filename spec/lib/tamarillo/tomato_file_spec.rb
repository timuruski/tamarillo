require_relative '../../../lib/tamarillo/tomato_file'

describe Tamarillo::TomatoFile do
  # FIXME Timezones will change when running test, argh
  let(:now) { Time.new(2011,1,1, 6,0,0) }
  let(:today) { Date.new(2011,1,1) }
  let(:tomato) { stub(:started_at => now, :date => today, :state => :active) }

  subject { Tamarillo::TomatoFile.new(tomato) }

  its(:name) { should == '20110101060000' }
  its(:content) { should == <<-EOS.chomp }
2011-01-01 06:00:00 -0700
Some task I'm working on
active
EOS
end
