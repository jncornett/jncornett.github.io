import React, { useEffect, useReducer, useRef, useState } from "react"
import { Sim } from "./life"

export default function App({
  width,
  height,
}: {
  width: number
  height: number
}) {
  let canvasRef = useRef<HTMLCanvasElement>(null)
  useEffect(() => {
    if (canvasRef.current) {
      let sim = new Sim(canvasRef.current, 50, 50)
      let handle = 0
      sim.setup()
      let loop = () => {
        sim.update()
        sim.draw()
        handle = requestAnimationFrame(loop)
      }
      handle = requestAnimationFrame(loop)

      return () => {
        cancelAnimationFrame(handle)
      }
    }
  })
  return (
    <canvas
      ref={canvasRef}
      style={{
        aspectRatio: "1",
        width: 600,
      }}
    />
  )
}
