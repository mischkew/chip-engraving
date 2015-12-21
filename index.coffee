shaven = require 'shaven'
tags = require './tags'
fs = require 'fs'

# adapt this to your shape
tagShape =
  innerDiameter: 26
  diameter: 32
  height: 42
  depth: 5.5
  tip:
    diameter: 12


module.exports.buildSvgs = ->

  from = parseInt(process.env.FROM)
  to = parseInt(process.env.TO)

  if !fs.existsSync('./tags')
    fs.mkdirSync('./tags')

  while from <= to
    number = from
    from += 8 # tags has step size of 8

    svgString = shaven(
      tags.shaven(number),
      tagShape
    )

    fs.writeFile("tags/tags#{number}.svg", svgString[0])
