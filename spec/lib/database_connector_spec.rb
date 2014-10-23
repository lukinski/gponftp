require 'spec_helper'

require_relative '../../lib/database_connector'

describe DatabaseConnector do
  it "responds to instance method" do
    expect(DatabaseConnector).to respond_to(:instance)
  end

  let(:db) { DatabaseConnector.instance }

  its "instance is Singleton" do
    expect(db).to be_a Singleton
  end

  it "can support MySQL database" do
    expect(db.get_connection).to be_a Mysql2::Client
  end

  describe '#execute' do
    it 'responds to execute method' do
      expect(db).to respond_to(:execute)
    end

    context 'when executing queries' do

      it 'accepts query String as parameter' do
        expect { db.execute('SELECT 1;') }.to_not raise_error
      end

      let(:result) { db.execute('SELECT 1;') }

      it 'returns proper type' do
        expect(result).to be_a Mysql2::Result
      end

      its 'records are returned as symbolized by default' do
        expect(result.first).to be_a Hash
      end
    end

  end
end
