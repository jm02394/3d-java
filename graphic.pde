import java.util.*;

Coord[] hi = {new Coord(0, 0, 0), new Coord(1, 0, 0), new Coord(0, 1, 0), new Coord(1, 1, 0), new Coord(0, 0, 1), new Coord(1, 0, 1), new Coord(0, 1, 1), new Coord(1, 1, 1)};
Prim cube = new Prim(new Tri[] {
    //Bottom
    new Tri(
        new Coord(1, 0, 0), new Coord(0, 0, 0), new Coord(0, 0, 1)
    ),
    new Tri(
        new Coord(1, 0, 0), new Coord(1, 0, 1), new Coord(0, 0, 1)
    ),
    //Front
    new Tri(
        new Coord(0, 0, 0), new Coord(0, 1, 0), new Coord(1, 1, 0)
    ),
    new Tri(
        new Coord(0, 0, 0), new Coord(1, 0, 0), new Coord(1, 1, 0)
    ),
    //Left
    new Tri(
        new Coord(0, 1, 0), new Coord(0, 0, 0), new Coord(0, 0, 1)
    ),
    new Tri(
        new Coord(0, 1, 0), new Coord(0, 1, 1), new Coord(0, 0, 1)
    ),
    //Back
    new Tri(
        new Coord(1, 0, 1), new Coord(0, 0, 1), new Coord(0, 1, 1)
    ),
    new Tri(
        new Coord(1, 0, 1), new Coord(1, 1, 1), new Coord(0, 1, 1)
    ),
    //Right
    new Tri(
        new Coord(1, 0, 0), new Coord(1, 0, 1), new Coord(1, 1, 1)
    ),
    new Tri(
        new Coord(1, 0, 0), new Coord(1, 1, 0), new Coord(1, 1, 1)
    ),
    //Top
    new Tri(
        new Coord(1, 1, 0), new Coord(0, 1, 0), new Coord(0, 1, 1)
    ),
    new Tri(
        new Coord(1, 1, 0), new Coord(1, 1, 1), new Coord(0, 1, 1)
    )
}, color(255, 0, 0, 255));

ArrayList<Tri> renderPool = new ArrayList<Tri>();

Coord cPos = new Coord(-1, 6, -3);
Coord cRot = new Coord(radians(-40), radians(30), radians(0));

float c = 0;

void setup() {
    //strokeWeight(10);
    stroke(0);
    
    size(1920, 1080);
}

void draw() {
    background(255);
    renderPool.clear();
    
    c += 0.01;

    cPos.x = sin(c) * 2;
    cPos.z = cos(c) * 2 - 1;

    //cRot.y = radians(new Coord(0, 0, 0).angle(cPos));
    //cRot.x = sin(c) * 0.2 - 1;

    Coord ang = cPos.angleTowards(new Coord(0, 0, 0));
    cRot = ang;

    //System.out.println(new Coord(0, 0, 0).angle(cPos));
    
    /*for (int p = 0; p < 8; p++) {
        Point cp = processCoord(hi[p]);
        
        circle(cp.x, cp.y, 5);
    }*/

    //for (int t = 0; t < ctris.length; t++) {
    //    drawTri(ctris[t]);
    //}

    //cube.transform(3).translate(new Coord(-3, 0, 0)).draw();
    //cube.translate(new Coord(1, 0, 0)).draw();

    //renderPool.addAll(Arrays.asList(cube.transform(3).translate(new Coord(-3+c, 0, 0)).tris));
    //renderPool.addAll(Arrays.asList(cube.translate(new Coord(1, 0, 0)).tris));
    cube.transform(3).translate(new Coord(-3, 0, 0)).render();
    cube.translate(new Coord(1, 0, 0)).render();
    cube.translate(new Coord(0, 0, 0)).render();
    cube.translate(new Coord(-4, 0, 0)).render();
    cube.translate(new Coord(2, 0, 0)).render();

    Collections.sort(renderPool);

    for (int t = 0; t < renderPool.size(); t++) {
        renderPool.get(t).draw();
    }

    circle(new Coord(0, 0, 0).process().x, new Coord(0, 0, 0).process().y, 10);

    strokeWeight(3);
    line(0, height/2, width, height/2);
    line(width/2, 0, width/2, height);
    strokeWeight(1);

    fill(0);
    textSize(20);
    text(frameRate, 5, 20);
    fill(255);
}

