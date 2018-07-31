import pypolypart

def simplify_poly(pin, mindist=5):
    pout = []
    lastp = None
    skipcount = 0
    for p in pin:
        if not lastp:
            lastp = p
            pout.append(p)
        else:
            xd = p[0]-lastp[0]
            yd = p[1]-lastp[1]
            if xd*xd+yd*yd > mindist:
                lastp = p
                pout.append(p)
            else:
                skipcount +=1
    print("removed verts: ", skipcount)
    return pout

print "bbtest"

fullpol = [( 418., 418.), ( 378.33333333, 338.33333333), ( 360., 326.), ( 344., 295.), ( 330.375, 250.375), ( 330.375, 250.375), ( 288.2, 274. ), ( 288.2, 274. ), ( 212. , 158.28571429), ( 232.66666667, 136.33333333), ( 232.66666667, 136.33333333), ( 212. , 158.28571429), ( 212. , 158.28571429), ( 212. , 158.28571429), ( 212. , 158.28571429), ( 212. , 158.28571429), ( 181.45454545, 187.81818182), ( 181.45454545, 187.81818182), ( 181.45454545, 187.81818182), ( 181.45454545, 187.81818182), ( 229.2, 264.4), ( 229.2, 264.4), ( 157.33333333, 304.33333333), ( 124.5 , 325.25), ( 124.5 , 325.25), ( 145., 341.), ( 296.5 , 391.25), ( 296.5 , 391.25), ( 296.5 , 391.25), ( 296.5 , 391.25), ( 329.5, 403. ), ( 329.5, 403. ), ( 380., 422.), ( 418., 418.)]

#has a very thin bit, so trimmed:
pol = [( 212. , 158.28571429), ( 212. , 158.28571429), ( 212. , 158.28571429), ( 212. , 158.28571429), ( 181.45454545, 187.81818182), ( 181.45454545, 187.81818182), ( 181.45454545, 187.81818182), ( 181.45454545, 187.81818182), ( 229.2, 264.4), ( 229.2, 264.4), ( 157.33333333, 304.33333333), ( 124.5 , 325.25), ( 124.5 , 325.25), ( 145., 341.), ( 296.5 , 391.25), ( 296.5 , 391.25), ( 296.5 , 391.25), ( 296.5 , 391.25), ( 329.5, 403. ), ( 329.5, 403. ), ( 380., 422.), ( 418., 418.)]


#needs to be CW winding
pol.reverse()
#pol = pol[::3]# lame method to reduce complexity...

pol = simplify_poly(pol)

hulls_and_tris = pypolypart.polys_to_tris_and_hulls([pol])
print hulls_and_tris
hulls = hulls_and_tris['hulls']
tris =  hulls_and_tris['triangles']

import sys, pygame
pygame.init()

size = width, height = 500, 500
speed = [2, 2]
black = 0, 0, 0

screen = pygame.display.set_mode(size)

while 1:
    for event in pygame.event.get():
        if event.type == pygame.QUIT: sys.exit()

    screen.fill(black)
    ic = 5
    for p in pol:
        j = (int(p[0]), int(p[1]))
        ic+=1
        pygame.draw.circle(screen, (0,128,0), j, ic)
    
    pygame.draw.polygon(screen, (128,128,128), pol, 10)
    for h in hulls:
        pygame.draw.polygon(screen, (0,0,128), h, 6)
    for h in tris:
        pygame.draw.polygon(screen, (128,0,0), h, 2)
    pygame.display.flip()
