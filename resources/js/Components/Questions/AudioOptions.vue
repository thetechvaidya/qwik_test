<template>
    <div class="audio-options">
        <div class="w-full flex flex-col mb-6">
            <label class="pb-2 text-sm font-semibold text-gray-800">
                {{ __('Audio Type') }} (Supported .mp3 & .ogg files)
            </label>
            <SelectButton v-model="options.audio_type" :options="audioFormats" option-label="name" option-value="value" data-key="value" @change="changePlayer"></SelectButton>
        </div>
        <div class="w-full flex flex-col mb-6">
            <label for="audio_link" class="pb-2 text-sm font-semibold text-gray-800">
                {{ __('Audio Link') }}
            </label>
            <InputText id="audio_link" v-model="options.link" :placeholder="__('Audio Link')" aria-describedby="audio_link-help" @input="selectOptions" />
        </div>
        <div class="my-4 flex">
            <Button type="button" icon="pi pi-play" :label="__('Preview')" @click="showPlayer" />
        </div>
        <div v-if="player && options.audio_type === 'mp3'">
            <vue-plyr>
                <audio controls crossorigin playsinline>
                    <source :src="getAudioLink" type="audio/mp3" />
                </audio>
            </vue-plyr>
        </div>
        <div v-if="player && options.audio_type === 'ogg'">
            <vue-plyr>
                <audio controls crossorigin playsinline>
                    <source :src="getAudioLink" type="audio/ogg" />
                </audio>
            </vue-plyr>
        </div>
    </div>
</template>
<script>
    import InputText from 'primevue/inputtext';
    import SelectButton from 'primevue/selectbutton';
    import VuePlyr from 'vue-plyr';
    import Button from 'primevue/button';

    export default {
        name: 'AudioOptions',
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
                audioFormats: [
                    {value: 'mp3', name: 'MP3 Format'},
                    {value: 'ogg', name: 'OGG Format'}
                ],
                player: false,
            }
        },
        computed: {
            getAudioLink() {
                return this.options.link;
            }
        },
        created() {
            if(this.options === null) {
                this.options = {audio_type: 'mp3', link: ''};
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
