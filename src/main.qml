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

    property bool isPlaying: mprisManager.currentService && mprisManager.playbackStatus == Mpris.Playing
    property double bufferedVolume: 0.0

    onBufferedVolumeChanged: mprisManager.volume = bufferedVolume

    MprisManager {
        id: mprisManager
        onVolumeChanged: bufferedVolumeTimer.restart()
    }

    BluetoothStatus { id: btStatus }

    Timer {
        id: bufferedVolumeTimer
        interval: 500
        repeat: false
        onTriggered: bufferedVolume = mprisManager.volume
    }

    StatusPage {
        //% "<h3>No data</h3>Sync AsteroidOS with your phone."
        text: qsTrId("id-no-data-sync")
        icon: "ios-sync"
        visible: !btStatus.connected
    }

    Item {
        anchors.fill: parent
        visible: btStatus.connected

        Image {
            id: coverArt
            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop
            opacity: 0.7
            source: if (mprisManager.currentService) {
                var artTag = Mpris.metadataToString(Mpris.ArtUrl)
                return (artTag in mprisManager.metadata) ? mprisManager.metadata[artTag] : ""
            }
        }

        Rectangle {
            visible: coverArt.status == Image.Ready
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: artistLabel.bottom
            anchors.bottomMargin: -Dims.h(0.5)
            color: "black"
            opacity: 0.5
        }

        Marquee {
            id: songLabel
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
            anchors.top: songLabel.bottom
            anchors.topMargin: -Dims.h(1)
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
            edge: Qt.LeftEdge
            iconName: "ios-arrow-dropleft"
            onClicked: if (mprisManager.canGoPrevious) mprisManager.previous()
        }

        IconButton {
            id: playButton
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
            edge: Qt.RightEdge
            iconName: "ios-arrow-dropright"
            onClicked: if (mprisManager.canGoNext) mprisManager.next()
        }

        IconButton {
            id: volDownButton
            edge: undefinedEdge
            anchors.left: parent.left
            anchors.leftMargin: Dims.w(16)
            anchors.bottom: parent.bottom
            anchors.bottomMargin: Dims.h(12)
            iconName: "ios-volume-down"
            onClicked: bufferedVolume = Math.max(bufferedVolume - 0.05, 0)
        }

        Rectangle {
            id: volumeSlider
            anchors.bottom: parent.bottom
            anchors.bottomMargin: Dims.h(21)
            anchors.horizontalCenter: parent.horizontalCenter
            height: Dims.h(2)
            width: Dims.w(28)
            color: "white"
            opacity: 0.6
            radius: 12
        }

        Rectangle {
            anchors.top: volumeSlider.top
            anchors.left: volumeSlider.left
            anchors.bottom: volumeSlider.bottom
            width: volumeSlider.width * mprisManager.volume
            color: "white"
            radius: 12
            opacity: 1.0
        }

        IconButton {
            id: volUpButton
            edge: undefinedEdge
            anchors.right: parent.right
            anchors.rightMargin: Dims.w(16)
            anchors.bottom: parent.bottom
            anchors.bottomMargin: Dims.h(12)
            iconName: "ios-volume-up"
            onClicked: bufferedVolume = Math.min(bufferedVolume + 0.05, 1)
        }
    }
}
