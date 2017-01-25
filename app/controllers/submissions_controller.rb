class SubmissionsController < ApplicationController
    require 'aws-sdk'
    require "bunny"
    require "json"
    def create
        @contest = Contest.find(params[:contest_id])
        Aws.config.update(
          endpoint: 'http://localhost:9000',
          access_key_id: 'S7YWWOUANA5KR0P0DHHP',
          secret_access_key: 'flaAh+VZrSEXwxnmtSZpLSAgTCRn183vivWmhOsn',
          force_path_style: true,
          region: 'us-east-1'
        )

        s3 = Aws::S3::Resource.new(region:'us-east-1')
        obj = s3.bucket('submissions').object(params[:submission][:BinUri].original_filename)
        obj.upload_file(params[:submission][:BinUri].open, acl:'public-read')
        @BinUri_url = obj.public_url
        obj = s3.bucket('submissions').object(params[:submission][:RootfsUri].original_filename)
        obj.upload_file(params[:submission][:RootfsUri].open, acl:'public-read')
        @Rootfs_url = obj.public_url

        @submission = @contest.submissions.create(BinUri: @BinUri_url, RootfsUri: @Rootfs_url)

        # my_hash = {
        #     :BinUri => @submission.BinUri_url, 
        #     :RootfsUri => @submission.BinUri_url,
        #     :Timeout => 1000,
        #     :MemLimit => 3000,
        #     :Command => ['run'],
        #     :Stdin => "5\n10"
        # } 

        if @submission.save
            redirect_to contest_path(@contest), success: 'File successfully uploaded'
        else
            flash.now[:notice] = 'There was an error'
            render :show
        end
    end
end
