require File.expand_path( "config/initializer/test_helper" )
describe Component::PaymentGateway::Domain do
  it "run the test" do
    expect(1).to(eq(1))
  end

  describe ".fuzzy_match?" do
    let(:test_gateway){ Component::PaymentGateway.new(name: "abcde")}
    it("match if all consecutive character in query, is also consecutive in the string") do
      expect(test_gateway.domain.fuzzy_match?("abcd")).to(be(true))
    end
    it("does not match if any of the character in query, isnt consecutive character in the string") do
      expect(test_gateway.domain.fuzzy_match?("xbcd")).to(be(false))
    end

  end
end
