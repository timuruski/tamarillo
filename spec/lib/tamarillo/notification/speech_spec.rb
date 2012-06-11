require_relative '../../../../lib/tamarillo/notification/speech'

describe Tamarillo::Notification::Speech do
  subject { Tamarillo::Notification::Speech.new }
  it { should respond_to(:call) }
  # specify { subject.call }
end
