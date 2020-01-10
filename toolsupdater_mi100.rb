##############################
# change to fileutils
#
#
#
############

require 'pry'
TOOLS_ORINGIN_PATH_VALFS = "//10.67.7.117/shareAll/G/gfxval/Project/MI100/Tools/"
TOOLS_TARGET_PATH = "/root/SnakeBytes/lib/get_tools"
tool_list = ['atitool', 'amdvbflash', 'agm', 'regxp', 'mment', 'toollib', 'db32', 'ppgen','agt']
MOUNT_PATH_LOCAL = "/root/mi100_tools/"
Dir.mkdir(MOUNT_PATH_LOCAL) unless Dir.exist?(MOUNT_PATH_LOCAL)

`mount -t cifs #{TOOLS_ORINGIN_PATH_VALFS} #{MOUNT_PATH_LOCAL} -o username=valfs\\net,password=net,vers=1.0`
if /h|H/.match(ARGV[0]) and !ARGV.empty?
    puts '''
    #######  HELP  ############################################################################
    ##     support argument: atitool, amdvbflash, agm, regxp, mment, toollib, db32, ppgen #####
    ##     And if you did not put any argument, will download all tools           ##############
    ##     For example: ruby toolsupdater_mi100.rb --atitool                      ##############
    #############################################################################################


'''

else 
    if ARGV.empty? 
        task_list = tool_list
    else 
        _,task_list = */--(.+)/.match(ARGV[0])
        #binding.pry
        task_list = task_list.split(',').map{|tool_name| tool_name.downcase}
        
        #if tool_list.include?(tool_name.downcase)
        #    taks_list = [tool_name.downcase]
    end
    task_list.each do |tool|
        Dir.chdir(MOUNT_PATH_LOCAL+tool)
        tool_name = Dir.glob('*').select {|f| File.file?(f) }.sort![-1] 
        puts "Downloading/Unzip #{tool_name} ...... to #{TOOLS_TARGET_PATH+tool}/"
        Dir.mkdir("#{TOOLS_TARGET_PATH}/#{tool}/") unless Dir.exist?("#{TOOLS_TARGET_PATH}/#{tool}/")
        `tar -xzvf #{MOUNT_PATH_LOCAL}/#{tool}/#{tool_name} -C #{TOOLS_TARGET_PATH}/#{tool}/`
        
        puts "Complete update #{tool} to #{tool_name}" 
    end

end
puts "############### UMOUNT VALFS ##################"
`sudo umount -a -t cifs -l`