public class Point {
    float x, y;
    
    public Point (float xpos, float ypos) {
        x = xpos;
        y = ypos;
    }

    @Override
    public String toString() {
        return x + ", " + y;
    }
}

public class Coord {
    float x, y, z;
    
    public Coord (float xpos, float ypos, float zpos) {
        x = xpos;
        y = ypos;
        z = zpos;
    }

    public Point project(Coord c, Coord r, Coord e) {
        Coord a = new Coord(x, y, z);

        float xp = a.x - c.x;
        float yp = a.y - c.y;
        float zp = a.z - c.z;

        yp = -yp;
        
        float dx, dy, dz;
        
        if (r == new Coord(0, 0, 0)) {
            dx = xp;
            dy = yp;
            dz = zp;
        } else {
            dx = cos(r.y) * (sin(r.z) * yp + cos(r.z) * xp) - sin(r.y) * zp;
            dy = sin(r.x) * (cos(r.y) * zp + sin(r.y) * (sin(r.z) * yp + cos(r.z) * xp)) + cos(r.x) * (cos(r.z) * yp - sin(r.z) * xp);
            dz = cos(r.x) * (cos(r.y) * zp + sin(r.y) * (sin(r.z) * yp + cos(r.z) * xp)) - sin(r.x) * (cos(r.z) * yp - sin(r.z) * xp);
        }
        
        float bx = e.z / dz * dx + e.x;
        float by = e.z / dz * dy + e.y;
        
        return new Point(floor(width / 2 + bx), floor(height / 2 + by));
    }

    public Point process() {
        Point o = this.project(cPos, cRot, new Coord(0, 0, 800));

        //if (0 > o.x || o.x > 3000 || 0 > o.y || o.y > 3000) return new Point(-1, -1);//System.out.println(o.x + ", " + o.y);

        return o;
    }

    public Coord translate(Coord inp) {
        return new Coord(x + inp.x, y + inp.y, z + inp.z);
    }

    public Coord transform(Coord inp) {
        return new Coord(x * inp.x, y * inp.y, z * inp.z);
    }

    public Coord transform(float inp) {
        return new Coord(x * inp, y * inp, z * inp);
    }

    public float distance(Coord inp) {
        return sqrt(sq(inp.x - x) + sq(inp.y - y) + sq(inp.z - z) );
    }

    public float angle(Coord inp) {
        float len = sqrt(sq(x - inp.x) + sq(y - inp.y) + sq(z - inp.z));
        float rise = inp.y - y;
        float run = sqrt(sq(len) - sq(rise));
        return degrees(atan(rise/run));
    }

    public Coord angleTowards(Coord to) {
        float xa = atan((y - to.y) / (z - to.z));
        float xm = sqrt(sq(z - to.z) + sq(y - to.y));
        //float xa = asin((z - to.z) / xm);
        if (to.z < z) xa = PI + xa;

        float ya = atan((x - to.x) / (z - to.z));
        //float ym = sqrt(sq(z - to.z) + sq(x - to.x));
        if (to.z < z) ya = PI + ya;

        float za = atan((y - to.y) / (x - to.x));
        //if (to.y < y) za = za;

        return new Coord(-20, ya, 0);
    }
}

public class Tri implements Comparable<Tri> {
    Coord a, b, c, origin;
    color col;

    public Tri (Coord p1, Coord p2, Coord p3) {
        a = p1;
        b = p2;
        c = p3;

        col = color(0, 0, 0, 0);

        //origin = new Coord((a.x + b.x + c.x) / 3, (a.y + b.y + c.y) / 3, (a.z + b.z + c.z) / 3);
        origin = new Coord(
            min(a.x, b.x, c.x) + (max(a.x, b.x, c.x) - min(a.x, b.x, c.x)) / 2,
            min(a.y, b.y, c.y) + (max(a.y, b.y, c.y) - min(a.y, b.y, c.y)) / 2,
            min(a.z, b.z, c.z) + (max(a.z, b.z, c.z) - min(a.z, b.z, c.z)) / 2
        );
    }

