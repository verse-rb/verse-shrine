require_relative "../../spec_helper"

RSpec.describe Verse::Shrine::Plugin do
  before do
    system "mkdir -p tmp/storage"
    system "rm -r tmp/storage/*"

    Verse.start(
      :server,
      config_path: "./spec/spec_data/config.yml"
    )
  end

  after do
    Verse.stop
  end

  describe "uploading a file" do
    it "uploads and delete a file" do
      output = nil
      Verse::Plugin[:shrine].with_storage do |storage|
        file = File.open("./spec/spec_data/verse.txt")
        output = storage.upload(file)

        expect(File.exist?("tmp/storage/default/#{output.id}")).to be_truthy
      end

      Verse::Plugin[:shrine].with_storage(:other) do |storage|
        file = File.open("./spec/spec_data/verse.txt")
        output = storage.upload(file)

        expect(File.exist?("tmp/storage/other/#{output.id}")).to be_truthy

        file = storage.open(output.id)
        expect(file.read).to eq( (["This is a sample file with sample data"] * 12).join("\n") )

        storage.delete(output.id)
        expect(File.exist?("tmp/storage/other/#{output.id}")).to be_falsey
      end
    end
  end
end