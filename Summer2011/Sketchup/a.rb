def getAllFaces(entities)
	faces = []
	for i in 0..entities.length-1
		if entities[i].typename == "Face"
			#puts "#{i}"
			if !faces.include? entities[i]
				faces.push(entities[i])
			end
		end
		
	end
	return faces
end

def getAllFacesFromInstances(entities)
	faces = []
	for i in 0..entities.length-1
		if entities[i].typename == "ComponentInstance"
			compEntities = entities[i].definition.entities
			for j in 0..compEntities.length-1
				if compEntities[j].typename == "Face"
					#puts "#{j}"
					if !faces.include? compEntities[j]
						faces.push(compEntities[j])
						faces.push(entities[i].transformation)
					end
				end
			end
		end
		if entities[i].typename == "Group"
			compEntities = entities[i].entities
			for j in 0..compEntities.length-1
				if compEntities[j].typename == "Face"
					#puts "#{j}"
					if !faces.include? compEntities[j]
						faces.push(compEntities[j])
						faces.push(entities[i].transformation)
					end
				end
			end
		end
	end	
	return faces
end
		
def getAllWalls(entities, f)
	walls = []
	allFaces = getAllFaces(entities)
	#	puts "Total num of faces: #{allFaces.length}"
	for i in 0..allFaces.length-1
		minZ = 10000
		maxZ = -10000
		edgesForFace = allFaces[i].edges
		for j in 0..edgesForFace.length-1
			onePointZ = edgesForFace[j].vertices[0].position.z.to_f
			otherPointZ = edgesForFace[j].vertices[1].position.z.to_f
			minZ = onePointZ if (onePointZ < minZ ) 
			minZ = otherPointZ if (otherPointZ < minZ )
			maxZ = onePointZ if (onePointZ > maxZ ) 
			maxZ = otherPointZ if (otherPointZ > maxZ)
			if ((minZ - maxZ).abs < 200) && ((minZ - maxZ).abs > 5.9*12) && (!walls.include? allFaces[i])
				#puts "aa#{allFaces[i].entityID}"
				walls.push allFaces[i]
				
				if allFaces[i].edges.length > 30
					next
				end
				
				
				for j in 0..allFaces[i].edges.length-1
					onePointX = allFaces[i].edges[j].vertices[0].position.x.to_f
					onePointY = allFaces[i].edges[j].vertices[0].position.y.to_f
					onePointZ = allFaces[i].edges[j].vertices[0].position.z.to_f
					otherPointX = allFaces[i].edges[j].vertices[1].position.x.to_f
					otherPointY = allFaces[i].edges[j].vertices[1].position.y.to_f
					otherPointZ = allFaces[i].edges[j].vertices[1].position.z.to_f
				
					f.puts "#{onePointX}\n #{onePointY}"
					f.puts "#{onePointZ}\n #{otherPointX}"
					f.puts "#{otherPointY}\n #{otherPointZ}"
				
				end
			end
		end
	end
	#return walls
	allFaces = getAllFacesFromInstances(entities)
	for i in 0..(allFaces.length)/2-1
		minZ = 10000
		maxZ = -10000
		edgesForFace = allFaces[2*i].edges
		for j in 0..edgesForFace.length-1
			onePointZ = edgesForFace[j].vertices[0].position.z.to_f
			otherPointZ = edgesForFace[j].vertices[1].position.z.to_f
			minZ = onePointZ if (onePointZ < minZ ) 
			minZ = otherPointZ if (otherPointZ < minZ )
			maxZ = onePointZ if (onePointZ > maxZ ) 
			maxZ = otherPointZ if (otherPointZ > maxZ)
			if ((minZ - maxZ).abs < 200) && ((minZ - maxZ).abs > 5.9*12) && (!walls.include? allFaces[2*i])
				#puts "aa#{allFaces[i].entityID}"
				walls.push allFaces[2*i]
				
				if allFaces[2*i].edges.length > 30
					next
				end
				
				for j in 0..allFaces[2*i].edges.length-1
					
					oPoint = allFaces[2*i].edges[j].vertices[0].position.transform allFaces[2*i+1]
					otPoint = allFaces[2*i].edges[j].vertices[1].position.transform allFaces[2*i+1]
					
					onePointX = oPoint.x.to_f
					onePointY = oPoint.y.to_f
					onePointZ = oPoint.z.to_f
					otherPointX = otPoint.x.to_f
					otherPointY = otPoint.y.to_f
					otherPointZ = otPoint.z.to_f
				
					f.puts "#{onePointX}\n #{onePointY}"
					f.puts "#{onePointZ}\n #{otherPointX}"
					f.puts "#{otherPointY}\n #{otherPointZ}"
				
				end
			end
		end
	end
