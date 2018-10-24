<template>
  <div>
    <h4 class="title is-4">
      New File
    </h4>

    <div class="field is-horizontal">
      <div class="field-label">
        <label class="label">Upload File?</label>
      </div>
      <div class="field-body">
        <div class="field is-narrow">
          <div class="control">
            <label class="radio">
              <input type="radio" value="Yes" v-model="uploadFile">
              Yes
            </label>
            <label class="radio">
              <input type="radio" value="No" v-model="uploadFile">
              No
            </label>
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal" v-show="uploadFile=='Yes'">
      <div class="field-label is-normal">
        <label class="label">File</label>
      </div>
      <div class="field-body">
        <div class="field">
          <div class="control">
            <label class="file-label">
              <input class="file-input" type="file"@change="onFileChange">
              <span class="file-cta">
                <span class="file-icon">
                  <icon name="upload"></icon>
                </span>
                <span class="file-label">
                  {{file ? file.name : 'Choose File'}}
                </span>
              </span>
            </label>
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal" v-show="uploadFile=='No'">
      <div class="field-label is-normal">
        <label class="label">Name</label>
      </div>
      <div class="field-body">
        <div class="field">
          <div class="control">
            <input class="input" type="text" v-model="name">
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal">
      <div class="field-label is-normal">
        <label class="label">File Type</label>
      </div>
      <div class="field-body">
        <div class="field is-narrow">
          <div class="control">
            <div class="select is-fullwidth">
              <select v-model="fileType">
                <option>document</option>
                <option>photo</option>
                <option>video</option>
              </select>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal" v-show="uploadFile=='No'">
      <div class="field-label is-normal">
        <label class="label">Url</label>
      </div>
      <div class="field-body">
        <div class="field">
          <div class="control">
            <input class="input" type="text" v-model="url">
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal">
      <div class="field-label">
        <!-- Left empty for spacing -->
      </div>
      <div class="field-body">
        <div class="field is-grouped">
          <div class="control">
            <button class="button is-link" @click="create">Create</button>
          </div>
          <div class="control">
            <router-link class="button is-text" :to="'/table/files'">Cancel</router-link>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import DateForm from 'dateformat'
import Datepicker from 'vuejs-datepicker'

export default {
  name: 'new-file',
  components: {
    Datepicker
  },
  data () {
    return {
      waiting: false,
      error: '',
      uploadFile: 'Yes',
      file: null,
      name: '',
      fileType: '',
      url: '',
    }
  },
  methods: {
    create () {
      var formData = new FormData()
      formData.append('uploadFile', this.uploadFile)
      formData.append('name', this.name)
      formData.append('fileType', this.fileType)
      formData.append('url', this.url)
      if(this.file){
        formData.append('file', this.file)
      }

      this.$http.post(xHTTPx + '/create_file', formData).then(response => {
        var resp = response.body
        this.waiting = false
        this.error = ''
        this.$router.push('/table/files')
      }, response => {
        this.error = 'Failed to create file!'
        this.waiting = false
      })
    },
    onFileChange(e) {
      var files = e.target.files || e.dataTransfer.files
      if (!files.length)
        return
      this.file = files[0]
    }
  }
}
</script>

<style lang="scss" scoped>

</style>
