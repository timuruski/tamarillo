require_relative '../../../../lib/tamarillo/notification/bell'

describe Tamarillo::Notification::Bell do
  subject { Tamarillo::Notification::Bell.new }
  it { should respond_to(:call) }
  # specify { subject.call }
end