    public Point[] project() {
        Point[] out = {a.process(), b.process(), c.process()};
        return out;
    }

    public void draw() {
        Point[] cs = this.project();

        Point p1 = cs[0];
        Point p2 = cs[1];
        Point p3 = cs[2];

        //System.out.println(alpha(col));

        if (alpha(col) != 0) {
            push();
            fill(col);
            beginShape();
            vertex(p1.x, p1.y);
            vertex(p2.x, p2.y);
            vertex(p3.x, p3.y);
            endShape(CLOSE);
            pop();
        }

        line(p1.x, p1.y, p2.x, p2.y);
        line(p2.x, p2.y, p3.x, p3.y);
        line(p3.x, p3.y, p1.x, p1.y);

        circle(p1.x, p1.y, 5);
        circle(p2.x, p2.y, 5);
        circle(p3.x, p3.y, 5);
    }

    public Tri translate(Coord inp) {
        return new Tri(
            new Coord(a.x + inp.x, a.y + inp.y, a.z + inp.z),
            new Coord(b.x + inp.x, b.y + inp.y, b.z + inp.z),
            new Coord(c.x + inp.x, c.y + inp.y, c.z + inp.z)
        );
    }

    public Tri transform(Coord inp) {
        return new Tri(
            new Coord(a.x * inp.x, a.y * inp.y, a.z * inp.z),
            new Coord(b.x * inp.x, b.y * inp.y, b.z * inp.z),
            new Coord(c.x * inp.x, c.y * inp.y, c.z * inp.z)
        );
    }

    public Tri transform(float inp) {
        return new Tri(
            new Coord(a.x * inp, a.y * inp, a.z * inp),
            new Coord(b.x * inp, b.y * inp, b.z * inp),
            new Coord(c.x * inp, c.y * inp, c.z * inp)
        );
    }

    public void render() {
        //Point o = this.origin.process();

        //if ((0 < o.x) && (o.x < width) && (0 < o.y) && (o.y < height)) renderPool.add(this);

        Coord[] p = new Coord[] {a, b, c};

        for (int i = 0; i < p.length; i++) {
            Point o = p[i].process();

            //if (0 > o.x || o.x > 3000 || 0 > o.y || o.y > 3000) return;
            if ((0 < o.x) && (o.x < width) && (0 < o.y) && (o.y < height)) renderPool.add(this);
        }

        //renderPool.add(this);
    }

    @Override
    public int compareTo(Tri comptri) {
        float v = comptri.origin.distance(cPos) - this.origin.distance(cPos);

        if (v < 0) return -1;
        else if (v == 0) return 0;
        else return 1;
    }
}

public class Prim {
    Tri[] tris;
    color col;

    public Prim (Tri[] inp, color c) {
        tris = inp;

        col = c;

        for (int t = 0; t < tris.length; t++) {
            tris[t].col = col;
        }
    }

    public Prim translate(Coord inp) {
        Tri[] out = new Tri[tris.length];

        for (int t = 0; t < tris.length; t++) {
            out[t] = tris[t].translate(inp);
        }

        return new Prim(out, col);
    }

    public void draw() {
        for (int t = 0; t < tris.length; t++) {
            tris[t].draw();
        }
    }

    public Prim transform(Coord inp) {
        Tri[] out = new Tri[tris.length];

        for (int t = 0; t < tris.length; t++) {
            out[t] = tris[t].transform(inp);
        }

        return new Prim(out, col);
    }

    public Prim transform(float inp) {
        Tri[] out = new Tri[tris.length];

        for (int t = 0; t < tris.length; t++) {
            out[t] = tris[t].transform(inp);
        }

        return new Prim(out, col);
    }

    public void render() {
        //for (int t = 0; t < tris.length; t++) tris[t].render();
        renderPool.addAll(Arrays.asList(tris));
    }
}