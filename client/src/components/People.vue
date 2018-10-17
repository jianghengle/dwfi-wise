<template>
  <div>
    <h4 class="title is-4">
      People {{peopleId}}
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
        <label class="label">First Name</label>
      </div>
      <div class="field-body">
        <div class="field">
          <div class="control">
            <input class="input" type="text" v-model="firstName">
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal">
      <div class="field-label is-normal">
        <label class="label">Last Name</label>
      </div>
      <div class="field-body">
        <div class="field">
          <div class="control">
            <input class="input" type="text" v-model="lastName">
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal">
      <div class="field-label is-normal">
        <label class="label">Credentials</label>
      </div>
      <div class="field-body">
        <div class="field">
          <div class="control">
            <textarea class="textarea" v-model="credentials"></textarea>
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal">
      <div class="field-label is-normal">
        <label class="label">Title</label>
      </div>
      <div class="field-body">
        <div class="field">
          <div class="control">
            <input class="input" type="text" v-model="title">
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal">
      <div class="field-label is-normal">
        <label class="label">Employer</label>
      </div>
      <div class="field-body">
        <div class="field">
          <div class="control">
            <input class="input" type="text" v-model="employer">
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal">
      <div class="field-label is-normal">
        <label class="label">DWFI Affiliation</label>
      </div>
      <div class="field-body">
        <div class="field is-narrow">
          <div class="control">
            <div class="select is-fullwidth">
              <select v-model="dwfiAffiliation">
                <option>DWFI Director</option>
                <option>DWFI Faculty Fellow</option>
                <option>DWFI Staff</option>
                <option>DWFI Post-Doctoral Researcher</option>
                <option>DWFI Visiting Scholar/Professor</option>
                <option>DWFI Student</option>
                <option>University of Nebraska Faculty</option>
                <option>Other</option>
              </select>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal">
      <div class="field-label is-normal">
        <label class="label">Email</label>
      </div>
      <div class="field-body">
        <div class="field">
          <div class="control">
            <input class="input" type="text" v-model="email">
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal">
      <div class="field-label is-normal">
        <label class="label">Phone</label>
      </div>
      <div class="field-body">
        <div class="field">
          <div class="control">
            <input class="input" type="text" v-model="phone">
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal">
      <div class="field-label is-normal">
        <label class="label">Website</label>
      </div>
      <div class="field-body">
        <div class="field">
          <div class="control">
            <input class="input" type="text" v-model="website">
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal item-row" v-for="(f, i) in files" v-if="f.file_id">
      <div class="field-label is-normal">
        <label class="label" v-if="i==firstFile">Files</label>
      </div>
      <div class="field-body">
        <div class="field is-grouped">
          <p class="select">
            <select v-model="f.file_id">
              <option v-for="opt in allFiles" v-bind:value="opt.id">{{opt.label}}</option>
            </select>
          </p>&nbsp;&nbsp;&nbsp;
          <p class="control is-expanded">
            <input class="input" type="text" placeholder="Comment" v-model="f.comment">
          </p>
          <p class="control">
            <a class="button is-text" @click="removeFile(i)">
              <icon name="remove"></icon>
            </a>
          </p>
        </div>
      </div>
    </div>

    <div class="field is-horizontal">
      <div class="field-label">
        <label class="label" v-if="firstFile >= files.length">Files</label>
      </div>
      <div class="field-body">
        <div class="field is-grouped">
          <div class="control">
            <button class="button" @click="addFile"><icon name="plus"></icon>&nbsp;File</button>
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

    <div class="field is-horizontal">
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
            <router-link class="button is-text" :to="'/table/people'">Cancel</router-link>
          </div>
        </div>
      </div>
    </div>

    <confirm-modal
      :opened="confirmModal.opened"
      :title="confirmModal.title"
      :message="confirmModal.message"
      :confirm-button="confirmModal.confirmButton"
      @close-confirm-modal="closeConfirmModal">
    </confirm-modal>
  </div>
</template>

<script>
import DateForm from 'dateformat'
import Datepicker from 'vuejs-datepicker'
import ConfirmModal from './modals/ConfirmModal'

