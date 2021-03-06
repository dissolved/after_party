require "spec_helper"
require "rake"
require "fileutils"

describe "rake after_party:status" do
  include FileUtils

  before(:all) do
    AfterParty::Application.load_tasks

    FILE_PATH = File.join(Rails.root, "spec/fixtures/tasks/deployment/")
    silence_warnings do
      AfterParty::TaskRecorder::FILE_MASK = File.join(FILE_PATH, "/*.rake")
    end
  end

  context "When some tasks have been completed" do

    before(:all) do
      a = create :task_record, :version => "20120205141454"
      b = create :task_record, :version => "20130207948264"
    end

    after(:all) do
      AfterParty::TaskRecord.delete_all
    end

    it "should STDOUT a table with all tasks and their status" do
      expected_output = <<-EOF
Status   Task ID         Task Name
--------------------------------------------------
  up     20120205141454  M three
 down    20130205176456  Z first
  up     20130207948264  A second2
      EOF
      expect { Rake::Task["after_party:status"].invoke }.to output(/#{expected_output}/).to_stdout
    end
  end
end
