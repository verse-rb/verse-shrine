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

  let(:file) { File.open("./spec/spec_data/verse.txt") }

  describe "uploading a file" do
    it "uploads a file" do
      Verse::Plugin[:shrine].with_storage do |storage|
        output = storage.upload(file)

        binding.pry

        expect(File.exists?("tmp/storage/#{output.id}")).to be_truthy
      end
    end
  end
end