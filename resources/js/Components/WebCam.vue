<template>
    <video ref="video" :width="width" :height="height" :src="source" :autoplay="autoplay" :playsinline="playsinline" />
</template>

<script setup>
import { ref, watch, onMounted, onBeforeUnmount } from 'vue'

// Props
const props = defineProps({
    width: {
        type: [Number, String],
        default: '100%',
    },
    height: {
        type: [Number, String],
        default: 500,
    },
    autoplay: {
        type: Boolean,
        default: true,
    },
    screenshotFormat: {
        type: String,
        default: 'image/jpeg',
    },
    selectFirstDevice: {
        type: Boolean,
        default: false,
    },
    deviceId: {
        type: String,
        default: null,
    },
    playsinline: {
        type: Boolean,
        default: true,
    },
    resolution: {
        type: Object,
        default: null,
        validator: value => {
            return value && value.height && value.width
        },
    },
})

// Emits
const emit = defineEmits(['cameras', 'notsupported', 'camera-change', 'video-live', 'started', 'stopped', 'error'])

// Template refs
const video = ref(null)

// Reactive data
const source = ref(null)
const canvas = ref(null)
const ctx = ref(null)
const camerasListEmitted = ref(false)
const cameras = ref([])

// Watch deviceId changes
watch(
    () => props.deviceId,
    id => {
        if (id) {
            changeCamera(id)
        }
    }
)

// Methods
const legacyGetUserMediaSupport = () => {
    return constraints => {
        // First get ahold of the legacy getUserMedia, if present
        let getUserMedia =
            navigator.getUserMedia ||
            navigator.webkitGetUserMedia ||
            navigator.mozGetUserMedia ||
            navigator.msGetUserMedia ||
            navigator.oGetUserMedia
        // Some browsers just don't implement it - return a rejected promise with an error
        // to keep a consistent interface
        if (!getUserMedia) {
            return Promise.reject(new Error('getUserMedia is not implemented in this browser'))
        }
        // Otherwise, wrap the call to the old navigator.getUserMedia with a Promise
        return new Promise(function (resolve, reject) {
            getUserMedia.call(navigator, constraints, resolve, reject)
        })
    }
}

const setupMedia = () => {
    if (navigator.mediaDevices === undefined) {
        navigator.mediaDevices = {}
    }
    if (navigator.mediaDevices.getUserMedia === undefined) {
        navigator.mediaDevices.getUserMedia = legacyGetUserMediaSupport()
    }
    testMediaAccess()
}

const loadCameras = () => {
    navigator.mediaDevices
        .enumerateDevices()
        .then(deviceInfos => {
            for (let i = 0; i !== deviceInfos.length; ++i) {
                let deviceInfo = deviceInfos[i]
                if (deviceInfo.kind === 'videoinput') {
                    cameras.value.push(deviceInfo)
                }
            }
        })
        .then(() => {
            if (!camerasListEmitted.value) {
                if (props.selectFirstDevice && cameras.value.length > 0) {
                    props.deviceId = cameras.value[0].deviceId
                }
                emit('cameras', cameras.value)
                camerasListEmitted.value = true
            }
        })
        .catch(error => emit('notsupported', error))
}

const changeCamera = deviceId => {
    stop()
    emit('camera-change', deviceId)
    loadCamera(deviceId)
}

const loadSrcStream = stream => {
    if ('srcObject' in video.value) {
        // new browsers api
        video.value.srcObject = stream
    } else {
        // old browsers
        source.value = window.HTMLMediaElement.srcObject(stream)
    }
    // Emit video start/live event
    video.value.onloadedmetadata = () => {
        emit('video-live', stream)
    }
    emit('started', stream)
}

const stopStreamedVideo = videoElem => {
    let stream = videoElem.srcObject
    if (stream) {
        let tracks = stream.getTracks()
        tracks.forEach(track => {
            // stops the video track
            track.stop()
            emit('stopped', stream)
            video.value.srcObject = null
            source.value = null
        })
    }
}

const stop = () => {
    if (video.value !== null && video.value.srcObject) {
        stopStreamedVideo(video.value)
    }
}

const start = () => {
    if (props.deviceId) {
        loadCamera(props.deviceId)
    }
}

const pause = () => {
    if (video.value !== null && video.value.srcObject) {
        video.value.pause()
    }
}

const resume = () => {
    if (video.value !== null && video.value.srcObject) {
        video.value.play()
    }
}

const testMediaAccess = () => {
    let constraints = { video: true }
    if (props.resolution) {
        constraints.video = {}
        constraints.video.height = props.resolution.height
        constraints.video.width = props.resolution.width
    }
    navigator.mediaDevices
        .getUserMedia(constraints)
        .then(stream => {
            //Make sure to stop this MediaStream
            let tracks = stream.getTracks()
            tracks.forEach(track => {
                track.stop()
            })
            loadCameras()
        })
        .catch(error => emit('error', error))
}

const loadCamera = device => {
    let constraints = { video: { deviceId: { exact: device } } }
    if (props.resolution) {
        constraints.video.height = props.resolution.height
        constraints.video.width = props.resolution.width
    }
    navigator.mediaDevices
        .getUserMedia(constraints)
        .then(stream => loadSrcStream(stream))
        .catch(error => emit('error', error))
}

const capture = () => {
    return getCanvas().toDataURL(props.screenshotFormat)
}

const getCanvas = () => {
    if (!video.value) {
        throw new Error('Video element not available')
    }

    if (!ctx.value) {
        let canvasElement = document.createElement('canvas')
        canvasElement.height = video.value.videoHeight
        canvasElement.width = video.value.videoWidth
        canvas.value = canvasElement
        ctx.value = canvasElement.getContext('2d')
    }

    ctx.value.drawImage(video.value, 0, 0, canvas.value.width, canvas.value.height)
    return canvas.value
}

// Lifecycle
onMounted(() => {
    setupMedia()
})

onBeforeUnmount(() => {
    stop()
})

// Expose methods for parent components
defineExpose({
    capture,
    start,
    stop,
    pause,
    resume,
    changeCamera,
})
</script>
