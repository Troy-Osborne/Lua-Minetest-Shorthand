--To do line 111 creat dialog on click to replace active scheme

default_shorthand_symbols={}
default_shorthand_symbols["_"]="default:air"
default_shorthand_stacks={}

function setnode (x,y,z,string) 
  --print(math.floor(x).." "..math.floor(y).." "..math.floor(z).." "..string)
  --print("minetest.set_node({ x = "..x..", y = "..y..", z = "..z.."}, { name = "..string.." })")
  minetest.set_node({x=x, y=y, z=z}, {name = string})
end

setnode(1,1,1,"default:dirt")


function add_shorthand_symbol(symbol_dict,symbol,value)
symbol_dict[symbol]=value
end

add_shorthand_symbol(default_shorthand_symbols,"d","default:dirt")
add_shorthand_symbol(default_shorthand_symbols,"g","default:dirt_with_grass")
add_shorthand_symbol(default_shorthand_symbols,"0","default:wood")
add_shorthand_symbol(default_shorthand_symbols,"1","default:pine_wood")
add_shorthand_symbol(default_shorthand_symbols,"2","default:aspen_wood")


function add_shorthand_stack(stack_dict,symbol,values)
stack_dict[symbol]=values
end

add_shorthand_stack(default_shorthand_stacks,"0","00000")
add_shorthand_stack(default_shorthand_stacks,"w","00_00")
add_shorthand_stack(default_shorthand_stacks,"d","0__00")
add_shorthand_stack(default_shorthand_stacks,",","0___0")

function measure_grid(shorthandgrid)
  xsize=0
  ysize=1
  zsize=1
  currentx=0
  for i = 1, #shorthandgrid do
    local c = shorthandgrid:sub(i,i)
    if c=="\n" then
      zsize=zsize+1
      if currentx > xsize then xsize=currentx end
      currentx=0
  else 
    currentx=currentx+1
    if #default_shorthand_stacks[c]>ysize then ysize=#default_shorthand_stacks[c] end
end
end
return xsize, ysize, zsize
end

function place_nodegrid(shorthandgrid,xoffset,yoffset,zoffset) --takes a grid of shorthand symbols and returns a 2d table of nodes
  if xoffset==nil then xoffset=-1 end
    if yoffset==nil then yoffset=-1 end
      if zoffset==nil then zoffset=-1 end
  nodecount=0
  xpos=0
  zpos=1
  for i = 1, #shorthandgrid do
    local c = shorthandgrid:sub(i,i)
    if c=="\n" then
      zpos=zpos+1
      xpos=0
  else 
    xpos=xpos+1
    currentstack=default_shorthand_stacks[c]
    for ypos = 1, #currentstack do
local node=default_shorthand_symbols[currentstack:sub(ypos,ypos)]
    setnode(xpos+xoffset,ypos+yoffset,zpos+zoffset,node)
      nodecount=nodecount+1
      end
    
end
end
return nodecount
end

function measure_and_place_grid(shorthand,pos)
  if pos==nil then pos={x=0, y=0, z=0} end
   xsize,ysize,zsize= measure_grid(default_object)
  print(place_nodegrid(default_object,-math.ceil(xsize/2)+pos.x,-math.ceil(ysize/2)+pos.y,-math.ceil(zsize/2)+pos.z))
    end

default_object="000w0w0w000\n0,,,,,,,,,0\nw,,,,,,,,,d\nw,,,,,,,,,0\n0,,,,,,,,,0\n00w00d00000"
measure_and_place_grid(default_object)


--print(measure_grid(default_object))
--print(place_nodegrid(default_object))

minetest.register_node("shorthand:ascii_stacks",{
description= "Make Shorthand",
sunlight_propagates=true,
use_texture_alpha=true,
value=mystring,
active_string=default_object,
on_construct = function(pos, node)
  measure_and_place_grid(mystring,pos)
  end,
on_use = get_new_input(), --open minetest dialog with monospaced textarea for writing or pasting shorthand building codes / ascii art
tiles = { 'fastbuilder.png' },
inventory_image = 'fastbuilder_inventory.png',
wield_image = 'fastbuilder_weild.png',
	paramtype = 'light',
	buildable_to = true,
})