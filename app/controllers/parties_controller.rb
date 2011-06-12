class PartiesController < BaseController

  # １ページに表示するパーティ数
  PARTIES_IN_PAGE = 5.0
  # ページ番号パラメータ
  PARAM_PAGE = :page

  # GET /parties
  # GET /parties.xml
  def index
    @user        = current_user
    @shops       = []
    conditions   = {}
    @party_status = params[:party_status]
    @party_status = 1 if @party_status.to_s == ""

    # ユーザが招待されているパーティを検索
    conditions    = []
    conditions[0] =  "members.user_id = ?"
    conditions[0] << " and parties.party_status in ('2', '3')" if @party_status == "2"
    conditions[0] << " and parties.party_status = ?" unless @party_status == "2"
    conditions[0] << " and members_parties.user_id = ?"
    conditions[0] << " and parties.user_id = ?" if @party_status == "0"
    conditions    << @user.id
    conditions    << @party_status unless @party_status == "2"
    conditions    << @user.id
    conditions    << @user.id if @party_status == "0"

    order         =  'parties.opendate'
    order         << ' desc' if @party_status == "2"
    user_parties = Member.find(:all,
                               :conditions => conditions,
                               :include => [:party => :members],
                               :order => order)

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
    @shop = nil

    if (@party = session[:party]).nil?
      unless party_id.nil?
        @party = Party.find(party_id,
                            :conditions => {:user_id => @user.id},
                            :include => [:members => :user,
                                         :user => {:groups => {:entrants => :user}}])

      else
        @party = Party.new
        @party.user_id = @user.id
        @party.opendate = Time.new
      end
    end

    unless @party.shop_id.to_s == ""
      res = HotPepper.find_shop_by_id(@party.shop_id.to_s)
      @shop = res.shop if res.found?
    end

#    @group_selection = @party.user.groups.inject(Array.new) do |group_selection, group|
#      
#      group_selection
#    end

    respond_to do |format|
      format.html
    end
  end

  # GET /parties/party_detail
  # GET /parties/party_detail.xml
  def party_detail
    if params[:id].nil?
      redirect_to :action => :index
      return
    end

    @user  = current_user
    @party = Party.find(params[:id])
    @shop  = nil

    if @party.nil?
      redirect_to :action => :index
      return
    end

    unless @party.shop_id.to_s == ""
      res = HotPepper.find_shop_by_id(@party.shop_id.to_s)
      @shop = res.shop if res.found?
    end

    @member_status = @party.members.inject(Array.new(3) {|i| 0}) do |member_status, member|
      member_status[member.member_status.to_i] += 1
      member_status
    end

    @member = Member.find(:first,
                          :conditions => {:party_id => @party.id, :user_id => @user.id})

    respond_to do |format|
      format.html
    end
  end

  # POST /parties/save
  def save
    @user = current_user
    params[:party][:user_id] = @user.id
    params[:entrants] = [] unless params[:entrants]
    params[:entrants] << @user.id.to_s
    @party = Party.attributes_from_params(params)
    @party.save
    session[:party] = nil

    redirect_to :controller => :parties, :action => :create_party_plan, :id => @party.id
  end

  # POST /parties/confirm_party_plan
  def confirm_party_plan
    @user = current_user
    params[:party][:user_id] = @user.id
    params[:entrants] = [] unless params[:entrants]
    params[:entrants] << @user.id.to_s
    @party = Party.attributes_from_params(params)

    unless @party.shop_id.to_s == ""
      res = HotPepper.find_shop_by_id(@party.shop_id.to_s)
      @shop = res.shop if res.found?
    end

    session[:party] = @party

    respond_to do |format|
      format.html
    end
  end

  # POST /parties/registration_party_plan
  def registration_party_plan
    unless session[:party].nil?
      @party = session[:party]
      @party.party_status = '1' if @party.party_status == '0'
      @party.save
      @party.send_party_notification do |member|
        ret = true
        ret = false if member.user.nil? || member.user.email.nil?
        ret = false if member.user.email =~ /example.com$/
        ret
      end
      session[:party] = nil
    end

    respond_to do |format|
      format.html
    end
  end

  # POST /parties/completed_party
  def completed_party
    if params[:id].nil?
      redirect_to :action => :index
      return
    end

    @user  = current_user
    @party = Party.find(params[:id], :conditions => {:user_id => @user.id})

    respond_to do |format|
      format.html
    end
  end

  def update_participates
    if params[:id].nil?
      redirect_to :action => :index
      return
    end

    @user  = current_user
    member = Member.find(:first,
                         :conditions => {:party_id => params[:id], :user_id => @user.id})
    member.member_status = params[:member_status]
    member.save

    redirect_to :action => :party_detail, :id => params[:id]
  end

  # POST /parties/complete
  def complete
    if params[:id].nil?
      redirect_to :action => :index
      return
    end

    @user  = current_user
    @party = Party.find(params[:id], :conditions => {:user_id => @user.id})
    @party.party_status = '2'
    @party.save

    redirect_to :action => :party_detail, :id => @party.id
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
  
  def members
    @party = Party.find(params[:id], :include =>{:members=>:user})
    @members = @party.members
    @members.sort! do |a, b|
      if a.user_id == @party.user_id
        -1
      elsif b.user_id == @party.user_id
        1
      else
        a.user_id <=> b.user_id
      end
    end
  end
end
