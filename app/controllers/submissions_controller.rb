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

        # @my_hash = {
        #     :BinUri => @submission.BinUri, 
        #     :RootfsUri => @submission.BinUri,
        #     :Timeout => @contest.Timeout,
        #     :MemLimit => @contest.MemLimit,
        #     :Command => @contest.Command.split(","),
        #     :Stdin => @contest.Stdin
        # } 
        render plain: @contest.inspect
        # render plain: @my_hash.inspect
        # render plain: @contest.Command.inspect

        #<Contest id: 4, name: "asdf", description: "qwer", duedate: "2017-01-25 22:39:00", created_at: "2017-01-25 22:40:39", updated_at: "2017-01-25 22:40:39", Timeout: nil, MemLimit: nil, Command: nil, Stdin: nil>

        # if @submission.save
        #     redirect_to contest_path(@contest), success: 'File successfully uploaded'
        # else
        #     flash.now[:notice] = 'There was an error'
        #     render :show
        # end
    end
end
