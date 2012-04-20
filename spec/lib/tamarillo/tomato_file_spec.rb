require_relative '../../../lib/tamarillo/tomato_file'

describe Tamarillo::TomatoFile do
  # FIXME Timezones will change when running test, argh
  let(:now) { Time.new(2012,1,1, 6,0,0) }
  let(:today) { Date.new(2012,1,1) }
  let(:tomato) { stub(:started_at => now, :date => today, :state => :active) }

  subject { Tamarillo::TomatoFile.new(tomato) }

  its(:name) { should == '20120101060000' }
  its(:time_line) { should == '2012-01-01 06:00:00 -0700' }
  its(:task_line) { should == 'Some task I\'m working on' }
  its(:state_line) { should == 'active' }
end
