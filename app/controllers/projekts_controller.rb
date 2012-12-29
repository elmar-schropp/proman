class ProjektsController < ApplicationController
  before_filter :authenticate_user!

  # GET /projekts
  # GET /projekts.json
  def index
    @projekts = Projekt.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @projekts }
    end
  end

  # GET /projekts/1
  # GET /projekts/1.json
  def show
    @projekt = Projekt.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @projekt }
    end
  end

  # GET /projekts/new
  # GET /projekts/new.json
  def new
    @projekt = Projekt.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @projekt }
    end
  end

  # GET /projekts/1/edit
  def edit
    @projekt = Projekt.find(params[:id])
  end

  # POST /projekts
  # POST /projekts.json
  def create
    @projekt = Projekt.new(params[:projekt])

    respond_to do |format|
      if @projekt.save
        format.html { redirect_to @projekt, notice: 'Projekt was successfully created.' }
        format.json { render json: @projekt, status: :created, location: @projekt }
      else
        format.html { render action: "new" }
        format.json { render json: @projekt.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /projekts/1
  # PUT /projekts/1.json
  def update
    @projekt = Projekt.find(params[:id])

    respond_to do |format|
      if @projekt.update_attributes(params[:projekt])
        format.html { redirect_to @projekt, notice: 'Projekt was successfully updated (es).' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @projekt.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projekts/1
  # DELETE /projekts/1.json
  def destroy
    @projekt = Projekt.find(params[:id])
    @projekt.destroy

    respond_to do |format|
      format.html { redirect_to projekts_url }
      format.json { head :no_content }
    end
  end
end