end

def printWallEdges(walls)
	you=0
	f = File.open('C:/3DWarehouse/Matlab/walls.txt','w')
	for i in 0..walls.length-1
		you=1 if walls[i].entityID==175217
		if walls[i].edges.length > 30
			next
		end
		puts "here" if(you==1)
		puts "#{walls[i].edges.length}"
		for j in 0..walls[i].edges.length-1
			onePointX = walls[i].edges[j].vertices[0].position.x.to_f
			onePointY = walls[i].edges[j].vertices[0].position.y.to_f
			onePointZ = walls[i].edges[j].vertices[0].position.z.to_f
			otherPointX = walls[i].edges[j].vertices[1].position.x.to_f
			otherPointY = walls[i].edges[j].vertices[1].position.y.to_f
			otherPointZ = walls[i].edges[j].vertices[1].position.z.to_f
			
			
			puts "#{onePointX}\n #{onePointY}"
			puts "#{onePointZ}\n #{otherPointX}"
			puts "#{otherPointY}\n #{otherPointZ}"
			
			
		end
		you=0
	end
	f.close
end

def containInstances(e)
	for i in 0..e.length-1
		return true if (e[i].typename=="ComponentInstance" || e[i].typename=="Group")
	end
	return false
end
def containsFaces(e)

	for i in 0..e.length-1
		return true if (e[i].typename=="Face")
	end
	return false
end
def containImage(e)
	for i in 0..e.length-1
		return i if (e[i].typename=="Image")
	end
	return false
end
def getInstances(e)
	components = []
	for i in 0..e.length-1
	  if (e[i].typename == "ComponentInstance" || e[i].typename == "Group")
		components.push(e[i])
	  end
	end
	return components
end
def getComponents(e)
	components = []
	for i in 0..e.length-1
	  if e[i].typename == "ComponentInstance"
		components.push(e[i])
	  end
	end
	return components
end
def getGroups(e)
	components = []
	for i in 0..e.length-1
	  if e[i].typename == "Group"
		components.push(e[i])
	  end
	end
	return components
end
def explodeAllComponents(e)
	while(containInstances(e))
		for i in 0..e.length-1
			if (e[i].typename=="ComponentInstance" || e[i].typename=="Group")
				e[i].explode
				break
			end
		end
	end

end
def explodeNestedComponents(e)
	components = []
	for i in 0..e.length-1
	  if e[i].typename == "ComponentInstance"
		#puts "#{i}"
		components.push(e[i])
	  end
	end
	compToExplode = []
	for j in 0..components.length-1
		for k in 0..components[j].definition.entities.length-1
			if components[j].definition.entities[k].typename == "ComponentInstance"
				compToExplode.push(components[k])
				components[j].explode
				break
			end
		end
		if !components[j].deleted?
		components[j].explode
		end
	end
	puts "he#{compToExplode.length}"
	for j in 0..compToExplode.length-1
		compToExplode[j].explode
	end
end
=begin
def getBoundingBox(m)
	removeDefaultMan(m.active_model)
	xmin = m.bounds.corner(0).x.to_f
	xmax = m.bounds.corner(1).x.to_f
	ymin = m.bounds.corner(0).y.to_f
	ymax = m.bounds.corner(2).y.to_f
	zmin = m.bounds.corner(0).z.to_f
	zmax = m.bounds.corner(4).z.to_f
	f.puts "#{xmin}\n#{xmax}\n#{ymin}\n#{ymin}\n#{zmin}\n#{zmin}"
end
=end
def removeDefaultMan(e)
	components = getComponents(e)
	for i in 0..components.length-1
		e.erase_entities components[i] if components[i].definition.guid == '93ba26f1-af81-4a24-8507-8c8501f9d866'
	end	
end
def removeImage(e)
	while (containImage(e))
		for i in 0..e.length-1
			if e[i].typename == "Image" 
				e.erase_entities(e[i])
				break
			end
		end
	end
