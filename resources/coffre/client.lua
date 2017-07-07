
local isCop = false
local coffre = {
  {x=452.98638916016, y=-973.20837402344, z=29.689601898193},
}



function drawTxt(text,font,centre,x,y,scale,r,g,b,a)
  SetTextFont(font)
  SetTextProportional(0)
  SetTextScale(scale, scale)
  SetTextColour(r, g, b, a)
  SetTextDropShadow(0, 0, 0, 0,255)
  SetTextEdge(1, 0, 0, 0, 255)
  SetTextDropShadow()
  SetTextOutline()
  SetTextCentre(centre)
  SetTextEntry("STRING")
  AddTextComponentString(text)
  DrawText(x , y)
end



function DisplayHelpText(str)
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

















Citizen.CreateThread(function()
    while true do
      for i = 1, #coffre do
        Citizen.Wait(0)
          if(isCop == false) then
            DrawMarker(1,coffre[i].x,coffre[i].y,coffre[i].z,0,0,0,0,0,0,0.5,0.5,0.5,255,255,0,200,0,0,0,0)
            if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), coffre[i].x,coffre[i].y,coffre[i].z,true ) < 1.5 then
              DisplayHelpText('Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le coffre',0,1,0.5,0.8,0.6,255,255,255,255)
              if (IsControlJustPressed(1,51)) then
                  OpenfbiMenu()

               
              end

          
            end
          end
      end
       


    end

end)

