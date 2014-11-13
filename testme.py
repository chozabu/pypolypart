import pypolypart
print dir(pypolypart)
for i in range(3):
    print dir(pypolypart)[i]
    print dir(getattr(pypolypart,dir(pypolypart)[i]))
    
print "\n testing points"
a = pypolypart.Point()
print a
a.x=5
a.y=5
print a
b = pypolypart.Point()
b.x=3
b.y=6
print b

#print b
#print "a.x"
#print a.x
#print a.p
#print "a+b"
#print a+b

print "\ntesting poly"
c=pypolypart.Poly()
#c.Init(3)
poly1 = [(0,0),(10,0), (9,5), (10,10),(0,10)]
c.setPoints(poly1,False)
print "pointnum=",c.pnum
print "points=",c.getPoints()
#c[0]=a


print "\n testing partitions"
pp=pypolypart.Partition()
print "made partition object:", pp
print "triangles", pp.Triangulate_EC(c)
print "hulls", pp.ConvexPartition_HM(c)

print "\n combi triangles and hulls method, single poly"
print pypolypart.polys_to_tris_and_hulls([poly1])


print "\n combi triangles and hulls method, two polys"
poly2 = [(99+0,0),(99+10,0), (99+9,5), (99+10,10),(99+0,10)]
print pypolypart.polys_to_tris_and_hulls([poly1, poly2])

print "\n combi triangles and hulls method, poly with hole"
hole1 = [(1,1),(1,3), (3,1)]
print pypolypart.polys_to_tris_and_hulls([poly1], [hole1])