export default {
  name: 'people',
  components: {
    Datepicker,
    ConfirmModal
  },
  data () {
    return {
      waiting: false,
      error: '',
      success: '',
      oldPeople: null,
      oldFiles: null,
      allFiles: [],
      firstName: '',
      lastName: '',
      credentials: '',
      title: '',
      employer: '',
      dwfiAffiliation: '',
      email: '',
      phone: '',
      website: '',
      files: [],
      confirmModal: {
        opened: false,
        message: '',
        button: '',
        context: null
      },
    }
  },
  computed: {
    peopleId () {
      return this.$route.params.id
    },
    firstFile () {
      var i = 0
      while(i < this.files.length && (!this.files[i].file_id))
        i++
      return i
    },
    changed () {
      var people = this.collectPeople()
      if(JSON.stringify(people) != JSON.stringify(this.oldPeople))
        return true
      if(JSON.stringify(this.files) != JSON.stringify(this.oldFiles))
        return true
      return false
    },
    changedFiles () {
      var changed = []
      for(var i=0;i<this.files.length;i++){
        var f = this.files[i]
        if(!f.file_id){
          changed.push(f)
        }else if(f.id){
          var old = this.oldFiles[i]
          if(f.file_id != old.file_id || f.comment != old.comment){
            changed.push(f)
          }
        }else{
          changed.push(f)
        }
      }
      return changed
    }
  },
  methods: {
    collectPeople () {
      return {
        firstName: this.firstName,
        lastName: this.lastName,
        credentials: this.credentials,
        title: this.title,
        employer: this.employer,
        dwfiAffiliation: this.dwfiAffiliation,
        email: this.email,
        phone: this.phone,
        website: this.website
      }
    },
    getPeople () {
      this.waiting = true
      this.$http.get(xHTTPx + '/get_one_people/' + this.peopleId).then(response => {
        var resp = response.body
        this.firstName = resp[0].firstName
        this.lastName = resp[0].lastName
        this.credentials = resp[0].credentials
        this.title = resp[0].title
        this.employer = resp[0].employer
        this.dwfiAffiliation = resp[0].dwfiAffiliation
        this.email = resp[0].email
        this.phone = resp[0].phone
        this.website = resp[0].website
        this.oldPeople = this.collectPeople()
        this.files = resp[1].map(function(f){
          return {id: f.id, file_id: f.fileId, comment: f.comment}
        })
        this.oldFiles = JSON.parse(JSON.stringify(this.files))
        this.waiting = false
        this.error = ''
      }, response => {
        this.error = 'Failed to get people!'
        this.waiting = false
      })
    },
    requestResources () {
      this.$http.get(xHTTPx + '/get_files').then(response => {
        this.allFiles = response.body.map(function(f){
          return {id: f.id, label: f.name + ' [' + f.id + ']'}
        })
      })
    },
    addFile () {
      if(this.allFiles.length){
        this.files.push({file_id: this.allFiles[0].id, comment: ''})
      }
    },
    removeFile (idx) {
      if(this.files[idx].id){
        this.files[idx].file_id = null
      }else{
        this.files.splice(idx, 1)
      }
    },
    update () {
      var message = {
        firstName: this.firstName,
        lastName: this.lastName,
        credentials: this.credentials,
        title: this.title,
        employer: this.employer,
        dwfiAffiliation: this.dwfiAffiliation,
        email: this.email,
        phone: this.phone,
        website: this.website,
        files: JSON.stringify(this.changedFiles)
      }
      this.$http.post(xHTTPx + '/update_people/' + this.peopleId, message).then(response => {
        var resp = response.body
        this.success = 'Data updated successfully!'
        this.getPeople()
      }, response => {
        this.error = 'Failed to update people!'
        this.waiting = false
      })
    },
    deleteSelf () {
      var title = 'Delete People'
      var message = 'Are you sure to delete the people?'
      var confirmButton = 'Yes, delete it.'
      var context = {callback: this.deleteConfirmed}
      this.openConfirmModal(title, message, confirmButton, context)
    },
    deleteConfirmed () {
      var message = {peopleId: this.peopleId}
      this.$http.post(xHTTPx + '/delete_people', message).then(response => {
        if(response.body.ok){
          this.$router.replace('/table/people')
        }
      }, response => {
        this.error = 'Failed to delete people!'
        this.waiting = false
      })
    },
    openConfirmModal (title, message, confirmButton, context) {
      this.confirmModal.title = title
      this.confirmModal.message = message
      this.confirmModal.confirmButton = confirmButton
      this.confirmModal.context = context
      this.confirmModal.opened = true
    },
    closeConfirmModal (result) {
      this.confirmModal.title = ''
      this.confirmModal.message = ''
      this.confirmModal.confirmButton = ''
      this.confirmModal.opened = false
      if(result && this.confirmModal.context){
        var context = this.confirmModal.context
        if(context.callback){
          context.callback.apply(this, context.args)
        }
      }
      this.confirmModal.context = null
    }
  },
  mounted () {
    this.getPeople()
    this.requestResources()
  }
}
</script>

<style lang="scss" scoped>
.item-row {
  margin-bottom: 8px;
}
</style>