end
# prints xmin, ymin, zmin, xmax, ymax, zmax, affine transform matrix, result is boxes
def printSegmentedComponents(e)
	components = []
	for i in 0..e.length-1
	  if e[i].typename == "ComponentInstance"
		#puts "#{i}"
		components.push(e[i])
	  end
	end

	for j in 0..components.length-1
	  comp = components[j];

	  ents = comp.definition.entities
	  edges = []

	  for i in 0..ents.length-1
		if ents[i].typename == "Edge"
		  edges.push(ents[i])
		end
	  end
	  if edges.length==1
		next
	  end
	  points = []
	  for i in 0..edges.length-1
		if !points.include?(edges[i].vertices[0].position)
		  points.push(edges[i].vertices[0].position)
		end
		if !points.include?(edges[i].vertices[1].position)
		  points.push(edges[i].vertices[1].position)
		end
	  end

	  if points.length==0
		next
	  end

	  #puts "2 #{points}"
	  # min and max x
	  xmin = 10000
	  for i in 0..points.length-1
		if points[i].x.to_f < xmin
		  xmin = points[i].x.to_f
		end
	  end
	  xmax = -10000
	  for i in 0..points.length-1
		if points[i].x.to_f > xmax
		  xmax = points[i].x.to_f
		end
	  end
	  # min and max y
	  ymin = 10000
	  for i in 0..points.length-1
		if points[i].y.to_f < ymin
		  ymin = points[i].y.to_f
		end
	  end
	  ymax = -10000
	  for i in 0..points.length-1
		if points[i].y.to_f > ymax
		  ymax = points[i].y.to_f
		end
	  end
	  # min and max z
	  zmin = 10000
	  for i in 0..points.length-1
		if points[i].z.to_f < zmin
		  zmin = points[i].z.to_f
		end
	  end
	  zmax = -10000
	  for i in 0..points.length-1
		if points[i].z.to_f > zmax
		  zmax = points[i].z.to_f
		end
	  end

	  #puts "#{points}"
	  #puts "#{j}: #{comp.name}"

	  File.open('C:/3DWarehouse/Matlab/done.txt','a') do |f|
		f.puts "#{xmin}\n #{xmax}"
		f.puts "#{ymin}\n #{ymax}"
		f.puts "#{zmin}\n #{zmax}"
		for i in 0..15
		  f.puts "#{comp.transformation.to_a[i]}"
		end
		#puts "#{comp.transformation.origin}, #{comp.transformation.xaxis},#{comp.transformation.yaxis},#{comp.transformation.zaxis}"
		f.close
	  end
	end
end

# prints vertices and transformations, basically just extracting edges
def printSegmentedComponentsWithFaces(e)
	# first get all components
	components = []
	for i in 0..e.length-1
		if e[i].typename == "ComponentInstance"
			components.push(e[i])
		end
	end
	
	f = File.new('C:/3DWarehouse/Matlab/compsWithFaces.txt', 'w')
	for j in 1..components.length-1 # iterate over all components
		comp = components[j];
		ents = comp.definition.entities
		# find all edges
		edges = []
		for k in 0..ents.length-1
			edges.push(ents[k]) if (ents[k].typename == "Edge" && !edges.include?(ents[k]))
		end
		puts "#{edges.length})"
		next if edges.length > 200
		for i in 0..edges.length-1
			onePointX = edges[i].vertices[0].position.x.to_f
			onePointY = edges[i].vertices[0].position.y.to_f
			onePointZ = edges[i].vertices[0].position.z.to_f
			otherPointX = edges[i].vertices[1].position.x.to_f
			otherPointY = edges[i].vertices[1].position.y.to_f
			otherPointZ = edges[i].vertices[1].position.z.to_f
			f.puts "#{onePointX}\n #{onePointY}"
			f.puts "#{onePointZ}\n #{otherPointX}"
			f.puts "#{otherPointY}\n #{otherPointZ}"
			f.puts "0"
			for i in 0..15
				f.puts "#{comp.transformation.to_a[i]}"
			end
			f.puts "0"
		end
	end
	f.close
end

# explodes all subcomponents, then exports faces
def printSegmentedComponentsWithMesh(e)
	f = File.new('C:/3DWarehouse/Matlab/compsWithMesh.txt', 'w')
	components = getComponents(e)
	for i in 19..19#components.length-1
		#puts "#{components[i].name} #{i}"
		explodeAllComponents(components[i].definition.entities)
		for j in 0..components[i].definition.entities.length-1
			if components[i].definition.entities[j].typename == "Face"
				points = components[i].definition.entities[j].mesh.points
				polygons = components[i].definition.entities[j].mesh.polygons
				for k in 0..points.length-1
					f.puts "#{points[k].x.to_f}\n#{points[k].y.to_f}\n#{points[k].z.to_f}\n"
				end
				f.puts "a\n"
				for k in 0..polygons.length-1
					f.puts "#{polygons[k][0]}\n#{polygons[k][1]}\n#{polygons[k][2]}\n"
				end
				f.puts "a\n"
			end
		end
	end
	f.close
end

