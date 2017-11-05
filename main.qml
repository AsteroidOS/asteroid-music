/*
 * Copyright (C) 2016 - Florent Revest <revestflo@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.9
import org.asteroid.controls 1.0
import org.asteroid.utils 1.0
import org.nemomobile.mpris 1.0

Application {
    id: app

    centerColor: "#31bee7"
    outerColor: "#052442"

    MprisManager { id: mprisManager }

    property bool isPlaying: mprisManager.currentService && mprisManager.playbackStatus == Mpris.Playing

    Marquee {
        id: songLabel
        visible: btStatus.connected
        color: "white"
        font.pixelSize: Dims.l(7)
        font.bold: true
        anchors.top: parent.top
        anchors.topMargin: Dims.h(7)
        anchors.horizontalCenter: parent.horizontalCenter
        height: Dims.h(10)
        width: DeviceInfo.hasRoundScreen ? Dims.w(60) : Dims.w(80)

        text: if (mprisManager.currentService) {
            var titleTag = Mpris.metadataToString(Mpris.Title)
            return (titleTag in mprisManager.metadata) ? mprisManager.metadata[titleTag].toString() : ""
        }
    }

    Marquee {
        id: artistLabel
        visible: btStatus.connected
        color: "white"
        font.pixelSize: Dims.l(7)
        anchors.top: songLabel.bottom
        anchors.topMargin: Dims.h(1)
        anchors.horizontalCenter: parent.horizontalCenter
        height: Dims.h(10)
        width: DeviceInfo.hasRoundScreen ? Dims.w(70) : Dims.w(80)

        text: if (mprisManager.currentService) {
            var artistTag = Mpris.metadataToString(Mpris.Artist)
            return (artistTag in mprisManager.metadata) ? mprisManager.metadata[artistTag].toString() : ""
        }
    }

    IconButton {
        id: previousButton
        visible: btStatus.connected
        edge: Qt.LeftEdge
        iconName: "ios-arrow-dropleft"
        onClicked: if (mprisManager.canGoPrevious) mprisManager.previous()
    }

    IconButton {
        id: playButton
        visible: btStatus.connected
        edge: undefinedEdge
        anchors.centerIn: parent
        width: Dims.w(40)
        height: width
        iconName: isPlaying ? "ios-pause" : "ios-play"
        onClicked: {
            if (isPlaying && mprisManager.canPause)
                mprisManager.pause()
            else if (!isPlaying && mprisManager.canPlay)
                mprisManager.play()
        }
    }

    IconButton {
        id: nextButton
        visible: btStatus.connected
        edge: Qt.RightEdge
        iconName: "ios-arrow-dropright"
        onClicked: if (mprisManager.canGoNext) mprisManager.next()
    }

    BluetoothStatus {
        id: btStatus
    }

    Rectangle {
        id: noDataBackground
        visible: !btStatus.connected
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -Dims.h(13)
        color: "black"
        radius: width/2
        opacity: 0.2
        width: Dims.w(25)
        height: width
    }
    Icon {
        visible: !btStatus.connected
        anchors.fill: noDataBackground
        anchors.margins: Dims.l(3)
        name: "ios-sync"
    }

    Text {
        id: noDataText
        visible: !btStatus.connected
        text: qsTr("<h3>No data</h3>\nSync AsteroidOS with your phone.")
        font.pixelSize: Dims.l(5)
        color: "white"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.Wrap
        anchors.left: parent.left; anchors.right: parent.right
        anchors.leftMargin: Dims.w(2); anchors.rightMargin: Dims.w(2)
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: Dims.h(15)
    }
}

