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

import QtQuick 2.4
import org.asteroid.controls 1.0
import org.asteroid.utils 1.0
import org.nemomobile.mpris 1.0

Application {
    id: app

    centerColor: "#31bee7"
    outerColor: "#052442"

    MprisManager { id: mprisManager }

    property bool isPlaying: mprisManager.currentService && mprisManager.playbackStatus == Mpris.Playing
    
    Text {
        id: songLabel
        visible: btStatus.connected
        enabled: visible
        color: "white"
        font.pixelSize: parent.height*0.07
        font.bold: true
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.topMargin: parent.height*0.07

        text: if (mprisManager.currentService) {
            var titleTag = Mpris.metadataToString(Mpris.Title)
            return (titleTag in mprisManager.metadata) ? mprisManager.metadata[titleTag].toString() : ""
        }
        width: parent.width
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignHCenter
    }

    Text {
        id: artistLabel
        visible: btStatus.connected
        enabled: visible
        color: "white"
        font.pixelSize: parent.height*0.07
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: songLabel.bottom
        anchors.topMargin: parent.height*0.01

        text: if (mprisManager.currentService) {
            var artistTag = Mpris.metadataToString(Mpris.Artist)
            return (artistTag in mprisManager.metadata) ? mprisManager.metadata[artistTag].toString() : ""
        }
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignHCenter
    }



    IconButton {
        id: previousButton
        visible: btStatus.connected
        enabled: visible
        anchors.left: parent.left
        anchors.leftMargin: parent.width/20
        anchors.verticalCenter: parent.verticalCenter
        iconSize: parent.width/5
        iconName: "ios-arrow-dropleft"
        iconColor: "white"
        pressedIconColor: "lightgrey"
        onClicked: if (mprisManager.canGoPrevious) mprisManager.previous()
    }

    IconButton {
        id: playButton
        visible: btStatus.connected
        enabled: visible
        anchors.centerIn: parent
        iconSize: parent.width*0.4
        iconName: isPlaying ? "ios-pause" : "ios-play"
        iconColor: "white"
        pressedIconColor: "lightgrey"
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
        enabled: visible
        anchors.right: parent.right
        anchors.rightMargin: parent.width/20
        anchors.verticalCenter: parent.verticalCenter
        iconSize: parent.width/5
        iconName: "ios-arrow-dropright"
        iconColor: "white"
        pressedIconColor: "lightgrey"
        onClicked: if (mprisManager.canGoNext) mprisManager.next()
    }

    BluetoothStatus {
        id: btStatus
    }

    Icon {
        visible: !btStatus.connected
        color: "white"
        name: "ios-sync"
        anchors.top: parent.top
        anchors.topMargin: Units.dp(16)
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Text {
        visible: !btStatus.connected
        text: qsTr("<h3>No data</h3>\nSync AsteroidOS with your phone.")
        color: "white"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.Wrap
        anchors.left: parent.left; anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
    }
}

