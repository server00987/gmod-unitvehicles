include('shared.lua') 
  
function ENT:Draw()   
	if !uvtargeting then
		self.Entity:DrawModel() 
	end
end
