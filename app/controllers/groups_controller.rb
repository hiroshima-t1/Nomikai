class GroupsController < BaseController
  # GET /groups
  # GET /groups.xml

  # １ページに表示するパーティ数
  GROUOPS_IN_PAGE = 5.0
  # ページ番号パラメータ
  PARAM_PAGE = :page

  def index
    @user = current_user
    user_groups = Group.find(:all,:order => 'group_name asc')

    # 一覧のページ数を計算
    @pages = (user_groups.count / GROUOPS_IN_PAGE).ceil
    # パラメータからページ番号を取得(nil → 1)
    @page = (params[PARAM_PAGE] || 1).to_i

    # パーティ配列を作成
    @groups = user_groups[(@page - 1) * GROUOPS_IN_PAGE, GROUOPS_IN_PAGE].collect

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @groups }
    end
  end

  # GET /groups/1
  # GET /groups/1.xml
  def show
    @group = Group.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @group }
    end
  end

  # GET /groups/new
  # GET /groups/new.xml
  def new
    @group = Group.new

    @group.group_id = @group.id

    @user = current_user
    @group.upd_user_id = @user.id

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @group }
    end
  end

  # GET /groups/1/edit
  def edit
    @group = Group.find(params[:id])
  end

  # POST /groups
  # POST /groups.xml
  def create
    @group = Group.new(params[:group])
    @user = current_user

    @group.group_id = @group.id
    @group.upd_user_id = @user.id
    
    respond_to do |format|
      if @group.save
        @group.group_id = @group.id
        @group.save
        format.html { redirect_to :action => :index }
        format.xml  { render :xml => @group, :status => :created, :location => @group }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /groups/1
  # PUT /groups/1.xml
  def update
    @group = Group.find(params[:id])

    respond_to do |format|
      if @group.update_attributes(params[:group])
        format.html { redirect_to :action => :index }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.xml
  def destroy
    @group = Group.find(params[:id])
    @group.destroy

    respond_to do |format|
      format.html { redirect_to :action => :index } 
      format.xml  { head :ok }
    end
  end
end
