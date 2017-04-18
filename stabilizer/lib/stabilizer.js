'use strict';

const puts = function(msg) {
  $('#console').text(msg);
};

class Vec {
  constructor(x, y, z) {
    this.x = x || 0.0;
    this.y = y || 0.0;
    this.z = z || 0.0;
  }

  toString() {
    return `{x: ${this.x}, y: ${this.y}, z: ${this.z}}`;
  }

  invert() {
    return new Vec(-this.x, -this.y, -this.z);
  }

  scale(f) {
    return new Vec(f*this.x, f*this.y, f*this.z);
  }

  magnitude() {
    return Math.sqrt(
      this.x*this.x +
      this.y*this.y +
      this.z*this.z
    );
  }

  subtract(other) {
    return new Vec(
      this.x-other.x,
      this.y-other.y,
      this.z-other.z
    );
  }
}

Vec.fromObject = function(dm) {
  return new Vec(dm.x, dm.y, dm.z);
};

Vec.zero = function() {
  return new Vec();
};

Vec.lerp = function(a, b, t) {
  return a.subtract(b).scale(t);
};

class Watch {
  constructor() {
    this.t = Date.now();
  }

  split() {
    const s = Date.now();
    const d = s - this.t;
    this.t = s;
    return d;
  }
}

const watch = new Watch();

class Envelope {
  constructor() {
    this.min = null;
    this.max = null;
  }

  update(x) {
    if (x > this.max || this.max == null) {
      this.max = x;
    }
    if (x < this.min || this.min == null) {
      this.min = x;
    }
  }

  binaryScale(x) {
    const scale = function(mn, mx, v) {
      return (v - mn) / (mx - mn);
    };
    if (x == 0) {
      return 0;
    } else if (x > 0) {
      return scale(0, this.max || 0, x);
    } else {
      return scale(this.min || 0, 0, x);
    }
  }

  toString() {
    return `{min: ${this.min}, max: ${this.max}}`;
  }
}

class Scale {
  constructor(min, max) {
    this.min = min;
    this.max = max;
  }

  norm(x) {
    return (x - this.min) / (this.max - this.min);
  }

  denorm(v) {
    return v * (this.max - this.min) + this.min;
  }
}

$(() => {
  const el = document.getElementById('content');
  const zScale = new Scale(-80, 80);
  const wScale = new Scale(-.5, .5);
  window.ondevicemotion = function(e) {
    const acc = Vec.fromObject(e.acceleration || e.accelerationIncludingGravity).invert();
    const correction = Vec.lerp(Vec.zero(), acc, watch.split() / 100).scale(25);
    const z = -correction.z;
    const scale = wScale.denorm(zScale.norm(z));
    el.style.transform = `translate(${correction.x}px,${correction.y}px) scale(${scale+1})`;
    puts(`z: ${scale}`);
  };
});
