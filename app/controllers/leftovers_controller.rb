class LeftoversController < ApplicationController
  include TagHandling

  before_action :authenticate_user!
  before_action -> { ensure_turbo_frame(leftovers_path) }, only: [:new, :edit]
  before_action :load_leftover, only: %i[edit update destroy]

  def new
    @leftover = Leftover.build
  end

  def create
    @new_leftover = current_user.leftovers.build(leftover_params)

    if @new_leftover.save
      @another = params.has_key?(:another)
      @leftover = Leftover.build

      load_tags
    else
      @leftover = @new_leftover
      render :new
    end
  end

  def edit
  end

  def update
    if !@leftover.update(leftover_params)
      render :edit
    end
  end

  def destroy
    return redirect_to action: :index unless @leftover
    @leftover.destroy
  end

  def lozenge_style
    colour = params.require(:colour)
    @leftover = Leftover.new(colour:)
  end

  private

  def load_leftover
    @leftover = current_user.leftovers.find_by(id: params[:id])
  end

  def leftover_params
    params.require(:leftover).permit([
      :name,
      :colour
    ])
  end
end
