class PoliciesController < ApplicationController
  before_action :set_policy, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [ :new, :edit, :update, :destroy, :create]
  before_action :set_paper_trail_whodunnit

  # GET /policies
  # GET /policies.json
  def index

    @policies =  policies()
  end
  def policy
    @policies = policies()
    respond_to do |format|
      format.js
    end
  end
  # GET /policies/1
  # GET /policies/1.json
  def show
    if params[:history] == '1'
      history()
    end
  end
  def detal

  end

  # GET /policies/new
  def new
    @policy = Policy.new
    @policy.provisional = false
  end

  # GET /policies/1/edit
  def edit
  end

  # POST /policies
  # POST /policies.json
  def create
    @policy = Policy.new(policy_params)
    @policy.provisional = false
    respond_to do |format|
      if @policy.save
        format.html { redirect_to @policy, notice: ' Політика була успішно створена.' }
        format.json { render :show, status: :created, location: @policy }
      else
        format.html { render :new }
        format.json { render json: @policy.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /policies/1
  # PATCH/PUT /policies/1.json
  def update
    respond_to do |format|
      @policy.provisional = provisional? ? false : true
      if @policy.update(policy_params)

        format.html { redirect_to @policy, notice: 'Політика була успішно оновлена' }
        format.json { render :show, status: :ok, location: @policy }
      else
        format.html { render :edit }
        format.json { render json: @policy.errors, status: :unprocessable_entity }
      end
    end
  end

  def history
    @history = PaperTrail::Version.where(policy_id: params[:id]).order(created_at: :desc ).page(params[:page]).per(4)
  end

  # DELETE /policies/1
  # DELETE /policies/1.json
  def destroy
    #@policy.destroy
    # respond_to do |format|
    #   format.html { redirect_to policies_url, notice: 'Policy was successfully destroyed.' }
    #   format.json { head :no_content }
    # end
  end

  private
  def provisional?
    params[:commit] == "Зберегти проект політики"
  end
    # Use callbacks to share common setup or constraints between actions.
    def set_policy
      @policy = Policy.includes(:policy_divisions).find(params[:id])
      @polisy_mp = @policy.policy_person_distances.includes(:mp).filter_polices(params[:policy])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def policy_params
      params.require(:policy).permit(:name, :description)
    end

    def policies

      unless params[:policies].blank?
        policies =  Policy.find_by_search_query(params[:policies])
      else
        if params[:filter].blank?
          policies = Policy.where(provisional: true)
        else
          policies = Policy.where(provisional: false)
        end
      end
      return policies.page(params[:page]).per(8)
    end
end
