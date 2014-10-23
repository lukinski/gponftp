require 'spec_helper'

require_relative '../../lib/database_connector'

describe DatabaseConnector do
  it "responds to instance method" do
    expect(DatabaseConnector).to respond_to(:instance)
  end

  its "instance is Singleton" do
    expect(DatabaseConnector.instance).to be_a Singleton
  end
end
