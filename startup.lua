local modem = peripheral.find("modem")
sleep(1)
local monitor = peripheral.find("monitor") 
local sizex, sizey
if (modem) then
    if (monitor) then 
        print("Monitor found! Connecting...")
        monitor.setCursorBlink(false)
        monitor.setTextScale(1.3)
        sizex, sizey = monitor.getSize()
    else
        print("Monitor not found")
    end 
    for i=1, 11 do 
        -- print(modem.getNamesRemote()[i])
        if (modem.getNamesRemote()[i] == "storagedrawers:controller_0" or "refinedstorage_1") then
            sleep(1)
            left = peripheral.wrap("storagedrawers:controller_0")
            if left then print("Found Drawer Controller!!") end
            right = peripheral.wrap("refinedstorage_1")
            if right then 
                print("Found computer!")
                left = nil
            end 
            sleep(1)
             
            -- ================================           
            x = true
            oldsorted = {}
            while x do       
                if monitor then
                    monitor.setCursorPos(1, 1)
                end        
                sorted = {}
                n = 1
                if left then
                    for slot, item in pairs(left.list()) do
                        sorted[n] = {} 
                        sorted[n]["displayName"] = left.getItemDetail(slot).displayName
                        sorted[n]["count"] = item.count
                        sorted[n]["maxCount"] = left.getItemLimit(slot)
                        n = n + 1
                    end
                    table.sort(sorted, function(a, b) return a.displayName < b.displayName end)
                elseif right then
                    sorted = right.getItems()
                    n = 58
                    table.sort(sorted, function(a, b) return a.count >  b.count  end)
                end
                
                if oldsorted[1]  == nil  then 
                    oldsorted = sorted 
                end 
                
                if monitor then monitor.clear() end 
                
                for n = 1, n - 1 do
                    if monitor then
                        a, b = monitor.getCursorPos()
                        if b == sizey+1 then 
                            monitor.setCursorPos(a + 24 , 1)
                            a, b = monitor.getCursorPos() 
                        end
                        
                        if sorted[n].count > oldsorted[n].count then
                            monitor.setTextColour(colours.green) 
                            monitor.write("/\\")
                        elseif sorted[n].count < oldsorted[n].count then
                            monitor.setTextColour(colours.red)
                            monitor.write("\\/")
                        else
                            monitor.setTextColour(colours.yellow )
                            monitor.write("||")
                        end
                        
                        monitor.setTextColour(9)
                        monitor.write(sorted[n].displayName)
                        if a > 40 then
                            monitor.setCursorPos(62, b)
                        elseif a > 20 then
                            monitor.setCursorPos(40, b)
                        else 
                            monitor.setCursorPos(16, b)
                        end 
                        
                        if sorted[n].count > sorted[n].maxCount-1 and left then
                            monitor.setTextColour(colours.red)
                        elseif  sorted[n].count < sorted[n].maxCount-1 or right then
                            monitor.setTextColour(2)
                        else
                            monitor.setTextColour(colours.green) 
                        end  
                        monitor.write(" :" .. sorted[n].count .. "   ")
                        monitor.setCursorPos(a, b+1)
                        sleep(0.01) 
                    else
                        print(sorted[n].displayName .. ":" .. sorted[n].count)
                     end
                end
                if monitor and left then
                    monitor.setCursorPos(sizex - 15, sizey - 3)
                    monitor.setTextColour(colours.green)
                    monitor.write("GREEN")
                    monitor.setTextColour(colours.white)
                    monitor.write(" = EMPTY")
                    monitor.setCursorPos(sizex - 15, sizey - 2)
                    monitor.setTextColour(2)
                    monitor.write("AMBER")
                    monitor.setTextColour(colours.white )
                    monitor.write(" = FILLING \r  ")
                    monitor.setCursorPos(sizex - 15 , sizey - 1)
                    monitor.setTextColour(colours.red) 
                    monitor.write("RED")
                    monitor.setTextColour(1)
                    monitor.write(" = FULL")
                
                elseif monitor and right then
                    for l = 1, 19 do
                        monitor.setCursorPos(70  , l )
                        monitor.write("             ")
                    end
                end
             
                oldsorted = sorted
                sleep(20)
            end 
            break 
        else  
            if (i == 11) then  print("Controller not found...") end   
        end
    end
end
