require "find"
require "aws-sdk"
require "uglifier"

class CDNUpload

  attr_accessor :key_append, :bucket_name, :expire_time


  def initialize(key_append = nil)
    @expire_time = 1
    path = (File.expand_path("..", __FILE__)).gsub("/lib", "") + "/config.yml"
    config_file = YAML::load(File.open(path))
    @bucket_name = config_file["aws_cdn_bucket"]
    if key_append == nil
      @key_append = "trivia-".concat(Time.now.to_i.to_s)
    else
      @key_append = key_append
    end
  end


  def write_config
    path = (File.expand_path("..", __FILE__)).gsub("/lib", "") + "/config.yml"
    config_file = YAML::load(File.open(path))
    config_file["cdn_dir"] = config_file["base_cdn"] + @key_append
    FileUtils.chmod 0777, path
    file = File.new(path, "w")
    file.write(config_file.to_yaml.to_s)
    file.close
  end

  def post_to_cdn
    path = (File.expand_path("..", __FILE__)).gsub("/lib", "") + "/config.yml"
    config_file = YAML::load(File.open(path))
    s3 = AWS::S3.new(:access_key_id => config_file["aws_key"], :secret_access_key => config_file["aws_secret"])
    bucket = s3.buckets[@bucket_name]
    path = (File.expand_path("..", __FILE__)).gsub("/lib", "") + "/public/"
    Find.find(path) do |item|
      if !File.directory?(item) && File.basename(item.to_s)[0] != "."
        key = item.gsub(path, "")
        full_key = @key_append + "/" + key
        obj = bucket.objects[full_key]
        obj.write(:file => Pathname.new(item), :acl => :public_read)
      end
    end
  end

  def delete_old_from_cdn
    path = (File.expand_path("..", __FILE__)).gsub("/lib", "") + "/config.yml"
    config_file = YAML::load(File.open(path))
    s3 = AWS::S3.new(:access_key_id => "AKIAIHT4SOZ6Y3X2524Q", :secret_access_key => "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")
    bucket = s3.buckets[@bucket_name]
    bucket.objects.each do |obj|
      if !obj.key.start_with?(@key_append)
        obj.delete
      end
    end
  end
end