class SubmissionsController < ApplicationController
    require 'aws-sdk'
    require "bunny"
    require "json"
    def create
        @contest = Contest.find(params[:contest_id])
        @submission = @contest.submissions.create(submission_params)
        # 

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

        @submission[:BinUri] = @BinUri_url
        @submission[:RootfsUri] = @RootfsUri

        # # @submission = @contest.submissions.new(
        # #     submission_id: params[:submission][:Submission_id],
        # #     submitter: params[:submission][:submitter],
        # #     BinUri: @BinUri_url, 
        # #     RootfsUri: @Rootfs_url,
        # #     created_at: params[:submission][:created_at],
        # #     updated_at: params[:submission][:updated_at]
        # #     )
        
        @my_hash = {
            :BinUri => @submission.BinUri, 
            :RootfsUri => @submission.BinUri,
            :Timeout => @contest.Timeout,
            :MemLimit => @contest.MemLimit,
            :Command => @contest.Command.split(","),
            :Stdin => @contest.Stdin
        } 

        @msg = JSON.generate(@my_hash)
        conn = Bunny.new(:automatically_recover => false)
        conn.start
        ch   = conn.create_channel
        q    = ch.queue("task_queue", :durable => true)
        q.publish(@msg, :persistent => true)
        conn.close
        redirect_to contest_path(@contest)
    end

    private
    def submission_params
      params.require(:submission).permit(:submitter, :BinUri, :RootfsUri)
    end





        # if @submission.save
        #     redirect_to contest_path(@contest), success: 'File successfully uploaded'
        # else
        #     flash.now[:notice] = 'There was an error'
        #     render :show
        # end


    # end
end
