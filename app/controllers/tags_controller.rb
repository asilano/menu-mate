class TagsController < ApplicationController
  include TagHandling

  before_action :authenticate_user!
  before_action -> { ensure_turbo_frame(tags_path) }, only: [:new, :edit]
  before_action :load_tag, only: %i[edit update destroy]
  before_action :load_tags, only: :index

  def index
  end

  def new
    @tag = Tag.build
  end

  def create
    @new_tag = current_user.tags.build(tag_params)

    if @new_tag.save
      @another = params.has_key?(:another)
      @tag = Tag.build

      load_tags
    else
      @tag = @new_tag
      render :new
    end
  end

  def edit
  end

  def update
    if !@tag.update(tag_params)
      render :edit
    end
  end

  def destroy
    return redirect_to action: :index unless @tag
    @tag.destroy
  end

  def lozenge_style
    colour = params.require(:colour)
    @tag = Tag.new(colour:)
  end

  private

  def load_tag
    @tag = current_user.tags.find_by(id: params[:id])
  end

  def tag_params
    params.require(:tag).permit([
      :name,
      :colour
    ])
  end
end
