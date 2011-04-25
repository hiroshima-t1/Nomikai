module PartiesHelper
  def participates_image(participates)
    return Member::PARTICIPATES[participates.to_i]
  end

  def participates_type(participates)
    return Member::PARTICIPATES_TYPE[participates.to_i]
  end

  def participates_for_select_box
    (0...Member::PARTICIPATES_TYPE.size).map do |i|
      [Member::PARTICIPATES_TYPE[i].to_s, i.to_s]
    end
  end

  def select_tab?(tab)
    tab_no = params[:party_status].to_s
    if tab_no == '' || tab_no < '0' || tab_no > '2'
      tab_no = '1'
    end

    return tab_no == tab
  end

  def page_link_tags
    path  = request.path_info
    temp = /[?]/ =~ request.request_uri
    links = ""
    link_tag = '<a href="%1">'
    no_link_tag = '<a>'
    end_link_tag = '</a> '

    # パラメータからページ番号の除去
    if temp.nil?
      param = ""
    else
      param = $'
      temp = /(&*)page=/ =~ param
      unless temp.nil?
        param_before = $`
        /[&]/ =~ $'
        param_after = $'
        param = param_before.to_s + param_after.to_s
        param << "&" unless param == ""
      end
    end
    param << "page="
    url = path + "?" + param


    # ページリンク
    for p in 1..@pages
      # 前リンク
      if p == 1
        links << (@page == 1 ? no_link_tag : link_tag.gsub("%1", url + (@page - 1).to_s))
        links << "≪前"
        links << end_link_tag
      end

      # ページ番号リンク
      links << (@page == p ? no_link_tag : link_tag.gsub("%1", url + p.to_s))
      links << p.to_s
      links << end_link_tag

      # 次リンク
      if p == @pages
        links << (@page == @pages ? no_link_tag : link_tag.gsub("%1", url + (@page + 1).to_s))
        links << "次≫"
        links << end_link_tag
      end
    end

    links
  end

  def recruit_credit_tag
    return '<div class="image_credit">【画像提供：ホットペッパー　FooMoo】</div>'
  end

  def options_year(opendate)
    years = []
    year = Time.new.strftime("%Y").to_i
    default_year = year

    unless opendate.nil?
      default_year = opendate.strftime("%Y").to_i
      if default_year < year
        years << [ default_year.to_s + "年", default_year.to_s ]
      end
    end

    year.upto(year + 1) do |value|
      years << [ value.to_s + "年", value.to_s ]
    end

    options_for_select years, default_year.to_s
  end

  def options_month(opendate)
    months = []
    default_month = Time.new.strftime("%m").to_i
    default_month = opendate.strftime("%m").to_i unless opendate.nil?

    1.upto(12) do |month|
       months << [ month.to_s + "月", month.to_s ]
    end

    options_for_select months, default_month.to_s
  end

  def options_day(opendate)
    days = []
    default_day = Time.new.strftime("%d").to_i
    default_day = opendate.strftime("%d").to_i unless opendate.nil?

    1.upto(31) do |day|
      days << [ day.to_s + "日", day.to_s ]
    end

    options_for_select days, default_day.to_s
  end

  def options_hour(opendate)
    hours = []
    default_hour = Time.new.strftime("%H").to_i
    default_hour = opendate.strftime("%H").to_i unless opendate.nil?

    0.upto(23) do |hour|
      hours << [ hour.to_s + "時", hour.to_s ]
    end

    options_for_select hours, default_hour.to_s
  end

  def options_minute(opendate)
    minutes = []
    default_minute = nil #Time.new.strftime("%M").to_i
    default_minute = opendate.strftime("%M").to_i unless opendate.nil?

    0.step(55, 5) do |minute|
      minutes << [ minute.to_s + "分", minute.to_s ]
    end

    options_for_select minutes, default_minute.to_s
  end

  def member_check_box_tag(group, assign, options = {})
    input_tag = "<input type='checkbox' name='assigns[]' id='group_%s_assign_%s' value='%s' %s>"
    label_tag = "<label for='group_%s_assign_%s'>%s</label>"

    party_member = @party.members.select{|member| member.user_id == assign.user_id}[0]
    option = ("checked='checked'" unless party_member.nil?) || ""

    options.each_pair do |key, value|
      option << " #{key}=\"#{value}\""
    end

    tag = ""
    tag << input_tag % [group.id, assign.user_id, assign.user_id, option]
    tag << label_tag % [group.id, assign.user_id, assign.user.login]
    tag
  end

  def party_status_char(party_status)
    return Party::PARTY_STATUS_TYPE[party_status.to_i][0]
  end

  def find_shop(shop_id = nil)
    shop = nil
    unless shop_id.to_s == ""
      res = HotPepper.find_shop_by_id(shop_id.to_s)
      shop = res.shop if res.found?
    end
    shop
  end
end
