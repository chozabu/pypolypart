from libc.stdlib cimport malloc, free
from libcpp.list cimport list as cpplist

cdef class Point:
    cdef TPPLPoint _p
    
    property x:
        def __get__(self):
            return self._p.x
        def __set__(self, xpos):
            self._p.x = xpos
    property y:
        def __get__(self):
            return self._p.y
        def __set__(self, ypos):
            self._p.y = ypos
            
    def __add__(self, other):
        return self._p+other._p
    def __str__(self):
        return str(self._p.x) +" "+ str(self._p.y)
cdef class Poly:
    cdef TPPLPoly _p
    cdef int pointnum
    
    property pnum:
        def __get__(self):
            return self.pointnum
    def __cinit__(self):
        self.pointnum = 0
    def setPoints(self, points, isHole):
        cdef int ix
        numpoints = len(points)
        self.pointnum = numpoints
        self._p.Init(numpoints)
        #self._p->Init(numpoints);
        if isHole: self._p.SetHole(True);

        _points = self._p.GetPoints()
        for i in range(numpoints):
            ix=i
            p=points[i]
            _points[i].x=p[0]
            _points[i].y=p[1]
    def getPoints(self):
        cdef int ix
        points = self._p.GetPoints()
        rlist = []
        rlistappend = rlist.append
        for i in range(self.pointnum):
            ix=i
            rlistappend((points[ix].x, points[ix].y))
        return rlist
cdef class Partition:
    #int Triangulate_EC(TPPLPoly *poly, std::list<TPPLPoly> *triangles)
    cdef TPPLPartition _p
    def Triangulate_EC(self, Poly poly):
        cdef TPPLPoly rpoly
        cdef TPPLPoly _tpoly
        cdef TPPLPoly* _poly
        cdef cpplist[TPPLPoly] _result
        cdef cpplist[TPPLPoly]* result=&_result
        _tpoly=poly._p
        _poly=&_tpoly
        self._p.Triangulate_EC(_poly, result)
        triangles = []
        for r in range(result.size()):
            triangle = []
            rpoly = result.front()
            result.pop_front()
            pnum = rpoly.GetNumPoints()
            ps= rpoly.GetPoints()
            for subp in range(pnum):
                triangle.append ((ps[subp].x, ps[subp].y))
            triangles.append(triangle)
        return triangles
    #int ConvexPartition_HM(TPPLPoly *poly, std::list<TPPLPoly> *parts);
    def ConvexPartition_HM(self, Poly poly):
        cdef TPPLPoly rpoly
        cdef TPPLPoly _tpoly
        cdef TPPLPoly* _poly
        cdef cpplist[TPPLPoly] _result
        cdef cpplist[TPPLPoly]* result=&_result
        _tpoly=poly._p
        _poly=&_tpoly
        self._p.ConvexPartition_HM(_poly, result)
        triangles = []
        for r in range(result.size()):
            triangle = []
            rpoly = result.front()
            result.pop_front()
            pnum = rpoly.GetNumPoints()
            ps= rpoly.GetPoints()
            for subp in range(pnum):
                triangle.append ((ps[subp].x, ps[subp].y))
            triangles.append(triangle)
        return triangles
def polys_to_tris_and_hulls(polys, holes=[]):
    cdef TPPLPartition pp
    cdef cpplist[TPPLPoly]* cpolys = new cpplist[TPPLPoly]()
    cdef cpplist[TPPLPoly]* noholepolys = new cpplist[TPPLPoly]()
    cdef cpplist[TPPLPoly]* ctriangles = new cpplist[TPPLPoly]()
    cdef cpplist[TPPLPoly]* chulls = new cpplist[TPPLPoly]()
    cdef TPPLPoly cpoly
    cdef TPPLPoly* cpolyp
    print "converting polys to C"
    for p in polys:
        
        pypoly=p
        numpoints = len(p)
        cpolyp = new TPPLPoly()
        cpoly = cpolyp[0]
        cpoly.Init(numpoints)
        _points = cpoly.GetPoints()
        for i in xrange(numpoints):
            ix=i
            npoint=pypoly[i]
            print pypoly[i]
            _points[i].x=npoint[0]
            _points[i].y=npoint[1]
        for i in xrange(numpoints):
            ix=i
            print _points[i].x
        print "pushing poly"
        cpolys.push_back(cpoly)
        print "pushed poly"
    
    #print cpolys[0][0].GetPoints()[0].x
    #cpoly = cpolys[0][0]
    #print cpoly
    print "pointcheck"
    print _points[0].x
    print "removing holes"
    pp.RemoveHoles(cpolys, noholepolys)
    print "triangulating"
    pp.Triangulate_EC(noholepolys, ctriangles)
    print "generating hulls"
    pp.ConvexPartition_HM(noholepolys, chulls)
    
    triangles = []
    for r in range(ctriangles.size()):
        triangle = []
        rpoly = ctriangles.front()
        ctriangles.pop_front()
        pnum = rpoly.GetNumPoints()
        ps= rpoly.GetPoints()
        for subp in range(pnum):
            triangle.append ((ps[subp].x, ps[subp].y))
        triangles.append(triangle)
            
    hulls = []
    for r in range(chulls.size()):
        hull = []
        rpoly = chulls.front()
        chulls.pop_front()
        pnum = rpoly.GetNumPoints()
        ps= rpoly.GetPoints()
        for subp in range(pnum):
            hull.append ((ps[subp].x, ps[subp].y))
        hulls.append(hull)
    
    return {"triangles":triangles, "hulls":hulls}
    