# exports faces without exploding subcomponents, only 2 subcomponents deep
def printSegmentedComponentsWithMeshNoExplode(e)
	components = getComponents(e)
	f = File.new('C:/3DWarehouse/Matlab/compsWithMeshNoExplode.txt', 'w')
	for i in 0..components.length-1
		f.puts "New Instance"
		if containsFaces(components[i].definition.entities)
			f.puts "Transformation"
			for j in 0..15
				f.puts "#{components[i].transformation.to_a[j]}"
			end
			for j in 0..components[i].definition.entities.length-1
				if components[i].definition.entities[j].typename == "Face"
					points = components[i].definition.entities[j].mesh.points
					polygons = components[i].definition.entities[j].mesh.polygons
					for k in 0..points.length-1
						f.puts "#{points[k].x.to_f}\n#{points[k].y.to_f}\n#{points[k].z.to_f}\n"
					end
					f.puts "a\n"
					for k in 0..polygons.length-1
						f.puts "#{polygons[k][0]}\n#{polygons[k][1]}\n#{polygons[k][2]}\n"
					end
					f.puts "a\n"
				end
			end
		end

		if containInstances(components[i].definition.entities)
			subComponents = getComponents(components[i].definition.entities)
			for j in 0..subComponents.length-1
				f.puts "Transformation"
				for k in 0..15
					f.puts "#{(components[i].transformation.* subComponents[j].transformation).to_a[k]}"
				end
				
				for k in 0..subComponents[j].definition.entities.length-1
					if subComponents[j].definition.entities[k].typename == "Face"
						points = subComponents[j].definition.entities[k].mesh.points
						polygons = subComponents[j].definition.entities[k].mesh.polygons
						for l in 0..points.length-1
							f.puts "#{points[l].x.to_f}\n#{points[l].y.to_f}\n#{points[l].z.to_f}\n"
						end
						f.puts "a\n"
						for l in 0..polygons.length-1
							f.puts "#{polygons[l][0]}\n#{polygons[l][1]}\n#{polygons[l][2]}\n"
						end
						f.puts "a\n"
					end
				end
			end	
			subGroups = getGroups(components[i].definition.entities)
			puts "#{components[i].name}#{subGroups.length}"
			for j in 0..subGroups.length-1
				f.puts "Transformation"
				for k in 0..15
					f.puts "#{(components[i].transformation.* subGroups[j].transformation).to_a[k]}"
				end
				for k in 0..subGroups[j].entities.length-1
					if subGroups[j].entities[k].typename == "Face"
						points = subGroups[j].entities[k].mesh.points
						polygons = subGroups[j].entities[k].mesh.polygons
						for l in 0..points.length-1
							f.puts "#{points[l].x.to_f}\n#{points[l].y.to_f}\n#{points[l].z.to_f}\n"
						end
						f.puts "a\n"
						for l in 0..polygons.length-1
							f.puts "#{polygons[l][0]}\n#{polygons[l][1]}\n#{polygons[l][2]}\n"
						end
						f.puts "a\n"
					end
				end
			end
		end
	end
	f.close
end

def printSegmentedComponentsDFS(e)
	f = File.new('C:/3DWarehouse/Matlab/compsWithMeshDFS.txt', 'w')
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
						#instance.definition.entities[j].name = '21'
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
						#instance.entities[j].name = '21'
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
				next if instance.definition.entities.length > 2000
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
				next if instance.entities.length > 2000
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
	f.puts "done"
	
	m = e.model
	xmin = m.bounds.corner(0).x.to_f
	xmax = m.bounds.corner(1).x.to_f
	ymin = m.bounds.corner(0).y.to_f
	ymax = m.bounds.corner(2).y.to_f
	zmin = m.bounds.corner(0).z.to_f
	zmax = m.bounds.corner(4).z.to_f
	f.puts "#{xmin}\n#{xmax}\n#{ymin}\n#{ymax}\n#{zmin}\n#{zmax}"
	walls = getAllWalls(e)
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
	f.close
end

m = Sketchup.active_model
e = m.entities
#printSegmentedComponentsDFS(e)

# use only when finding walls and walls are grouped into components, etc
#explodeAllComponents(e)
# prints all the walls (x1, y1, z1, x2, y2, z2)
#printWallEdges(getAllWalls(e))
#printSegmentedComponentsWithFaces(e)
#printSegmentedComponentsWithMeshNoExplode(e)
#removeDefaultMan(e)
#removeImage(e)
comp=0
edge=0
group=0

#for i in 0..e.length-1
#puts "#{e[i]}"
#if e[i].typename=="ComponentInstance"
#comp=comp+1
#end

#end
#perc=1.0*comp/e.length
#puts "#{comp} #{e.length} #{perc}"
