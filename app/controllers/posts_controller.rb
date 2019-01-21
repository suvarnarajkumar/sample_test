class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  # GET /posts
  # GET /posts.json
  def index
    if [1,2].include? current_user.role
      user_ids = []
      if current_user.parent_user.present?
        user_ids << current_user.parent_user.id
        current_user.parent_user.users.each {|user| user_ids << user.id }
      else
        user_ids << current_user.id
        current_user.users.each {|user| user_ids << user.id }
      end
      @posts = if params[:term]
                  Post.where(user_id: user_ids).where('title LIKE ? OR body LIKE ?', "%#{params[:term]}%", "%#{params[:term]}%")
                else
                  Post.where(user_id: user_ids)
                end
    else
      @posts = []
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = current_user.posts.new(post_params)
    respond_to do |format|
      if @post.save
        user_emails = []
        if current_user.parent_user.present?
          user_emails << current_user.parent_user.email
          current_user.parent_user.users.each {|user| user_emails << user.email }
        else
          user_emails << current_user.email
          current_user.users.each {|user| user_emails << user.email }
        end
        TestMailer.post_email(user_emails, 'New Post created....').deliver
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        user_emails = []
        if current_user.parent_user.present?
          user_emails << current_user.parent_user.email
          current_user.parent_user.users.each {|user| user_emails << user.email }
        else
          user_emails << current_user.email
          current_user.users.each {|user| user_emails << user.email }
        end
        TestMailer.post_email(user_emails, 'Post edited, please check...').deliver
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :body, :term)
    end
end
