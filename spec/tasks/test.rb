require 'spec/spec_helper'

describe TestParse
  it 'should not have an empty data' do
    dataParser = Parser.new
    data = dataParser.parse
    expect(data).to.not eq('')
  end
end
