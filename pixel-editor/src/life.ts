export class Sim {
  constructor(
    public readonly canvas: HTMLCanvasElement,
    width: number,
    height: number,
  ) {
    this.canvas.style.imageRendering = "pixelated"
    this.#state = {
      arrayWidth: width,
      fbuf: new Uint8Array(width * height),
      bbuf: new Uint8Array(width * height),
    }
  }

  #state: {
    arrayWidth: number
    fbuf: Uint8Array
    bbuf: Uint8Array
  }

  setup() {
    for (let i = 0; i < this.#state.fbuf.length * 0.5; i++) {
      let x = Math.floor(Math.random() * this.#state.arrayWidth)
      let y = Math.floor(
        (Math.random() * this.#state.fbuf.length) / this.#state.arrayWidth,
      )
      this.#state.fbuf[x + y * this.#state.arrayWidth] = 1
      this.canvas.width = this.canvas.width
      this.canvas.height = this.canvas.height
    }
  }

  update() {
    for (let i = 0; i < this.#state.fbuf.length; i++) {
      let [x, y] = [
        i % this.#state.arrayWidth,
        Math.floor(i / this.#state.arrayWidth),
      ]
      let cell = this.#state.fbuf[i]
      let neighbors = 0
      for (let [dx, dy] of NEIGHBORS) {
        let [x2, y2] = [x + dx, y + dy]
        if (
          0 <= x2 &&
          x2 < this.#state.arrayWidth &&
          0 <= y2 &&
          y2 < this.#state.fbuf.length / this.#state.arrayWidth
        ) {
          neighbors += this.#state.fbuf[x2 + y2 * this.#state.arrayWidth]
        }
      }
      cell = RULES[neighbors][cell]
      this.#state.bbuf[i] = cell
    }
    // swap front and back buffers
    let tmp = this.#state.bbuf
    this.#state.bbuf = this.#state.fbuf
    this.#state.fbuf = tmp
  }

  draw() {
    let ctx = this.canvas.getContext("2d")!
    ctx.clearRect(0, 0, this.canvas.width, this.canvas.height)
    let cellSize = this.canvas.width / this.#state.arrayWidth
    let cellSizeY =
      this.canvas.height / (this.#state.fbuf.length / this.#state.arrayWidth)
    for (let i = 0; i < this.#state.fbuf.length; i++) {
      let [x, y] = [
        i % this.#state.arrayWidth,
        Math.floor(i / this.#state.arrayWidth),
      ]
      let cell = this.#state.bbuf[i]
      if (cell) {
        ctx.fillStyle = `hsl(${Math.cos(x / (y + 1))}turn 95% 60%)`
        ctx.fillRect(x * cellSize, y * cellSizeY, cellSize, cellSizeY)
        //     ctx.beginPath()
        //     let [x0, y0] = [x * cellSize, y * cellSize]
        //     ctx.fillRect(x0, y0, x0 + 1, y0 + 0.5)
        //     ctx.closePath()
      }
    }
  }
}

const RULES = [
  [0, 0], // 0
  [0, 0], // 1
  [0, 1], // 2
  [1, 1], // 3
  [0, 0], // 4
  // [0, 0], // 4
  [0, 0], // 5
  // [0, 0], // 6
  [1, 0], // 6
  [1, 1], // 7
  [1, 1], // 8
]

const NEIGHBORS = [
  [0, 1],
  [1, 1],
  [1, 0],
  [1, -1],
  [0, -1],
  [-1, -1],
  [-1, 0],
  [-1, 1],
]
