<template>
  <div>
    <h4 class="title is-4">
      New People
    </h4>

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
                <option>DWFI Global Fellow</option>
                <option>DWFI Staff</option>
                <option>DWFI Post-Doctoral Researcher</option>
                <option>DWFI Visiting Scholar/Professor</option>
                <option>DWFI Student/Intern</option>
                <option>University of Nebraska Faculty</option>
                <option>International Advisory Panel</option>
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

    <div class="field is-horizontal item-row" v-for="(f, i) in files">
      <div class="field-label is-normal">
        <label class="label" v-if="i==0">Files</label>
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
        <label class="label" v-if="!files.length">Files</label>
      </div>
      <div class="field-body">
        <div class="field is-grouped">
          <div class="control">
            <button class="button" @click="addFile"><icon name="plus"></icon>&nbsp;File</button>
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
            <router-link class="button is-text" :to="'/table/people'">Cancel</router-link>
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
  name: 'new-program',
  components: {
    Datepicker
  },
  data () {
    return {
      waiting: false,
      error: '',
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
      files: []
    }
  },
  methods: {
    requestResources () {
      this.$http.get(xHTTPx + '/get_files').then(response => {
        this.allFiles = response.body.map(function(f){
          return {id: f.id, label: f.name + ' [' + f.id + ']'}
        }).sort(function(a, b){
          return a.label.localeCompare(b.label)
        })
      })
    },
    addFile () {
      this.files.push({file_id: (this.allFiles.length ? this.allFiles[0].id : null), comment: ''})
    },
    removeFile (idx) {
      this.files.splice(idx, 1)
    },
    create () {
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
        files: JSON.stringify(this.files)
      }
      this.$http.post(xHTTPx + '/create_people', message).then(response => {
        var resp = response.body
        this.waiting = false
        this.error = ''
        this.$router.push('/table/people')
      }, response => {
        this.error = 'Failed to create people!'
        this.waiting = false
      })
    }
  },
  mounted () {
    this.requestResources()
  }
}
</script>

<style lang="scss" scoped>
.item-row {
  margin-bottom: 8px;
}
</style>
