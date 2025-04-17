require "spec_helper"

RSpec.describe Verse::Shrine::Config do

  context "s3 adapter" do
    let(:config_s3) do
      {
        storages:
          [{
          name: "default",
          adapter: "s3",
          config: {
            bucket: "bucket",
            access_key_id: "access_key_id",
            secret_access_key: "secret_access_key",
            public: true,
            region: "region",
            prefix: "prefix",
            endpoint: "endpoint"
          }
        }]
      }
    end

    let(:bad_config_s3) do
      {
        storages:
        [{
          name: "default",
          adapter: "s3",
          config: {
            bucket: "bucket",
            access_key_id: "access_key_id",
            # missing fields
          }
        }]
      }
    end

    it "validates the config" do
      expect(
        Verse::Shrine::Config::Schema.validate(config_s3)
      ).to be_success
    end

    it "fails if config is not right" do
      expect(
        Verse::Shrine::Config::Schema.validate(bad_config_s3)
      ).to be_fail
    end
  end

  context "file system adapter" do
    let(:config_file_system) do
      {
        storages: [
          {
            name: "default",
            adapter: "file_system",
            config: {
              path: "/tmp"
            }
          }
        ]
      }
    end

    let(:bad_config_file_system) do
      {
        storages: [
          {
            name: "default",
            adapter: "file_system",
            config: {
              # missing fields
            }
          }
        ]
      }
    end

    it "validates the config" do
      expect(
        Verse::Shrine::Config::Schema.validate(config_file_system)
      ).to be_success
    end

    it "fails if config is not right" do
      expect(
        Verse::Shrine::Config::Schema.validate(bad_config_file_system)
      ).to be_fail
    end

  end
end