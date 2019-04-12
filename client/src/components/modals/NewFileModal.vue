<template>
  <div class="modal"
      :class="{'is-active': opened}">
    <div class="modal-background"></div>
    <div class="modal-card">
      <header class="modal-card-head">
        <p class="modal-card-title">Create New File</p>
        <button class="delete" @click="close"></button>
      </header>
      <section class="modal-card-body">
        <div class="my-form">
          <div class="field">
            <label class="label">Upload File?</label>
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

          <div class="field" v-show="uploadFile=='Yes'">
            <label class="label">File</label>
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

          <div class="field" v-show="uploadFile=='No'">
            <label class="label">Name</label>
            <div class="control">
              <input class="input" type="text" v-model="name">
            </div>
          </div>

          <div class="field">
            <label class="label">File Type</label>
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

          <div class="field" v-show="uploadFile=='No'">
            <label class="label">Url</label>
            <div class="control">
              <input class="input" type="text" v-model="url">
            </div>
          </div>
        </div>

        <div v-if="error" class="notification is-danger">
          <button class="delete" @click="error=''"></button>
          {{error}}
        </div>

        <div v-if="success" class="notification is-success">
          <button class="delete" @click="success=''"></button>
          {{success}} 
        </div>

      </section>
      <footer class="modal-card-foot">
        <a class="button is-danger" :disabled="!canCreate" @click="create" :is-loading="waiting">Create</a>
        <a class="button" @click="close">Close</a>
      </footer>
    </div>
  </div>
</template>

<script>
export default {
  name: 'new-file-modal',
  data () {
    return {
      waiting: false,
      error: '',
      success: '',
      uploadFile: 'Yes',
      file: null,
      name: '',
      fileType: '',
      url: '',
    }
  },
  computed: {
    opened () {
      return this.$store.state.modals.newFileModal.opened
    },
    source () {
      return this.$store.state.modals.newFileModal.source
    },
    key () {
      return this.$store.state.modals.newFileModal.key
    },
    canCreate () {
      return this.uploadFile == 'Yes' ? this.file : (this.url && this.name)
    }
  },
  watch: {
    opened: function (val) {
      if (val) {
        this.waiting = false
        this.error = ''
        this.success = ''
        this.file = null
        this.name = ''
        this.fileType = ''
        this.url = ''
      }
    },
  },
  methods: {
    close(){
      var callback = this.$store.state.modals.newFileModal.callback
      if(callback){
        var method = callback.method
        var context = callback.context
        var args = callback.args
        method.apply(context, args)
      }
      this.$store.commit('modals/closeNewFileModal')
    },
    create(){
      if(!this.canCreate || this.waiting)
        return
      this.waiting = true
      
      var formData = new FormData()
      formData.append('source', this.source)
      formData.append('key', this.key)
      formData.append('uploadFile', this.uploadFile)
      formData.append('name', this.name)
      formData.append('fileType', this.fileType)
      formData.append('url', this.url)
      if(this.uploadFile == 'Yes' && this.file){
        formData.append('file', this.file)
      }

      this.$http.post(xHTTPx + '/new_file_by_requested', formData).then(response => {
        this.error = ''
        this.success = 'Created!'
        this.waiting = false
      }, response => {
        this.error = 'Failed to create!'
        this.success = ''
        this.waiting = false
      })
    },
    onFileChange(e) {
      var files = e.target.files || e.dataTransfer.files
      if (!files.length)
        return
      this.file = files[0]
    }
  },
}
</script>

<style lang="scss" scoped>
.my-form {
  margin-bottom: 10px;
}
</style>