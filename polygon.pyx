__all__ = ("Polygon", "MultiShapePolygon")

import warnings
import random
from kivy._event cimport EventDispatcher
from kivy.properties import NumericProperty, ListProperty, AliasProperty

class Polygon(EventDispatcher):
    abs_vertices = ListProperty([])
    x = NumericProperty(0)
    y = NumericProperty(0)
    scale = NumericProperty(1)

    def _get_vertices(self):
            cdef int x
            cdef int y
            return [(x*self.scale+self.x, y*self.scale+self.y) for x, y in self.abs_vertices]
    vertices = AliasProperty(_get_vertices, None)

    def collide_point(self, x, y):
        return point_in_polygon(self, x, y)

    def collide_polygon(self, polygon):
        cdef int x, y
        cdef list polys, rpolys
        cdef tuple tup

        # Check for same polygon
        if self == polygon or self.vertices == polygon.vertices:
            return True

        # Sort by vertex number to reduce the number of iterations
        polys = [self, polygon]
        polys = sorted(polys, key=lambda x: len(x.vertices))
        rpolys = polys[:]
        rpolys.reverse()

        # Check for common vertices
        for tup in polys[0].vertices:
            if tup in polys[1].vertices:
                return True

        # Collide each point with the other polygon
        for p in rpolys:
            for tup in p.vertices:
                if polys[rpolys.index(p)].collide_point(*tup):
                    return True

        return False

    def collide_widget(self, wid):
        if isinstance(wid, Polygon):
            p = wid
        else:
            p = Polygon(vertices=[(0, 0),                  # bottom left
                                  (wid.width, 0),          # bottom right
                                  (wid.width, wid.height), # top right
                                  (0, wid.height)],        # top left
                        x=wid.x, y=wid.y)

        return self.collide_polygon(p)

    def __contains__(self, obj):
        if isinstance(obj, Polygon):
            return self.collide_polygon(obj)
        else:
            return point_in_polygon(self, obj[0], obj[1])

cdef bint point_in_polygon(object polygon, int x, int y):
    cdef list xs, ys
    cdef int xp1, yp1, xp2, yp2
    cdef int count = 0
    cdef double x_inters

    # This strangely happens. IDK
    if len(polygon.abs_vertices) == 0:
        warnings.warn("Polygon has no vertices: {0}".format(str(polygon)), RuntimeWarning, stacklevel=2)
        return 0

    # If the point is a vertex, it's in the polygon
    if (x, y) in polygon.vertices:
        return 1

    xs = [i[0] for i in polygon.vertices]
    ys = [i[1] for i in polygon.vertices]

    # if the point is outside of the polygon's bounding
    # box, it's not in the polygon
    if (x > max(*xs) or x < min(*xs)) or \
       (y > max(*ys) or y < min(*ys)):
        return 0

    xp1, yp1 = polygon.vertices[-1]  # Start with first and last vertices
    for xp2, yp2 in polygon.vertices:
        # Check if point is between lines y=yp1 and y=yp2
        if y <= max(yp1, yp2) and y >= min(yp1, yp2):
            # Get the intersection with the line that passes
            # through p1 and p2
            x_inters = float(xp2-xp1)*float(y-yp1)/float(yp2-yp1)+xp1

            # If x is less than or equal to x_inters,
            # we have an intersection
            if x <= x_inters:
                count += 1
        
        xp1, yp1 = xp2, yp2

    # If the intersections are even, the point is outside of
    # the polygon.
    return count % 2 != 0 and 1 or 0

class MultiShapePolygon(Polygon):
    shape = NumericProperty(0)
    shapes = ListProperty([])
    _shapes = []

    def __init__(self, **kwargs):
        super(MultiShapePolygon, self).__init__(**kwargs)
        self.shapes = self._shapes
        self.bind(shape=self.update_vertices)
        self.update_vertices()

    def random_shape(self, *args):
        self.shape = random.randint(0, len(self.shapes) - 1)

    def update_vertices(self, *args):
        self.abs_vertices = self.shapes[self.shape]["vertices"]