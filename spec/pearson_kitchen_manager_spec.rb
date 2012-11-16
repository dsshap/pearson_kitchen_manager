require 'spec_helper'

describe PearsonKitchenManager do

  before do
    ENV['PEARSON_API_KEY'] = "60e048c10b333c8dc25a6d85470ca653"
  end

  context 'basics to hit api' do 

    it "should get api key from env vars" do
      ENV['PEARSON_API_KEY'].should eq("60e048c10b333c8dc25a6d85470ca653")
    end

    # it "should connect to service" do
    #   pkm = PearsonKitchenManager.new
    #   pkm.courses.should_not
    # end

  end  

  context 'recipes' do

    it 'should get recipes' do
      pkm = PearsonKitchenManager.new
      response = pkm.recipes
      response['results'].count.should eq(10)
    end

    it 'should get a recipe' do
      pkm = PearsonKitchenManager.new
      # response = pkm.recipes

      # recipe = response['results'].first

      response = pkm.recipes(url_extension: "albufera-sauce")

      puts "response: #{response.to_json}"

    end

  end
end