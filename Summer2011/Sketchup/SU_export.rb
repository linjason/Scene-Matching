#!/usr/bin/ruby
#
# Copyright:: Copyright 2010 Google Inc.
# License:: All Rights Reserved.
# Original Author:: Tricia Stahr (mailto:tricias@google.com)
#
# Script to export 3d entities from SU that is called by theo.rb

require 'sketchup.rb'
require 'C:\Program Files\Google\Google SketchUp 8\Plugins\a.rb'

# Find the settings file which was written by theo.rb
settings_file = File.join(File.dirname(__FILE__).chomp('/theo'),
                'results/settings.txt')

# Read the settings file to get the name of the results dir and export format
f=File.open settings_file
lines=f.readlines
current_sub_dir = lines[0].chomp
model_name = lines[1].chomp


# Set up important variables
# Do the export
#sleep 1
m = Sketchup.active_model
e = m.entities

removeImage(e)
removeDefaultMan(e)
f = File.open File.join(current_sub_dir, File.basename(m.path, '.skp')+'.txt'),'w+' 


m = e.model
	xmin = m.bounds.corner(0).x.to_f
	xmax = m.bounds.corner(1).x.to_f
	ymin = m.bounds.corner(0).y.to_f
	ymax = m.bounds.corner(2).y.to_f
	zmin = m.bounds.corner(0).z.to_f
	zmax = m.bounds.corner(4).z.to_f
	f.puts "#{xmin}\n#{xmax}\n#{ymin}\n#{ymax}\n#{zmin}\n#{zmax}\n"
	Sketchup.active_model.active_view.camera.image_width=1
	cam=Sketchup.active_model.active_view.camera
	f.puts "#{cam.focal_length}\n#{cam.target.x.to_f}\n#{cam.target.y.to_f}\n#{cam.target.z.to_f}\n#{cam.xaxis.x}\n#{cam.xaxis.y}\n#{cam.xaxis.z}\n#{cam.yaxis.x}\n#{cam.yaxis.y}\n#{cam.yaxis.z}\n#{cam.zaxis.x}\n#{cam.zaxis.y}\n#{cam.zaxis.z}\n"
#if !(xmax-xmin<800 && xmax-xmin>80 && ymax-ymin<800 && ymax-ymin>80 && zmax-zmin<200 && zmax-zmin>12)
	#m = e.model
	#else
	
if (e.length <= 3 && getInstances(e).length == 1)
	f.puts "##explode"
	#getInstances(e)[0].explode
end

	components = getComponents(e)
	groups = getGroups(e)
	if ((components.length + groups.length) <= 3)
		f.puts "##Small number of components and groups: #{components.length + groups.length}"
	end
	#f = File.new('C:/3DWarehouse/Matlab/compsWithMeshNoExplode.txt', 'w')
