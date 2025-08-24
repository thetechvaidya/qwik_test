<template>
    <div class="audio-options">
        <div class="w-full flex flex-col mb-6">
            <label class="pb-4 text-sm font-semibold text-gray-800">
                {{ __('Video Type') }} (Supported YouTube, Vimeo & .mp4 files)
            </label>
            <SelectButton v-model="options.video_type" :options="videoFormats" option-label="name" option-value="value" data-key="value" @change="changePlayer"></SelectButton>
        </div>
        <div class="w-full flex flex-col mb-6">
            <label for="video_link" class="pb-2 text-sm font-semibold text-gray-800">
                <span v-html="options.video_type === 'mp4' ? __('Video Link') : __('Video')+' ID'"></span>
            </label>
            <div class="p-inputgroup">
                <InputText id="video_link" v-model="options.link" :placeholder="options.video_type === 'mp4' ? __('Video Link') : __('Video')+' ID'" aria-describedby="video_link-help" @input="selectOptions" />
                <Button type="button" icon="pi pi-play" :label="__('Preview')" @click="showPlayer" />
            </div>
        </div>
        <div v-if="player" class="my-4 flex justify-end">
            <Button type="button" class="p-button-text" icon="pi pi-times" :label="__('Close')" @click="player = false" />
        </div>

        <div v-if="player && options.video_type === 'mp4'">
            <vue-plyr>
                <video :src="options.link">
                    <source :src="options.link" type="video/mp4">
                </video>
            </vue-plyr>
        </div>
        <div v-if="player && options.video_type === 'youtube'">
            <vue-plyr>
                <div class="plyr__video-embed">
                    <iframe :src="getVideoLink" allowfullscreen allowtransparency allow="autoplay"></iframe>
                </div>
            </vue-plyr>
        </div>
        <div v-if="player && options.video_type === 'vimeo'">
            <vue-plyr>
                <div class="plyr__video-embed">
                    <iframe :src="getVideoLink"></iframe>
                </div>
            </vue-plyr>
        </div>
    </div>
</template>
<script>
    import InputText from 'primevue/inputtext';
    import SelectButton from 'primevue/selectbutton';
    import Button from 'primevue/button';
    import VuePlyr from 'vue-plyr';

    export default {
        name: 'VideoOptions',
        components: {
            InputText,
            SelectButton,
            VuePlyr,
            Button
        },
        props: {
            parentOptions: Object,
        },
        data: function () {
            return {
                options: this.parentOptions,
                videoFormats: [
                    {value: 'mp4', name: 'MP4 Video'},
                    {value: 'youtube', name: 'YouTube Video'},
                    {value: 'vimeo', name: 'Vimeo Video'}
                ],
                player: false,
            }
        },
        computed: {
            getVideoLink() {
                if(this.options.video_type === 'youtube') {
                    return "https://www.youtube.com/embed/"+this.options.link+"?amp;iv_load_policy=3&amp;modestbranding=1&amp;playsinline=1&amp;showinfo=0&amp;rel=0&amp;enablejsapi=1";
                }
                if(this.options.video_type === 'vimeo') {
                    return "https://player.vimeo.com/video/"+this.options.link+"?loop=false&amp;byline=false&amp;portrait=false&amp;title=false&amp;speed=true&amp;transparent=0&amp;gesture=media"
                }
                return "";
            }
        },
        created() {
            if(this.options === null) {
                this.options = {video_type: 'mp4', link: ''};
            }
        },
        methods: {
            showPlayer() {
                this.player = false;
                if(this.options.link !== "" &&  this.options.link !== null) {
                    this.$nextTick(() => {
                        this.player = true;
                    });
                }
            },
            changePlayer(format) {
                this.player = false;
                this.options.link = '';
                this.selectOptions();
            },
            selectOptions () {
                this.$emit('modifyOptions', this.options)
            }
        }
    }
</script>
