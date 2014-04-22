require 'sitemap_generator'
require 'aws-sdk'

namespace :sitemap do
  task g: :environment do
    SitemapGenerator::Sitemap.default_host = "#{Rails.application.config.knoda_web_url}"
    SitemapGenerator::Sitemap.public_path = 'tmp/'
    SitemapGenerator::Sitemap.create do
      Prediction.where('group_id is null').each do |p|
        add "/predictions/#{p.id}", :changefreq => 'daily'
      end
    end
    if ENV['S3_BUCKET_NAME']
      AWS.config(
        :access_key_id => ENV['AWS_ACCESS_KEY_ID'], 
        :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
      )
      bucket_name = ENV['S3_BUCKET_NAME']
      file_name = 'tmp/sitemap.xml.gz'
      s3 = AWS::S3.new
      key = 'sitemaps/' + File.basename(file_name)
      s3.buckets[bucket_name].objects[key].write(:file => file_name)
      puts "Uploading file #{file_name} to bucket #{bucket_name}."
    end
    #SitemapGenerator::Sitemap.ping_search_engines
  end
end
