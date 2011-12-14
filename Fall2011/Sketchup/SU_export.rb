#!/usr/bin/ruby
#
# written by Jason Lin <jasonli1@andrew.cmu.edu> 
# Script to export scenes from SU and render them using C++ OpenGL in same view (no MATLAB needed)

require 'sketchup.rb'
require 'C:\Program Files (x86)\Google\Google SketchUp 8\Plugins\lib.rb' # my helper functions

# Set up important variables
m = Sketchup.active_model
e = m.entities

####################set these two manually for input image
aspect_ratio=1.333 
outFileName='D:/a.txt'

# Do the export
removeImage(e)#Remove any components of class Image from scene
removeDefaultMan(e)#Remove the default 2D man 

# Open file for dumping edges and polygon info
f=File.open (outFileName,"w")

# set image width to 1 and export the camera parameters
cam=Sketchup.active_model.active_view.camera

# convert SU's horizontal FOV to OpenGL's vertical FOV
#vertical_FOV=Math.atan(1.0/2/cam.focal_length/aspect_ratio)*2/3.14*180
f.puts "#{aspect_ratio}\n#{cam.fov}\n"
f.puts "#{cam.eye.x.to_f}\n#{cam.eye.y.to_f}\n#{cam.eye.z.to_f}\n"
f.puts "#{cam.target.x.to_f}\n#{cam.target.y.to_f}\n#{cam.target.z.to_f}\n"
f.puts "#{cam.up.x.to_f}\n#{cam.up.y.to_f}\n#{cam.up.z.to_f}\n"
comps = getInstances(e)# returns an array of all the "ComponentInstance"s and "Group"s in e
f.puts "#{comps.length}\n" # output number of components, so that C++ will know how big an array to create

