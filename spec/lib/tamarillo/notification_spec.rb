require_relative '../../../lib/tamarillo/notification'

describe Tamarillo::Notification do
  subject { Tamarillo::Notification }

  describe ".valid!" do
    specify { subject.valid!(:bell).should == Tamarillo::Notification::BELL }
    specify { subject.valid!('speech').should == Tamarillo::Notification::SPEECH }
    specify { subject.valid!('Growl').should == Tamarillo::Notification::GROWL }
    specify { subject.valid!('bogus').should == Tamarillo::Notification::BELL }
  end
end
