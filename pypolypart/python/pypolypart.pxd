from libcpp.list cimport list as cpplist

ctypedef double tppl_float
ctypedef bint bool


cdef extern from "polypartition.h":
    #ctypedef extern struct TPPLPoint:
    cppclass TPPLPoint:
      TPPLPoint()
      tppl_float x
      tppl_float y
      #
      #bool operator+(bool)
      #double* operator+(double*)
      TPPLPoint operator+(const TPPLPoint& other) 
      #TPPLPoint add "operator+"(const TPPLPoint& other) 
      TPPLPoint sub "operator-"(const TPPLPoint& other)
      TPPLPoint multiply "operator*"(const TPPLPoint& other) 
      TPPLPoint divide "operator/"(const TPPLPoint& other)
    
    cppclass TPPLPoly:
        TPPLPoly()
        
        TPPLPoly(const TPPLPoly &src)
        
        TPPLPoly& operator[](int)
        
        #getters and setters
        long GetNumPoints()
        
        bool IsHole()
        
        void SetHole(bool hole)
        
        TPPLPoint &GetPoint(long i)
        
        TPPLPoint *GetPoints()
        
        #clears the polygon points
        void Clear();
        
        #inits the polygon with numpoints vertices
        void Init(long numpoints);
        
        #creates a triangle with points p1,p2,p3
        void Triangle(TPPLPoint &p1, TPPLPoint &p2, TPPLPoint &p3);
        
        #inverts the orfer of vertices
        void Invert();
        
        #returns the orientation of the polygon
        #possible values:
        #   TPPL_CCW : polygon vertices are in counter-clockwise order
        #   TPPL_CW : polygon vertices are in clockwise order
        #       0 : the polygon has no (measurable) area
        int GetOrientation();
        
        #sets the polygon orientation
        #orientation can be
        #   TPPL_CCW : sets vertices in counter-clockwise order
        #   TPPL_CW : sets vertices in clockwise order
        void SetOrientation(int orientation);

    cppclass TPPLPartition:
        int Triangulate_EC(TPPLPoly *poly, cpplist[TPPLPoly]* triangles)
        int Triangulate_EC(cpplist[TPPLPoly]* inpolys, cpplist[TPPLPoly]* triangles)
        int ConvexPartition_HM(TPPLPoly *poly, cpplist[TPPLPoly]* parts)
        int ConvexPartition_HM(cpplist[TPPLPoly]* inpolys, cpplist[TPPLPoly]* parts)
        int RemoveHoles(cpplist[TPPLPoly] *inpolys, cpplist[TPPLPoly] *outpolys);
        

