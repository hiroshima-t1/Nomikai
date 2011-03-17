class PartiesController < BaseController

  # １ページに表示するパーティ数
  PARTIES_IN_PAGE = 5.0
  # ページ番号パラメータ
  PARAM_PAGE = :page

  # GET /parties
  # GET /parties.xml
  def index
    @user = current_user
    @shops = []

    # ユーザが招待されているパーティを検索
    user_parties = Member.find_all_by_user_id(@user.id)
    # 一覧のページ数を計算
    @pages = (user_parties.count / PARTIES_IN_PAGE).ceil
    # パラメータからページ番号を取得(nil → 1)
    @page = (params[PARAM_PAGE] || 1).to_i

    # パーティ配列を作成
    @parties = user_parties[(@page - 1) * PARTIES_IN_PAGE, PARTIES_IN_PAGE].collect { |member| member.party }

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @parties }
    end
  end

  # GET /parties/create_party_plan
  def create_party_plan
    party_id = params[:id]
    @user = current_user
    @group_members = []

    unless party_id == nil
      @party = Party.find(party_id)
      @shop = nil

      unless @party.shop_id == nil
        res = HotPepper.find_shop_by_id(@party.shop_id)
        if res.found?
          @shop = res.shop
        end
      end

    else
      @party = Party.new
      @party.user_id = @user.id
      @party.opendate = Time.new
    end

    respond_to do |format|
      format.html
    end
  end

  # GET /parties/party_detail
  # GET /parties/party_detail.xml
  def party_detail
    @id = params[:id]
    
    respond_to do |format|
      format.html
    end
  end

  # GET /parties/1
  # GET /parties/1.xml
  def show
    @party = Party.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @party }
    end
  end

  # GET /parties/new
  # GET /parties/new.xml
  def new
    @party = Party.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @party }
    end
  end

  # GET /parties/1/edit
  def edit
    @party = Party.find(params[:id])
  end

  # POST /parties
  # POST /parties.xml
  def create
    @party = Party.new(params[:party])

    respond_to do |format|
      if @party.save
        flash[:notice] = 'Party was successfully created.'
        format.html { redirect_to(@party) }
        format.xml  { render :xml => @party, :status => :created, :location => @party }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @party.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /parties/1
  # PUT /parties/1.xml
  def update
    @party = Party.find(params[:id])

    respond_to do |format|
      if @party.update_attributes(params[:party])
        flash[:notice] = 'Party was successfully updated.'
        format.html { redirect_to(@party) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @party.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /parties/1
  # DELETE /parties/1.xml
  def destroy
    @party = Party.find(params[:id])
    @party.destroy

    respond_to do |format|
      format.html { redirect_to(parties_url) }
      format.xml  { head :ok }
    end
  end

protected

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end
end
