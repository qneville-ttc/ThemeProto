class ThemesController < ApplicationController
  # GET /themes
  # GET /themes.json

  ## JUST FOR NOW

  CAREER_SITE_ID = 1

  def index
    @themes_all = Theme.all
    @themes     = Theme.where("career_site_id IS NULL") 
    @themes_custom = Theme.where("career_site_id = ?", CAREER_SITE_ID)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @themes }
    end
  end

  # GET /themes/1
  # GET /themes/1.json
  def show
    @theme = Theme.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @theme }
    end
  end

  def clone_theme

    @oldTheme = Theme.find(params[:id])
    @career_site = CAREER_SITE_ID                     #just for now... don't worry.  ain't nobody got time fo dat

    @newTheme = @oldTheme.dup
    @newTheme.career_site_id = @career_site
    @newTheme.theme_name = "#{@oldTheme.theme_name} Copy"
    @newTheme.templates << @oldTheme.templates.collect { |child_theme| child_theme.dup }
    @newTheme.save

    render :text => "New theme saved with new ID #{@newTheme.id}"

  end

  # GET /themes/new
  # GET /themes/new.json
  def new
    logger.debug("HIIIIIIIIII")
    @theme = Theme.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @theme }
    
    end
  end

  # GET /themes/1/edit
  def edit
    @theme = Theme.find(params[:id])
    @templates = Template.where("theme_id = ?", params[:id])
  end

  # GET /themes/:id/template/:id
  def get_content
    theme_id = params["theme_id"]
    template_id = params["template_id"]
    @template = Template.where("theme_id = ? AND id = ?", theme_id, template_id).first
    render :text => @template.content
  end

  # POST /themes/:id/save
  def save_template

    theme = Theme.find(params[:theme_id])
    @template = theme.templates.find(params[:template_id])
    new_content = params[:content]

    @template.content = new_content
    @template.save
    

    render :text => "#{new_content}"
  
  end

  # POST /themes
  # POST /themes.json
  def create
    @theme = Theme.new(params[:theme])
    
    @theme.save  ##UNCOMMENT LATER
    @theme.init_blanks
    
    respond_to do |format|
      if @theme.save
        format.html { redirect_to @theme, notice: 'Theme was successfully created.' }
        format.json { render json: @theme, status: :created, location: @theme }
      else
        format.html { render action: "new" }
        format.json { render json: @theme.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /themes/1
  # PUT /themes/1.json
  def update
    @theme = Theme.find(params[:id])

    respond_to do |format|
      if @theme.update_attributes(params[:theme])
        format.html { redirect_to @theme, notice: 'Theme was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @theme.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /themes/1
  # DELETE /themes/1.json
  def trash_theme
    @theme = Theme.find(params[:id])
    @theme.destroy

    render :text => "success"
  end

  def create_template
    @theme = Theme.find(params[:id])
    @template = @theme.templates.build(params[:template])

  end
end
