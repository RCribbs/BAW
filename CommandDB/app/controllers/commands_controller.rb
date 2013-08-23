class CommandsController < ApplicationController
  # GET /commands
  # GET /commands.json
  def index
    @commands = Command.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @commands }
    end
  end

  # GET /commands/1
  # GET /commands/1.json
  def show
    @command = Command.find(params[:id])
    
    @usages = @command.usages
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @command }
    end
  end

  # GET /commands/new
  # GET /commands/new.json
  def new
    @command = Command.new
    @all_tags = Tag.all

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @command }
    end
  end

  # GET /commands/1/edit
  def edit
    @command = Command.find(params[:id])
  end

  # POST /commands
  # POST /commands.json
  def create
    debugger
    @command = Command.new(params[:command])

    respond_to do |format|
      if @command.save
        format.html { redirect_to @command, notice: 'Command was successfully created.' }
        format.json { render json: @command, status: :created, location: @command }
      else
        format.html { render action: "new" }
        format.json { render json: @command.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /commands/1
  # PUT /commands/1.json
  def update
    @command = Command.find(params[:id])

    respond_to do |format|
      if @command.update_attributes(params[:command])
        format.html { redirect_to @command, notice: 'Command was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @command.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /commands/1
  # DELETE /commands/1.json
  def destroy
    @command = Command.find(params[:id])
    @command.destroy

    respond_to do |format|
      format.html { redirect_to commands_url }
      format.json { head :no_content }
    end
  end

  def rebase_command
    @body = response.body.strip
    @command_updates = @body.split(/\n/)
    @command_updates.each do |command_update|
      @command_data = command_update[1,-1].split(/,/)
      if @command_data[0].eql? "deleted" then
        Command.destroy(Command.find_by_name(@command_data[2]))
      elsif @command_data[0].eql? "updated" then
        @command = Command.find_by_name(@command_data[2])
      elsif @command_data[0].eql? "added" then
        @command = Command.create(:path => @command_data[1], :name => @command_data[2])
        @command.save!
      end
    end
  end

  def rebase_script
    @body = response.body.strip
    @script_updates = @body.split(/\n/)
    @script_updates.each do |script_update|
      @script_data = command_update.split(/,/)
      if @script_data[0].eql? "deleted" then
        @usage = Usage.find_by_filePath(@script_data[1])
        @usage.destroy!
      elsif @script_data[0].eql? "added" then
        Usage.scan_and_add(@script_data[1])
      elsif @script_data[0].eql? "updated" then
        @usages = Usage.where(:filePath => @script_data[1])
        @usages.each do |usage|
          usage.destroy!
        end
        Usage.scan_and_add(@script_data[1])
      end
    end
  end
end
