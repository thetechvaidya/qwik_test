<template>
    <canvas></canvas>
</template>

<script>
import {
    Chart as ChartJS,
    ArcElement,
    Tooltip,
    Legend,
    DoughnutController
} from 'chart.js'
import { Doughnut } from 'vue-chartjs'

// Register Chart.js components
ChartJS.register(ArcElement, Tooltip, Legend, DoughnutController)

export default {
    extends: Doughnut,
    props: {
        chartData: {
            type: Object,
            default: null,
        },
        elementText: {
            type: String,
            default: '',
        },
    },
    mounted() {
        // Register the center text plugin for Chart.js 3+
        const centerTextPlugin = {
            id: 'centerText',
            beforeDraw: function (chart) {
                if (chart.config.options.elements.center) {
                    // Get ctx from chart
                    let ctx = chart.ctx

                    // Get options from the center object in options
                    let centerConfig = chart.config.options.elements.center
                    let fontStyle = centerConfig.fontStyle || 'Arial'
                    let txt = centerConfig.text
                    let color = centerConfig.color || '#000'
                    let maxFontSize = centerConfig.maxFontSize || 75
                    let sidePadding = centerConfig.sidePadding || 20
                    let sidePaddingCalculated = (sidePadding / 100) * (chart._metasets[0].controller.innerRadius * 2)
                    // Start with a base font of 30px
                    ctx.font = '30px ' + fontStyle

                    // Get the width of the string and also the width of the element minus 10 to give it 5px side padding
                    let stringWidth = ctx.measureText(txt).width
                    let elementWidth = chart._metasets[0].controller.innerRadius * 2 - sidePaddingCalculated

                    // Find out how much the font can grow in width.
                    let widthRatio = elementWidth / stringWidth
                    let newFontSize = Math.floor(30 * widthRatio)
                    let elementHeight = chart._metasets[0].controller.innerRadius * 2

                    // Pick a new font size so it will not be larger than the height of label.
                    let fontSizeToUse = Math.min(newFontSize, elementHeight, maxFontSize)
                    let minFontSize = centerConfig.minFontSize
                    let lineHeight = centerConfig.lineHeight || 25
                    let wrapText = false

                    if (minFontSize === undefined) {
                        minFontSize = 20
                    }

                    if (minFontSize && fontSizeToUse < minFontSize) {
                        fontSizeToUse = minFontSize
                        wrapText = true
                    }

                    // Set font settings to draw it correctly.
                    ctx.textAlign = 'center'
                    ctx.textBaseline = 'middle'
                    let centerX = (chart.chartArea.left + chart.chartArea.right) / 2
                    let centerY = (chart.chartArea.top + chart.chartArea.bottom) / 2
                    ctx.font = fontSizeToUse + 'px ' + fontStyle
                    ctx.fillStyle = color

                    if (!wrapText) {
                        ctx.fillText(txt, centerX, centerY)
                        return
                    }

                    let words = txt.split(' ')
                    let line = ''
                    let lines = []

                    // Break words up into multiple lines if necessary
                    for (let n = 0; n < words.length; n++) {
                        let testLine = line + words[n] + ' '
                        let metrics = ctx.measureText(testLine)
                        let testWidth = metrics.width
                        if (testWidth > elementWidth && n > 0) {
                            lines.push(line)
                            line = words[n] + ' '
                        } else {
                            line = testLine
                        }
                    }

                    // Move the center up depending on line height and number of lines
                    centerY -= (lines.length / 2) * lineHeight

                    for (let n = 0; n < lines.length; n++) {
                        ctx.fillText(lines[n], centerX, centerY)
                        centerY += lineHeight
                    }
                    //Draw text in center
                    ctx.fillText(line, centerX, centerY)
                }
            }
        }

        // Register the plugin
        ChartJS.register(centerTextPlugin)
        
        this.renderChart(this.chartData, {
            responsive: true,
            cutout: '90%', // Updated from cutoutPercentage for Chart.js 3+
            plugins: {
                legend: {
                    display: false,
                },
            },
            elements: {
                center: {
                    text: this.elementText,
                    color: '#495057', // Default is #000000
                    fontStyle: 'Inter', // Default is Arial
                    sidePadding: 20, // Default is 20 (as a percentage)
                    minFontSize: 12, // Default is 20 (in px), set to false and text will not wrap.
                    newFontSize: 12,
                    lineHeight: 25, // Default is 25 (in px), used for when text wraps
                },
            },
        })
    },
}
</script>
