class CareerSitesController < ApplicationController
  # GET /career_sites
  # GET /career_sites.json
  def index
    @career_sites = CareerSite.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @career_sites }
    end
  end

  # GET /career_sites/1
  # GET /career_sites/1.json
  def show
    @career_site = CareerSite.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @career_site }
    end
  end

  # GET /career_sites/new
  # GET /career_sites/new.json
  def new
    @career_site = CareerSite.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @career_site }
    end
  end

  # GET /career_sites/1/edit
  def edit
    @career_site = CareerSite.find(params[:id])
  end

  # POST /career_sites
  # POST /career_sites.json
  def create
    @career_site = CareerSite.new(params[:career_site])

    respond_to do |format|
      if @career_site.save
        format.html { redirect_to @career_site, notice: 'Career site was successfully created.' }
        format.json { render json: @career_site, status: :created, location: @career_site }
      else
        format.html { render action: "new" }
        format.json { render json: @career_site.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /career_sites/1
  # PUT /career_sites/1.json
  def update
    @career_site = CareerSite.find(params[:id])

    respond_to do |format|
      if @career_site.update_attributes(params[:career_site])
        format.html { redirect_to @career_site, notice: 'Career site was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @career_site.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /career_sites/1
  # DELETE /career_sites/1.json
  def destroy
    @career_site = CareerSite.find(params[:id])
    @career_site.destroy

    respond_to do |format|
      format.html { redirect_to career_sites_url }
      format.json { head :no_content }
    end
  end
end
