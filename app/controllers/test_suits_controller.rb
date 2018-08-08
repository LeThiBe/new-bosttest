class TestSuitsController < ApplicationController
  before_action :load_testsuites
  before_action :find_testsuite_edit, only: %i(edit)
  def index
  end

  def edit
    doc = Nokogiri::XML(File.open("lib/xml/test_suite/test_suite#{params[:id]}.xml", "a+"))
    @testcases = []
    doc.xpath("//testcase").each do |tc|
      obj = {}
      obj["id"] = tc.at_xpath("id").text
      obj["name"] = tc.at_xpath("name").text
      @testcases << obj
    end
  end

  def update
    count = 0
    @testsuits.each do |testsuite|
      if testsuite["id"] == params[:id]
        testsuite["name"] = params[:test_suit][:name]
        count += 1
        break
      end
    end
    if count > 0
      write_xml
      flash[:success] = "Updated successfull !!!"
      redirect_to test_suits_path
    else
      render "edit"
    end
  end

  def new
    @testsuite = TestSuit.new
  end

  def create
    @max_id = 0;
    @testsuits.each do |ts|
      if @max_id < ts["id"].to_i
        @max_id = ts["id"].to_i
      end
    end

    obj_new = {}
    obj_new["id"] = (@max_id + 1).to_s
    obj_new["name"] = params[:test_suit][:name]

    @testsuits << obj_new
    write_xml

    redirect_to test_suits_path
  end

  def destroy
    find_testsuit
    @testsuits.delete(@tam)
    write_xml
    redirect_to test_suits_path
  end

  def find_testsuit
    @tam = {}
    @testsuits.each do |t|
      if t["id"] == params[:id]
        @tam = t
      end
    end
  end

  def find_testsuite_edit
    @ts = TestSuit.new
    @testsuits.each do |t|
      if t["id"] == params[:id]
        @ts.id = t["id"]
        @ts.name = t["name"]
      end
    end
  end

  def write_xml
    builder = Nokogiri::XML::Builder.new(encoding: "UTF-8") do |xml|
      xml.testsuites {
        @testsuits.each do |ts|
          xml.testsuite{
            xml.id ts["id"]
            xml.name ts["name"]
          }
        end
      }
    end

    File.open("lib/xml/test_suites.xml", "w+") do |file|
      file << builder.to_xml
    end
  end

  def load_testsuites
    xml = Nokogiri::XML(File.open("lib/xml/test_suites.xml"))
    @testsuits = []
    xml.xpath("//testsuite").each do |ts|
      obj = {}
      obj["id"] = ts.at_xpath("id").text
      obj["name"] = ts.at_xpath("name").text
      @testsuits << obj
    end
  end

  def load_testcases
    @testcases = []
    doc.xpath("//testcase").each do |tc|
      obj = {}
      obj["id"] = tc.at_xpath("id").text
      obj["name"] = tc.at_xpath("name").text
      @testcases << obj
    end
  end

  # def load_testsuite
  #   @ts = TestSuit.find_by id: params[:id]
  #   return if @ts
  #   flash[:danger] = "Can't find testsuite"
  #   redirect_to root_url
  # end
end