comps.each do |component|# for each Group or ComponentInstance
  # since ComponentInstances and Groups can contain CompenentInstances and Groups in them, the structure of a component
  # can be a tree of ComponentInstances and Groups
  # perform depth-first search to traverse all the ComponentInstances/Groups, performing 2 operations:
  # 1) for each ComponentInstance/Group, record its parent ComponentInstance/Group, for use later (essentially pointers for traversal up the tree)
  # 2) for each ComponentInstance/Group, call "make_unique", so that each entry in children[] will be unique and thus we can search by reference
  # or else, multiple instances of the same ComponentInstance/Group in children[] will break the search used below
  stack = []# DFS stack
  stack.push(component)
  parents=[]# array of parents
  children=[]# array of children, children[i]'s parent is in parents[i]
  
  numFacesForComponent=0; # compute the number of faces for this component, used in C++ array malloc
  while (stack.length != 0)
    instance = stack.pop
    if instance.typename == "ComponentInstance"
      for j in 0..instance.definition.entities.length-1
        if (instance.definition.entities[j].typename=="Face")
          numFacesForComponent=numFacesForComponent+1
        end
        if (instance.definition.entities[j].typename == "ComponentInstance" || instance.definition.entities[j].typename == "Group")
          instance.definition.entities[j].make_unique
          stack.push(instance.definition.entities[j]) # push all ComponentInstance/Group children of this ComponentInstance/Group onto stack for DFS
          # record this child's parent
          parents.push instance
          children.push instance.definition.entities[j]
        end
      end
    end
    # exactly same operations as ComponentInstance 
    if instance.typename == "Group"
      for j in 0..instance.entities.length-1
        if (instance.entities[j].typename=="Face")
          numFacesForComponent=numFacesForComponent+1
        end
        if (instance.entities[j].typename == "ComponentInstance" || instance.entities[j].typename == "Group")
          instance.entities[j].make_unique
          stack.push(instance.entities[j]) 
          parents.push instance
          children.push instance.entities[j]
        end
      end
    end
  end
  f.puts "#{numFacesForComponent}\n"
  # do DFS on the component again to retrieve the coordinates of all the faces in this component
  # the SU coordinates for components are in local coordinates. coordinate transformation from local to global
  # coordinates is performed below so that all output coordinates are global

  stack = []# DFS stack
  definitions = []# the stack of matrix transformations between a child ComponentInstance/Group's local coordinates and it's parent's coordinates
  stack.push(component)
  while (stack.length != 0)
    instance = stack.pop
    if instance.typename == "ComponentInstance"
      # search each entity of this component. If face, output the coords and trans matrix to world coords, or else if CompInst/Group, add those to stack for DFS  
      for j in 0..instance.definition.entities.length-1
        if (instance.definition.entities[j].typename == "ComponentInstance" || instance.definition.entities[j].typename == "Group")
          stack.push(instance.definition.entities[j]) 
        end
        if (instance.definition.entities[j].typename == "Face")
          # starting from this instance, traverse up the tree of instances and push all the instances into array until we reach the top-most root instance
          # the product of the trans matrices for all these instances is a trans matrix from local to world coords
          definitions.push(instance)
          instanceToSearch = instance
          while (children.include? instanceToSearch) # while this instanceToSearch has a parent (not yet at top-most instance)
            index = children.index(instanceToSearch) # find this instanceToSearch's index in children
            definitions.push parents[index] # the corresponding entry in parents[index] is its parent
            instanceToSearch = parents[index] # traverse up
          end
          # multiply all the transformations to get the trans from local coords to world coords
          definitions.reverse!
          transformations = Geom::Transformation.new
          definitions.each do |defin|
            transformations = transformations.* defin.transformation 
          end
          # output the points and polygons, and also delimiters
          points = instance.definition.entities[j].mesh.points
          polygons = instance.definition.entities[j].mesh.polygons
          f.puts "#{points.length*3}"
          for l in 0..points.length-1
            # transform the local points coordinates to world coordinates
            pointsTrans=transform(transformations.to_a,points[l])
            f.puts "#{pointsTrans[0]}\n#{pointsTrans[1]}\n#{pointsTrans[2]}\n"
          end
          f.puts 'C' #delimiter
          f.puts "#{polygons.length*3}"
          for l in 0..polygons.length-1
            f.puts "#{polygons[l][0].abs}\n#{polygons[l][1].abs}\n#{polygons[l][2].abs}\n"
          end
          f.puts 'C' #delimiter
          definitions.clear 
        end
      end
    end

    # exactly the same operations are performed on the "Group"s, but the code is written separately because the structure of ComponentInstances
    # differ from Groups. The difference is that a ComponentInstance's instance.definition.entites is instance.entities in a Group
    if instance.typename == "Group"
      for j in 0..instance.entities.length-1
        if (instance.entities[j].typename == "ComponentInstance" || instance.entities[j].typename == "Group")
          stack.push(instance.entities[j]) 
        end
        if (instance.entities[j].typename == "Face")
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
          end
          points = instance.entities[j].mesh.points
          polygons = instance.entities[j].mesh.polygons
          f.puts "#{points.length*3}"
          for l in 0..points.length-1
            pointsTrans=transform(transformations.to_a,points[l])
            f.puts "#{pointsTrans[0]}\n#{pointsTrans[1]}\n#{pointsTrans[2]}\n"
          end
          f.puts 'C'
          f.puts "#{polygons.length*3}"
          for l in 0..polygons.length-1
            f.puts "#{polygons[l][0].abs}\n#{polygons[l][1].abs}\n#{polygons[l][2].abs}\n"
          end
          f.puts 'C'
          definitions.clear
        end
      end
    end
  end
  # "CZ" signifies end of this component
  # rewind one character to remove the newline by the above puts and thus prints CZ
  if RUBY_PLATFORM.include? 'darwin'
    f.seek -1,IO::SEEK_CUR
  else
    f.seek -2,IO::SEEK_CUR
  end
  f.puts 'Z'
end

# finished writing the dump file
f.close

# remove the newline at end of file, or else my C++ code will mess up
f=File.open (outFileName,"a")
if RUBY_PLATFORM.include? 'darwin'
  f.truncate File.size(outFileName)-1
else
  f.truncate File.size(outFileName)-2
end
f.close

