include('shared.lua') 
  
function ENT:Draw()   
	if not UVTargeting then
		self.Entity:DrawModel() 
	end
end
