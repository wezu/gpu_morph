from panda3d.core import *
from direct.gui.DirectGui import *
from direct.showbase import ShowBase
import struct
from random import random
import json
from direct.actor.Actor import Actor

NUM_VERT=256*256 #a lot, don't know how many I need

def addMorph(morph_name):
    buffer = Texture("texbuffer")
    buffer.setup_buffer_texture(NUM_VERT, Texture.T_float, Texture.F_rgb32, GeomEnums.UH_static)
    with open(morph_name) as f: 
        morph=json.load(f)
    image = memoryview(buffer.modify_ram_image())    
    for i in range(len(morph)):
        off = i * 12    
        image[off:off+12] = struct.pack('fff', morph[i][0], morph[i][1], morph[i][2])
    return buffer

def setWeight(slider, model, name): 
    model.setShaderInput(name, float(slider['value']))

base = ShowBase.ShowBase()

model=Actor("index_tbn", {"idle": "idle"})
model.reparentTo(render)
model.setShader(Shader.load(Shader.SLGLSL, "morph_v.glsl", "morph_f.glsl"))
model.loop("idle")
attr = ShaderAttrib.make(Shader.load(Shader.SLGLSL, "morph_v.glsl", "morph_f.glsl"))
attr = attr.setFlag(ShaderAttrib.F_hardware_skinning, True)
model.setAttrib(attr)
        
fat_morph=addMorph("fat.json")
model.setShaderInput('morph1',fat_morph)
model.setShaderInput('weight1', 0.0)

slim_morph=addMorph("slim.json")
model.setShaderInput('morph2',slim_morph)
model.setShaderInput('weight2', 0.0)

muscle_morph=addMorph("muscle.json")
model.setShaderInput('morph3',muscle_morph)
model.setShaderInput('weight3', 0.0)

#add a light
dlight = DirectionalLight('dlight')
dlight.setColor(Vec4(1.0, 1.0, 1.0, 1.0))
dirLight = render.attachNewNode(dlight)
render.setLight(dirLight)
dirLight.setPos(base.camera.getPos())
dirLight.setHpr(base.camera.getHpr())
dirLight.wrtReparentTo(base.camera)

#add sliders
slider1 = DirectSlider(range=(0.0,1.0), value=0.0, scale=0.5, pos=(0.0,0.0,-0.6), command=setWeight)
slider1['extraArgs']=[slider1, model, 'weight1']


slider2 = DirectSlider(range=(0.0,1.0), value=0.0, scale=0.5, pos=(0.0,0.0,-0.7), command=setWeight)
slider2['extraArgs']=[slider2, model, 'weight2']


slider3 = DirectSlider(range=(0.0,1.0), value=0.0, scale=0.5, pos=(0.0,0.0,-0.8), command=setWeight)
slider3['extraArgs']=[slider3, model, 'weight3']


base.run()
