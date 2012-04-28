require_relative '../../../lib/tamarillo/command'

describe Tamarillo::Command do
  it "has an execute command" do
    expect { subject.execute }
      .to_not raise_error
  end
end
