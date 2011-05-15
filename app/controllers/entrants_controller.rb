class EntrantsController < BaseController
  # GET /entrants
  # GET /entrants.xml
  def index
    @user = current_user
    @groups = Group.find(:all,:order => 'group_name asc')

    conditions    = []
    conditions[0] =  "entrants.group_id = ?"

    i = 0
    @entranlist = []
    for group in @groups
      conditions    << group.id
      @entranlist[i] = Entrant.find(:all,
                              :conditions => conditions)

      conditions.delete(conditions.size-1)
      i = i + 1
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @entranslist }
    end
  end

  # GET /entrants/1
  # GET /entrants/1.xml
  def show
    @entrant = Entrant.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @entrant }
    end
  end

  # GET /entrants/new
  # GET /entrants/new.xml
  def new
    @entrant = Entrant.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @entrant }
    end
  end

  # GET /entrants/1/edit
  def edit
    @entrant = Entrant.find(params[:id])
  end

  # POST /entrants
  # POST /entrants.xml
  def create
    @entrant = Entrant.new(params[:entrant])
    @user = current_user

    @entrant.upd_user_id = @user.id

    respond_to do |format|
      if @entrant.save
        format.html { redirect_to :action => :index }
        format.xml  { render :xml => @entrant, :status => :created, :location => @entrant }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @entrant.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /entrants/1
  # PUT /entrants/1.xml
  def update
    @entrant = Entrant.find(params[:id])

    respond_to do |format|
      if @entrant.update_attributes(params[:entrant])
        format.html { redirect_to(@entrant, :notice => 'Entrant was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @entrant.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /entrants/1
  # DELETE /entrants/1.xml
  def destroy
    @entrant = Entrant.find(params[:id])
    @entrant.destroy

    respond_to do |format|
      format.html { redirect_to(entrants_url) }
      format.xml  { head :ok }
    end
  end
end
