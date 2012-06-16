require_relative '../../../lib/tamarillo/notification'

include Tamarillo

describe Tamarillo::Notification do
  subject { Tamarillo::Notification }

  describe ".valid!" do
    specify { subject.valid!(:bell).should == Notification::BELL }
    specify { subject.valid!('speech').should == Notification::SPEECH }
    specify { subject.valid!('Growl').should == Notification::GROWL }
    specify { subject.valid!('bogus').should == nil }
  end

  describe ".for" do
    specify { subject.for(Notification::BELL).should be_a(Notification::Bell) }
    specify { subject.for(Notification::GROWL).should be_a(Notification::Growl) }
    specify { subject.for(Notification::SPEECH).should be_a(Notification::Speech) }
    specify { subject.for(Notification::NONE).should be_a(Notification::None) }
    specify { subject.for('bogus').should be_a(Notification::None) }
  end
end
