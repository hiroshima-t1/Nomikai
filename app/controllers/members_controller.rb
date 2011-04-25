class MembersController < BaseController
  def update
    @member = Member.find(params[:id])

    if @member.update_attributes(params[:member])
      flash[:notice] = 'Party was successfully updated.'
    else
      flash[:notice] = 'Error'
    end
    redirect_to :controller=>'parties', :action => 'members', :id=>@member.party_id
  end
end
