require 'xcodeproj'

project_path = '/Users/yassen/Documents/FanFun/FanFun.xcodeproj'
project = Xcodeproj::Project.open(project_path)
target = project.targets.first

# Find the group Data/Remote
group = project.main_group.find_subpath('FanFun/Data/Remote', true)

# Check if files already exist to avoid duplicates
def add_file_if_needed(group, target, filename, add_to_build_phase = true)
    file_ref = group.files.find { |f| f.path == filename }
    if file_ref.nil?
        file_ref = group.new_file(filename)
        if add_to_build_phase
            target.source_build_phase.add_file_reference(file_ref)
        end
        puts "Added #{filename}"
    else
        puts "#{filename} already exists"
    end
end

add_file_if_needed(group, target, 'Secrets.swift', true)
add_file_if_needed(group, target, 'Secrets.template.swift', false)
add_file_if_needed(group, target, 'APIKeyInterceptor.swift', true)

project.save
puts "Project saved."
