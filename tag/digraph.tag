<digraph>
    <script>

        function wrap(text, width) {
            text.each(function () {
                var text = d3.select(this),
                        words = text.text().split(/\s+/).reverse(),
                        word,
                        line = [],
                        lineNumber = 0,
                        lineHeight = 1.1, // ems
                        x = text.attr("x"),
                        y = text.attr("y"),
                        dy = 1, //parseFloat(text.attr("dy")),
                        tspan = text.text(null).append("tspan").attr("x", x).attr("y", y).attr("dy", dy + "em");
                while (word = words.pop()) {
                    line.push(word);
                    tspan.text(line.join(" "));
                    if (tspan.node().getComputedTextLength() > width) {
                        line.pop();
                        tspan.text(line.join(" "));
                        line = [word];
                        tspan = text.append("tspan").attr("x", x).attr("y", y).attr("dy", ++lineNumber * lineHeight + dy + "em").text(word);
                    }
                }
            });
        }

        RpgImpro.document.on('update', function () {
            var doc = RpgImpro.document
            var linkDistance = 200;
            var colors = d3.scale.category10();
            var dataset = {
                nodes: [],
                edges: []
            }
            var pkMap = {}
            var w = window.innerWidth - 20
            var h = window.innerHeight

            for (var k in doc.vertex) {
                var v = doc.vertex[k]
                pkMap[v.pk] = parseInt(k, 10) // javascript mystery
                dataset.nodes.push({name: v.sentence})
            }

            for (var k in doc.edge) {
                var link = doc.edge[k]
                dataset.edges.push({source: pkMap[link.source], target: pkMap[link.target]})
            }

            d3.select("digraph").select("svg").remove()
            var svg = d3.select("digraph").append("svg").attr({
                width: w,
                height: h,
                viewBox: "0 0 " + w + " " + h
            })

            var force = d3.layout.force()
                    .nodes(dataset.nodes)
                    .links(dataset.edges)
                    .size([w, h])
                    .linkDistance([linkDistance])
                    .charge([-500])
                    .theta(0.1)
                    .gravity(0.05)
                    .start();

            var edges = svg.selectAll("line")
                    .data(dataset.edges)
                    .enter()
                    .append("line")
                    .attr("id", function (d, i) {
                        return 'edge' + i
                    })
                    .attr('marker-end', 'url(#arrowhead)')
                    .style("stroke", "#ccc")
                    .style("pointer-events", "none");

            var nodes = svg.selectAll("circle")
                    .data(dataset.nodes)
                    .enter()
                    .append("circle")
                    .attr({"r": 15})
                    .style("fill", function (d, i) {
                        return colors(i);
                    })
                    .call(force.drag)


            var nodelabels = svg.selectAll(".nodelabel")
                    .data(dataset.nodes)
                    .enter()
                    .append("text")
                    .attr({"x": function (d) {
                            return d.x;
                        },
                        "y": function (d) {
                            return d.y;
                        },
                        "class": "nodelabel"
                    })
                    .text(function (d) {
                        return d.name;
                    });

            svg.selectAll('.nodelabel')
                    .call(wrap, 80)

            var edgepaths = svg.selectAll(".edgepath")
                    .data(dataset.edges)
                    .enter()
                    .append('path')
                    .attr({'d': function (d) {
                            return 'M ' + d.source.x + ' ' + d.source.y + ' L ' + d.target.x + ' ' + d.target.y
                        },
                        'class': 'edgepath',
                        'fill-opacity': 0,
                        'stroke-opacity': 0,
                        'fill': 'blue',
                        'stroke': 'red',
                        'id': function (d, i) {
                            return 'edgepath' + i
                        }})
                    .style("pointer-events", "none");

            var edgelabels = svg.selectAll(".edgelabel")
                    .data(dataset.edges)
                    .enter()
                    .append('text')
                    .style("pointer-events", "none")
                    .attr({'class': 'edgelabel',
                        'id': function (d, i) {
                            return 'edgelabel' + i
                        },
                        'dx': 80,
                        'dy': 0,
                        'font-size': 10,
                        'fill': '#aaa'});

            edgelabels.append('textPath')
                    .attr('xlink:href', function (d, i) {
                        return '#edgepath' + i
                    })
                    .style("pointer-events", "none")
                    .text(function (d, i) {
                        return 'label ' + i
                    });


            svg.append('defs').append('marker')
                    .attr({'id': 'arrowhead',
                        'viewBox': '-0 -5 10 10',
                        'refX': 25,
                        'refY': 0,
                        //'markerUnits':'strokeWidth',
                        'orient': 'auto',
                        'markerWidth': 10,
                        'markerHeight': 10,
                        'xoverflow': 'visible'})
                    .append('svg:path')
                    .attr('d', 'M 0,-5 L 10 ,0 L 0,5')
                    .attr('fill', '#ccc')
                    .attr('stroke', '#ccc');


            force.on("tick", function () {

                edges.attr({"x1": function (d) {
                        return d.source.x;
                    },
                    "y1": function (d) {
                        return d.source.y;
                    },
                    "x2": function (d) {
                        return d.target.x;
                    },
                    "y2": function (d) {
                        return d.target.y;
                    }
                });

                nodes.attr({"cx": function (d) {
                        return d.x;
                    },
                    "cy": function (d) {
                        return d.y;
                    }
                });

                nodelabels
                        .attr("x", function (d) {
                            return d.x;
                        })
                        .attr("y", function (d) {
                            return d.y;
                        })
                        .selectAll('tspan')
                        .each(function (d) {
                            //console.log(this, d)
                            var t = d3.select(this)
                            t.attr('x', d.x)
                            t.attr('y', d.y)
                        })


                edgepaths.attr('d', function (d) {
                    var path = 'M ' + d.source.x + ' ' + d.source.y + ' L ' + d.target.x + ' ' + d.target.y;
                    //console.log(d)
                    return path
                });

                edgelabels.attr('transform', function (d, i) {
                    if (d.target.x < d.source.x) {
                        bbox = this.getBBox();
                        rx = bbox.x + bbox.width / 2;
                        ry = bbox.y + bbox.height / 2;
                        return 'rotate(180 ' + rx + ' ' + ry + ')';
                    }
                    else {
                        return 'rotate(0)';
                    }
                });
            })
        })
    </script>
</digraph>
