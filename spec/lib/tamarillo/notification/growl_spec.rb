require_relative '../../../../lib/tamarillo/notification/growl'

describe Tamarillo::Notification::Growl do
  subject { Tamarillo::Notification::Growl.new }
  it { should respond_to(:call) }
  # specify { subject.call }
end