#def printSegmentedComponentsDFS(e)
	#f = File.new('C:/3DWarehouse/Matlab/compsWithMeshDFS.txt', 'w')
	comps = getInstances(e)
	comps.each do |component|
		if(component.typename=='ComponentInstance')
			f.puts "compName: #{component.name}"
			f.puts "defiName: #{component.definition.name}"
		end
		if(component.typename=='Group')
			f.puts "grouName: #{component.name}"
		end
	end
	

	comps = getInstances(e)
	comps.each do |component|
		f.puts "New Instance"
		stack = []
		stack.push(component)
		parents=[]
		children=[]
		while (stack.length != 0)
			instance = stack.pop
			if instance.typename == "ComponentInstance"
				for j in 0..instance.definition.entities.length-1
					if (instance.definition.entities[j].typename == "ComponentInstance" || instance.definition.entities[j].typename == "Group")
						instance.definition.entities[j].make_unique
						stack.push(instance.definition.entities[j]) 
						parents.push instance	
						children.push instance.definition.entities[j]
					end
				end
			end
			if instance.typename == "Group"
				for j in 0..instance.entities.length-1
					if (instance.entities[j].typename == "ComponentInstance" || instance.entities[j].typename == "Group")
						instance.entities[j].make_unique
						stack.push(instance.entities[j]) 
						parents.push instance
						children.push instance.entities[j]
					end
				end
			end
		end
		for i in 0..parents.length-1
			puts "#{parents.length} #{parents[i].name}  #{children[i].name}"
		end
		
		stack = []
		definitions = []
		stack.push(component)
		while (stack.length != 0)
			instance = stack.pop
			puts "popped #{instance}"
			#definitions.push instance.name
			# for componentInstance
			if instance.typename == "ComponentInstance"
			for j in 0..instance.definition.entities.length-1
				if (instance.definition.entities[j].typename == "ComponentInstance" || instance.definition.entities[j].typename == "Group")
					stack.push(instance.definition.entities[j]) 
					puts "push #{instance.definition.entities[j]}"
				end
				#next if instance.definition.entities.length > 2000
				if (instance.definition.entities[j].typename == "Face")
					# get parent definitions
					definitions.push(instance)
					instanceToSearch = instance
					while (children.include? instanceToSearch)
						index = children.index(instanceToSearch)
						definitions.push parents[index] 
						instanceToSearch = parents[index]
					end
					definitions.reverse!
					transformations = Geom::Transformation.new
					definitions.each do |defin|
						transformations = transformations.* defin.transformation
						#puts "#{defin.name}"
					end
					f.puts "Transformation"
					for k in 0..15
						f.puts "#{transformations.to_a[k]}"
					end
					points = instance.definition.entities[j].mesh.points
					polygons = instance.definition.entities[j].mesh.polygons
					for l in 0..points.length-1
						f.puts "#{points[l].x.to_f}\n#{points[l].y.to_f}\n#{points[l].z.to_f}\n"
					end
					f.puts "a\n"
					for l in 0..polygons.length-1
						f.puts "#{polygons[l][0]}\n#{polygons[l][1]}\n#{polygons[l][2]}\n"
					end
					f.puts "a\n"
					definitions.clear
				end
			end
			end
			
			if instance.typename == "Group"
			for j in 0..instance.entities.length-1
				if (instance.entities[j].typename == "ComponentInstance" || instance.entities[j].typename == "Group")
					stack.push(instance.entities[j]) 
					puts "push #{instance.entities[j]}"
				end
				#next if instance.entities.length > 2000
				if (instance.entities[j].typename == "Face")
					# get parent definitions
					definitions.push(instance)
					instanceToSearch = instance
					while (children.include? instanceToSearch)
						index = children.index(instanceToSearch)
						definitions.push parents[index] 
						instanceToSearch = parents[index]
					end
					definitions.reverse!
					transformations = Geom::Transformation.new
					definitions.each do |defin|
						transformations = transformations.* defin.transformation
						#puts "#{defin.name}"
					end
					f.puts "Transformation"
					for k in 0..15
						f.puts "#{transformations.to_a[k]}"
					end
					points = instance.entities[j].mesh.points
					polygons = instance.entities[j].mesh.polygons
					for l in 0..points.length-1
						f.puts "#{points[l].x.to_f}\n#{points[l].y.to_f}\n#{points[l].z.to_f}\n"
					end
					f.puts "a\n"
					for l in 0..polygons.length-1
						f.puts "#{polygons[l][0]}\n#{polygons[l][1]}\n#{polygons[l][2]}\n"
					end
					f.puts "a\n"
					definitions.clear
				end
			end
			end
			

			
		end
	end
#end

f.puts "done"

m = e.model
=begin
	xmin = m.bounds.corner(0).x.to_f
	xmax = m.bounds.corner(1).x.to_f
	ymin = m.bounds.corner(0).y.to_f
	ymax = m.bounds.corner(2).y.to_f
	zmin = m.bounds.corner(0).z.to_f
	zmax = m.bounds.corner(4).z.to_f
	f.puts "#{xmin}\n#{xmax}\n#{ymin}\n#{ymax}\n#{zmin}\n#{zmax}"
=end	

	walls = getAllWalls(e, f)
=begin
	for i in 0..walls.length-1
		if walls[i].edges.length > 30
			next
		end
		puts "#{walls[i].edges.length}"
		for j in 0..walls[i].edges.length-1
			onePointX = walls[i].edges[j].vertices[0].position.x.to_f
			onePointY = walls[i].edges[j].vertices[0].position.y.to_f
			onePointZ = walls[i].edges[j].vertices[0].position.z.to_f
			otherPointX = walls[i].edges[j].vertices[1].position.x.to_f
			otherPointY = walls[i].edges[j].vertices[1].position.y.to_f
			otherPointZ = walls[i].edges[j].vertices[1].position.z.to_f
			f.puts "#{onePointX}\n #{onePointY}"
			f.puts "#{onePointZ}\n #{otherPointX}"
			f.puts "#{otherPointY}\n #{otherPointZ}"
		end
	end
=end
#end
f.close



# Kill process and there is no Ruby method to exit SU
Process.kill(9, Process.pid)

