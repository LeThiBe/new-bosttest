class TestCasesController < ApplicationController
  before_action :load_testsuites
  before_action :find_testsuite
  before_action :load_testcases
  before_action :find_testcase, only: %i(destroy)
  before_action :find_testcase_edit, only: %i(edit)

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
    write_xml_testcase
    redirect_to edit_test_suit_path(@testsuite)
  end

  def destroy
    @testcases.delete(@testcase)
    write_xml_testcase
    redirect_to edit_test_suit_path(@testsuite)
  end

  def edit
  end

  def update
    @testcases.each do |testcase|
      if testcase["id"] == params[:id]
        testcase["name"] = params[:test_case][:name]
      end
    end
    write_xml_testcase
    redirect_to edit_test_suit_path(@testsuite)
  end

  private

  def find_testcase
    @testcase = {}
    @testcases.each do |t|
      if t["id"] == params["id"]
        @testcase = t
      end
    end
  end

  def find_testcase_edit
    @testcase = TestCase.new
    @testcases.each do |tc|
      if tc["id"] == params[:id]
        @testcase.id = tc["id"]
        @testcase.name = tc["name"]
      end
    end
  end

  def find_testsuite
    @testsuite = TestSuit.new
    @testsuits.each do |ts|
      if ts["id"] == params[:test_suit_id]
        @testsuite.id = ts["id"]
        @testsuite.name = ts["name"]
      end
    end
  end

  def write_xml_testcase
    builder = Nokogiri::XML::Builder.new(encoding: "UTF-8") do |xml|
      xml.testsuite {
        @testcases.each do |tc|
          xml.testcase{
            xml.id tc["id"]
            xml.name tc["name"]
          }
        end
      }
    end

    File.open("lib/xml/test_suite/test_suite#{@testsuite.id}.xml", "w+") do |file|
      file << builder.to_xml
    end
  end

  def load_testcases
    doc = Nokogiri::XML(File.open("lib/xml/test_suite/test_suite#{@testsuite.id}.xml", "a+"))
    @testcases = []
    doc.xpath("//testcase").each do |tc|
      obj = {}
      obj["id"] = tc.at_xpath("id").text
      obj["name"] = tc.at_xpath("name").text
      @testcases << obj
    end
  end
end
