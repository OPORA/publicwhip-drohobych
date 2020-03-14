class PolicyDivisionsController < ApplicationController
  before_action :set_policy_division, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [ :edit, :update, :destroy, :create]
  before_action :set_paper_trail_whodunnit
  # GET /policy_divisions
  # GET /policy_divisions.json
  def index
    @policy_divisions = PolicyDivision.all
  end

  # GET /policy_divisions/1
  # GET /policy_divisions/1.json
  def show
  end

  # GET /policy_divisions/new
  def new
    @policy_division = PolicyDivision.new
    get_policy()
    @policy = Policy.all - @policies_all
  end
  def get_policy
    @division = Division.find_by(date: params[:date], number: params[:id])
    @policies_all = Policy.joins(:policy_divisions).where("policy_divisions.division_id = ?", @division.id )
    @policies = @policies_all.page(params[:page]).per(4)
  end
  def policy()
    get_policy
  end
  # GET /policy_divisions/1/edit
  def edit
  end

  # POST /policy_divisions
  # POST /policy_divisions.json
  def create
    @policy_division = PolicyDivision.new(policy_division_params)

    respond_to do |format|
      if @policy_division.save
        format.html { redirect_to policy_path(@policy_division.policy_id), notice: 'Голосування було додано у політику' }
        format.json { render :show, status: :created, location: @policy_division }
      else
        @division = Division.find(@policy_division.division_id)
        @policy = Policy.all
        @policies = Policy.joins(:policy_divisions).where("policy_divisions.division_id = ?", @division.id ).page(params[:page]).per(4)
        format.html { render :new  }
        format.json { render json: @policy_division.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /policy_divisions/1
  # PATCH/PUT /policy_divisions/1.json
  def update
    respond_to do |format|
      if @policy_division.update(policy_division_params)
        format.html { redirect_to policy_path(@policy_division.policy_id), notice: 'Голосування в політиці оновлено' }
        format.json { render :show, status: :ok, location: @policy_division }
      else
        @division = Division.find(@policy_division.division_id)
        @policy = Policy.all
        format.html { render :edit }
        format.json { render json: @policy_division.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /policy_divisions/1
  # DELETE /policy_divisions/1.json
  def destroy
    @policy_division.destroy
    respond_to do |format|
      format.html { redirect_to policies_path, notice: 'Голосування в політиці видалено' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_policy_division
      @policy_division = PolicyDivision.find(params[:id])
      @policy = Policy.all
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def policy_division_params
      params.require(:policy_division).permit(:policy_id, :division_id, :support)
    end
end
