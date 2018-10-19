# frozen_string_literal: true

class SubmissionsController < ApplicationController
  before_action :set_submission, only: %i[destroy show]

  def create
    @submission = Submission.new(submission_params)

    if @submission.save
      redirect_to @submission, notice: 'Submission was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @submission.destroy
    redirect_to root_path, notice: 'Submission was successfully destroyed.'
  end

  def index
    @submissions = Submission.includes(:comments).includes(:community).all.reverse_order
  end

  def new
    @submission = Submission.new(community_id: params['community_id'])
  end

  def show; end

  private

  def set_submission
    @submission = Submission.includes(:root_comments => :submission)
                            .includes(:root_comments => {:replies => [:parent, :submission]})
                            .includes(:root_comments => {:replies => {:replies => [:parent, :submission]}})
                            .includes(:root_comments => {:replies => {:replies => {:replies => [:parent, :submission]}}})
                            .find(params[:id])
  end

  def submission_params
    params.require(:submission).permit(:title, :url, :community_id)
  end
end
