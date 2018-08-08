class TestCasesController < ApplicationController
  before_action :load_testcases
  def new
    @testcase = TestCase.new
  end

  def create
    @max_id = 0;
    @testcases.each do |testcase|
      if @max_id < testcase["id"].to_i
        @max_id = testcase["id"].to_i
      end
    end

    obj_new = {}
    obj_new["id"] = (@max_id + 1).to_s
    obj_new["name"] = params[:test_case][:name]

    @testcases << obj_new

    builder = Nokogiri::XML::Builder.new(encoding: "UTF-8") do |xml|
      xml.testsuite {
        @testcases.each do |ts|
          xml.testcase{
            xml.id ts["id"]
            xml.name ts["name"]
          }
        end
      }
    end

    File.open("lib/xml/test_suite/test_suite#{params[:id]}.xml", "a+") do |file|
      file << builder.to_xml
    end
  end

  def load_testcases
    doc = Nokogiri::XML(File.open("lib/xml/test_suite/test_suite#{params[:id]}.xml", "a+"))
    @testcases = []
    doc.xpath("//testcase").each do |tc|
      obj = {}
      obj["id"] = tc.at_xpath("id").text
      obj["name"] = tc.at_xpath("name").text
      @testcases << obj
    end
  end
end
