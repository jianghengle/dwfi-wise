<template>
  <div> 
    <h4 class="title is-4">
      <a class="button back-button" @click="$router.go(-1)">
        <icon name="chevron-left"></icon>
      </a>&nbsp;&nbsp;&nbsp;&nbsp;
      File {{fileId}}
    </h4>

    <div class="has-text-centered" v-if="waiting">
      <icon name="spinner" class="icon is-medium fa-spin"></icon>
    </div>

    <div v-if="error" class="notification is-danger">
      <button class="delete" @click="error=''"></button>
      {{error}}
    </div>

    <div class="field is-horizontal">
      <div class="field-label is-normal">
        <label class="label">Name</label>
      </div>
      <div class="field-body">
        <div class="field">
          <div class="control">
            <input class="input" type="text" v-model="name" :disabled="privileges == 'Read Only'">
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
              <select v-model="fileType" :disabled="privileges == 'Read Only'">
                <option>document</option>
                <option>photo</option>
                <option>video</option>
              </select>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal">
      <div class="field-label is-normal">
        <label class="label">Url</label>
      </div>
      <div class="field-body">
        <div class="field">
          <div class="control">
            <input class="input" type="text" v-model="url" :disabled="privileges == 'Read Only'">
            <div class="file-container">
              <div v-if="fileType=='photo'">
                <img :src="fullUrl"/>
              </div>
              <div v-if="fileType=='video'">
                <video class="video" controls>
                  <source :src="fullUrl">
                  Your browser does not support the video tag.
                </video>
              </div>
              <div v-if="fileType=='document'">
                <iframe class="doc" :src="iframeSource"></iframe>
              </div>
            </div>
          </div>
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

    <div class="field is-horizontal" v-if="privileges == 'Edit' || privileges == 'Approve'">
      <div class="field-label">
        <!-- Left empty for spacing -->
      </div>
      <div class="field-body">
        <div class="field is-grouped">
          <div class="control">
            <button class="button is-link" @click="update" :disabled="!changed" :class="{'is-loading': waiting}">Update</button>
          </div>
          <div class="control">
            <button class="button is-danger" @click="deleteSelf" :disabled="changed" :class="{'is-loading': waiting}">Delete</button>
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
  name: 'my-file',
  components: {
    Datepicker
  },
  data () {
    return {
      waiting: false,
      error: '',
      success: '',
      oldFile: null,
      name: '',
      fileType: '',
      url: '',
    }
  },
  computed: {
    privileges () {
      return this.$store.state.user.privileges
    },
    fileId () {
      return this.$route.params.id
    },
    changed () {
      var file = this.collectFile()
      if(JSON.stringify(file) != JSON.stringify(this.oldFile))
        return true
      return false
    },
    fullUrl () {
      if(this.url.startsWith('/')){
        return xHTTPx + this.url
      }
      return this.url
    },
    iframeSource () {
      return "https://docs.google.com/gview?url=" + this.fullUrl + "&embedded=true"
    }
  },
  methods: {
    collectFile () {
      return {
        name: this.name,
        fileType: this.fileType,
        url: this.url,
      }
    },
    getFile () {
      this.waiting = true
      this.$http.get(xHTTPx + '/get_file/' + this.fileId).then(response => {
        var resp = response.body
        this.name = resp.name
        this.fileType = resp.fileType
        this.url = resp.url
        this.status = resp.status
        this.oldFile = this.collectFile()
        this.waiting = false
        this.error = ''
      }, response => {
        this.error = 'Failed to get file!'
        this.waiting = false
      })
    },
    update () {
      var message = {
        name: this.name,
        fileType: this.fileType,
        url: this.url
      }
      this.$http.post(xHTTPx + '/update_file/' + this.fileId, message).then(response => {
        var resp = response.body
        this.success = 'Data updated successfully!'
        this.getFile()
      }, response => {
        this.error = 'Failed to update file!'
        this.waiting = false
      })
    },
    deleteSelf () {
      var confirm = {
        title: 'Delete File',
        message: 'Are you sure to delete the file?',
        button: 'Yes, delete it.',
        callback: {
          context: this,
          method: this.deleteConfirmed,
          args: []
        }
      }
      this.$store.commit('modals/openConfirmModal', confirm)
    },
    deleteConfirmed () {
      var message = {fileId: this.fileId}
      this.$http.post(xHTTPx + '/delete_file', message).then(response => {
        if(response.body.ok){
          this.$router.replace('/table/files')
        }
      }, response => {
        this.error = 'Failed to delete file!'
        this.waiting = false
      })
    },
  },
  mounted () {
    this.getFile()
  }
}
</script>

<style lang="scss" scoped>

.file-container {
  margin-top: 10px;
}

.doc {
  width: 100%;
  height: 600px;
}

.video {
  width: 100%;
  height: auto;
}

</style>
