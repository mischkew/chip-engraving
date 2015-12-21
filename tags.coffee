module.exports.shaven = (serialNumber, tagShape) ->

  beautifyNumber = (number) ->
    return parseFloat number.toFixed 10

  # All sizes in mm
    # old shape
    # innerDiameter: 23.55
    # diameter: 29.3
    # height: 41.6
    # depth: 5.5
    # tip:
    #   diameter: 13.4

  tagDefault =
    innerDiameter: 26
    diameter: 32
    height: 42
    depth: 5.5
    tip:
      diameter: 12

  tag = tagShape || tagDefault
  tag.radius = (tag.diameter / 2)
  tag.innerRadius = (tag.innerDiameter / 2)
  tag.tip.radius = (tag.tip.diameter / 2)


  play = 0.1
  safetyDistance = 4
  canvasWidth = ((tag.diameter + (play * 2)) * 4) + (safetyDistance * 2)
  canvasHeight = ((tag.height + (play * 2)) * 2) + (safetyDistance * 3)
  firstSerialNumber = serialNumber || 726

  tag.cutRadius = tag.radius + play
  tag.tip.cutRadius = tag.tip.radius + play
  tag.cutHeight = tag.height + (2 * play)
  heightOffset = beautifyNumber tag.cutHeight - tag.cutRadius


  transformSingle = (options) ->
    switch options.type
      when 'rotate' then "rotate(#{options.degrees})"
      when 'translate' then "translate(#{options.x},#{options.y})"

  transform = (options) ->
    if Array.isArray(options)
      return options
        .map(transformSingle)
        .join(' ')
    else
      return transformSingle(options)


  getTagElement = (options = {}) ->
    if options.transform
      if typeof options.transform == 'object'
        options.transform = transform(options.transform)

    [
      'g.tag'
      {
        transform: if options.transform
        then options.transform else false
      }
      [
        'path'
        {
          style:
            stroke: 'rgb(255,0,0)'
            'stroke-width': 0.1
            # fill: 'none' # uncomment this to make shapes transparent
          d: 'M' + -tag.cutRadius + ',0 ' +

            'C' +
            -tag.cutRadius + ',' + 8 + ' ' +
            -tag.cutRadius * 0.6 + ',' + heightOffset + ' ' +
            '0,' + heightOffset + ' ' +

            'C' +
            tag.cutRadius * 0.6 + ',' + heightOffset + ' ' +
            tag.cutRadius + ',' + 8 + ' ' + tag.cutRadius + ',0 ' +

            'A' + '1,1 ' + '0 0 0 ' + -tag.cutRadius + ',0' +
            'z'
        }
      ]
      [
        'circle'
        {
          style:
            fill: 'gray'
          r: tag.innerRadius
        }
      ]
      [
        'circle.centerMarker'
        {
          style:
            fill: 'yellow'
          r: 0.5
        }
      ]
      [
        'text'
        options.serialNumber
        {
          transform: 'rotate(180)'
          style:
            fill: 'rgb(0,0,255)'
            'font-family': 'Arial'
            'font-size': 7
            'text-anchor': 'middle'
          x: 0
          y: 2.5
        }
      ]
    ]


  tagGroup = [
    'g#tagGroup'
    [
      'use'
      {
        transform: 'translate(' +
          tag.cutRadius + ',' +
          tag.cutRadius +
        ')'
        'xlink:href': '#tag'
      }
    ]
    [
      'use'
      {
        transform: 'translate(' + [
          3 * tag.cutRadius
          heightOffset
        ].join() + ')' + ' scale(1,-1)'
        'xlink:href': '#tag'
      }
    ]
  ]

  tagMatrix = [
    'g#tagMatrix'
    {
      transform: [{
        type: 'translate'
        x: safetyDistance
        y: safetyDistance
      }]
    }
    [
      'use'
      {'xlink:href': '#tagGroup'}
    ]
    [
      'use'
      {
        transform: 'translate(' + 2 * tag.diameter + ',0)'
        'xlink:href': '#tagGroup'
      }
    ]
    [
      'g'
      {transform: 'translate(0,' + tag.height + safetyDistance + ')'}
      [
        'use'
        {'xlink:href': '#tagGroup'}
      ]
      [
        'use'
        {
          transform: 'translate(' + 2 * tag.diameter + ',0)'
          'xlink:href': '#tagGroup'
        }
      ]
    ]
  ]

  tagList = [
    {
      transform: [{
        type: 'translate'
        x: tag.cutRadius
        y: tag.cutRadius
      }]
    }
    {
      transform: [
        {
          type: 'translate'
          x: 3 * tag.cutRadius
          y: heightOffset
        }
        {
          type: 'rotate'
          degrees: 180
        }
      ]
    }
    {
      transform: [{
        type: 'translate'
        x: 5 * tag.cutRadius
        y: tag.cutRadius
      }]
    }
    {
      transform: [
        {
          type: 'translate'
          x: 7 * tag.cutRadius
          y: heightOffset
        }
        {
          type: 'rotate'
          degrees: 180
        }
      ]
    }
    {
      transform: [{
        type: 'translate'
        x: tag.cutRadius
        y: tag.cutRadius + tag.cutHeight + safetyDistance
      }]
    }
    {
      transform: [
        {
          type: 'translate'
          x: 3 * tag.cutRadius
          y: heightOffset + tag.cutHeight + safetyDistance
        }
        {
          type: 'rotate'
          degrees: 180
        }
      ]
    }
    {
      transform: "translate(#{5 * tag.cutRadius},#{tag.cutRadius + tag.cutHeight + safetyDistance})"
    }
    {
      transform: "translate(#{7 * tag.cutRadius},#{heightOffset + tag.cutHeight + safetyDistance}) rotate(180)"
    }
  ]

  svgElement = [
    'svg'
    {
      width: canvasWidth + 'mm'
      height: canvasHeight + 'mm'
      viewBox: "0 0 #{canvasWidth} #{canvasHeight}"
      xmlns: 'http://www.w3.org/2000/svg'
      'xmlns:xlink': 'http://www.w3.org/1999/xlink'
    }
    ['g#tagMatrix', {
      transform: "translate(#{safetyDistance}, #{safetyDistance})"
    }]
  ]


  tagList.forEach (tagData, index) ->
    tagData.serialNumber = '0' + (firstSerialNumber + index)
    svgElement[2].push getTagElement(tagData)

  return svgElement
