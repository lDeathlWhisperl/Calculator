import QtQuick
import QtQuick.Controls.Basic

import calc

Window
{
    id: mainWindow
    width: 360
    height: 640
    visible: true
    title: qsTr(" ")

    maximumHeight: height
    maximumWidth: width

    minimumHeight: height
    minimumWidth: width

    property int duration: 0
    property int start_time: 0

    property bool isOpenBracket: false
    property bool secretPanel: false
    property string str: ""


    Calc
    {
        id: calc
        property bool isCompleted: false
    }

    FontLoader
    {
        id: openSansSemibold
        source: "qrc:/fonts/Open Sans Semibold.ttf"
    }

    Rectangle
    {
        id: background
        width: parent.width
        height: parent.height
        color: "#024873"
    }

    Rectangle
    {
        id: inputWindow
        width: parent.width
        height: 180
        bottomRightRadius: 25
        bottomLeftRadius: 25
        color: "#04BFAD"
    }

    Text
    {
        id: secretText
        text: "Секретная панель"
        height: 30
        width: 30

        visible: false

        font.pixelSize: 30
        lineHeight: 60
        font.letterSpacing: 0.5
        font.family: openSansSemibold.name
        color: "white"

        topPadding: 106
        x: parent.width-39 - width

        horizontalAlignment: Text.AlignRight
    }

    Button
    {
        id: secretBtn
        width: 100
        height: 60
        hoverEnabled: false

        text: "Назад"

        y: parent.height / 2 + 52
        x: 360 + 220

        visible: false

        contentItem: Text
        {
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: secretBtn.text

            font.pixelSize: 24
            font.letterSpacing: 1
            font.family: openSansSemibold.name

            lineHeight: 30
            color: "#024873"
        }

        background: Rectangle
        {
            anchors.fill: parent
            radius: 180
            color: secretBtn.down ? "#04BFAD" : "#B0D1D8"
        }

        onReleased:
        {
            secretPanel = false
            duration = 0

            secretBtn.visible = false
            secretText.visible = false

            mainWindow.minimumWidth = 360
            mainWindow.maximumWidth = 360
            mainWindow.width = 360
        }
    }

    Text
    {
        id: input
        width: 281
        height: 60

        font.pixelSize: 50
        lineHeight: 60
        font.letterSpacing: 0.5
        font.family: openSansSemibold.name

        color: "white"

        horizontalAlignment: Text.AlignRight

        topPadding: 106
        x: 39
    }

    Text
    {
        id: equation
        width: 280
        height: 30

        font.pixelSize: 20
        lineHeight: 30
        font.letterSpacing: 0.5
        font.family: openSansSemibold.name

        color: "white"

        horizontalAlignment: Text.AlignRight

        topPadding: 68
        x: 39
    }

    Grid
    {
        width: parent.width
        height: parent.height - inputWindow.height
        y: inputWindow.height

        columns: 4
        rows: 5

        columnSpacing: 24
        rowSpacing: columnSpacing
        padding: columnSpacing

        Repeater
        {
            model:
            [
                "qrc:/icons/bkt.png",
                "qrc:/icons/plus_minus.png",
                "qrc:/icons/percent.png",
                "qrc:/icons/division.png",
                "7", "8", "9",
                "qrc:/icons/multiplication.png",
                "4", "5", "6",
                "qrc:/icons/minus.png",
                "1", "2", "3",
                "qrc:/icons/plus.png",
                "C", "0", ".",
                "qrc:/icons/equal.png"
            ]

            Button
            {
                height: 60
                width: height
                id: btn
                hoverEnabled: false

                text: modelData
                font.pixelSize: 24
                font.letterSpacing: 1
                font.family: openSansSemibold.name
                palette.buttonText: (index === 16) ? "white" : "#024873"

                icon.source: modelData
                icon.color: "white"
                icon.height: 30
                icon.width: 30

                display: (index % 4 === 3) || (index >= 0 && index <= 3) ? Button.IconOnly : Button.TextOnly

                background: Rectangle
                {
                    anchors.fill: parent
                    radius: 180

                    color:
                    {
                        var defColor = (index % 4 === 3) || (index >= 0 && index <= 3) ? "#0889A6" : "#B0D1D8";
                        var pressedColor = (index % 4 === 3) || (index >= 0 && index <= 3) ? "#F7E425" :"#04BFAD";

                        if (index === 16)
                        {
                            defColor = "#F9AFAF";
                            pressedColor = "#F25E5E";
                        }

                        return btn.down ? pressedColor : defColor
                    }
                }

                onClicked: composeEquation(btn.text)
                onPressAndHold: additionOperations(btn.text)

                onPressed:
                {
                    if(btn.text !== "qrc:/icons/equal.png") return

                    start_time = Date.now()
                }
                onReleased:
                {
                    if(btn.text !== "qrc:/icons/equal.png") return

                    var end_time = Date.now();
                    duration = end_time - start_time;
                    duration /= 1000
                    console.log("Button was pressed for", duration, "seconds.");

                    if(duration < 4) return
                    clear()
                    start_time = Date.now()
                    secretPanel = true
                    console.log("Secret panel activated, enter password");
                }

                function composeEquation(val)
                {
                    if(calc.isCompleted) clear()
                    var input_txt = input.text
                    var eq_txt = equation.text

                    switch(val)
                    {
                    case "C":
                        input.text = input_txt.slice(0, -1)

                        str = input.text

                        if(str.length <= 10)
                            input.font.pixelSize = 50

                        break;
                    case "qrc:/icons/plus.png":
                        input.text += "+"
                        break;
                    case "qrc:/icons/minus.png":
                        input.text += "-"
                        break;
                    case "qrc:/icons/multiplication.png":
                        input.text += "×"
                        break;
                    case "qrc:/icons/division.png":
                        input.text += "÷"
                        break;
                    case "qrc:/icons/bkt.png":
                        isOpenBracket = !isOpenBracket
                        if(isOpenBracket)
                            input.text += "("
                        else
                            input.text += ")"

                        break;
                    case "qrc:/icons/percent.png":
                        input.text += "%"
                        break;
                    case "qrc:/icons/plus_minus.png":
                        input.text += "-"
                        break;
                    case "qrc:/icons/equal.png":
                        calc.isCompleted = true
                        equation.text += input.text
                        input.text = calc.solve(equation.text)

                        str = input.text

                        if(str.length > 10)
                            input.font.pixelSize = 16
                        break;
                    default:
                        input.text += val

                        str = input.text

                        if(str.length > 10)
                            input.font.pixelSize = 16

                        if(!secretPanel) break;

                        var end_time = Date.now();
                        duration = end_time - start_time;
                        duration /= 1000

                        if(duration > 5)
                        {
                            secretPanel = false
                            break;
                        }

                        if(input.text === "123")
                        {
                            mainWindow.maximumWidth = 800
                            mainWindow.minimumWidth = mainWindow.maximumWidth
                            mainWindow.width = mainWindow.maximumWidth

                            secretText.visible = true
                            secretBtn.visible = true
                        }
                    }
                }

                function additionOperations(val)
                {
                    switch(val)
                    {
                    case "C": clear()
                        break;
                    default: composeEquation(val)
                    }
                }

                function clear()
                {
                    calc.isCompleted = false
                    isOpenBracket = false
                    input.font.pixelSize = 50
                    input.text = ""
                    equation.text = ""
                }
            }
        }
    }
}
