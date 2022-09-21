import pygame as pg
from pygame.locals import *

from OpenGL.GL import *
from OpenGL.GLU import *

import mixbox

pg.init()
pg.display.set_mode((640, 480), DOUBLEBUF | OPENGL)

while True:
  rgb1 = (0.0, 0.129, 0.522) # blue
  rgb2 = (0.988, 0.827, 0.0) # yellow

  n = 640
  glBegin(GL_LINES)
  for i in range(0, n+1):
    glColor(mixbox.lerp_float(rgb1, rgb2, i / n))
    glVertex((i / n)*2 - 1, -1)
    glVertex((i / n)*2 - 1, +1)
  glEnd()

  pg.display.flip()

  for event in pg.event.get():
    if event.type == pg.QUIT:
      pg.quit()
      quit()
