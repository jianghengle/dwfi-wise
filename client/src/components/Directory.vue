<template>
  <div>
    <h4 class="title is-4">
      <a class="button back-button" @click="$router.go(-1)">
        <icon name="chevron-left"></icon>
      </a>&nbsp;&nbsp;&nbsp;&nbsp;
      Directory {{directoryId}}
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
        <label class="label">People</label>
      </div>
      <div class="field-body">
        <div class="field">
          <div class="control">
            <div class="select">
              <select v-model="peopleId" :disabled="privileges == 'Read Only'">
                <option v-for="opt in allPeople" v-bind:value="opt.id">{{opt.label}}</option>
              </select>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal">
      <div class="field-label is-normal">
        <label class="label">Type</label>
      </div>
      <div class="field-body">
        <div class="field">
          <div class="control">
            <input class="input" type="text" v-model="typ" :disabled="privileges == 'Read Only'">
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal">
      <div class="field-label is-normal">
        <label class="label">Role</label>
      </div>
      <div class="field-body">
        <div class="field">
          <div class="control">
            <input class="input" type="text" v-model="role" :disabled="privileges == 'Read Only'">
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal">
      <div class="field-label is-normal">
        <label class="label">Tags</label>
      </div>
      <div class="field-body">
        <div class="field">
          <div class="control">
            <input class="input" type="text" v-model="tags" :disabled="privileges == 'Read Only'">
          </div>
        </div>
      </div>
    </div>


    <div class="field is-horizontal">
      <div class="field-label is-normal">
        <label class="label">Institution</label>
      </div>
      <div class="field-body">
        <div class="field">
          <div class="control">
            <input class="input" type="text" v-model="institution" :disabled="privileges == 'Read Only'">
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal">
      <div class="field-label is-normal">
        <label class="label">Department</label>
      </div>
      <div class="field-body">
        <div class="field">
          <div class="control">
            <input class="input" type="text" v-model="department" :disabled="privileges == 'Read Only'">
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal">
      <div class="field-label is-normal">
        <label class="label">Area</label>
      </div>
      <div class="field-body">
        <div class="field">
          <div class="control">
            <input class="input" type="text" v-model="area" :disabled="privileges == 'Read Only'">
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal">
      <div class="field-label is-normal">
        <label class="label">Specialty</label>
      </div>
      <div class="field-body">
        <div class="field">
          <div class="control">
            <input class="input" type="text" v-model="specialty" :disabled="privileges == 'Read Only'">
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
            <router-link class="button is-text" :to="'/table/directories'">Cancel</router-link>
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
  name: 'directory',
  components: {
    Datepicker
  },
  data () {
    return {
      waiting: false,
      error: '',
      success: '',

      oldDirectory: null,
      allPeople: [],

      peopleId: null,
      typ: '',
      role: '',
      tags: '',
      institution: '',
      department: '',
      area: '',
      specialty: '',
    }
  },
  computed: {
    privileges () {
      return this.$store.state.user.privileges
    },
    directoryId () {
      return this.$route.params.id
    },
    changed () {
      var directory = this.collectDirectory()
      if(JSON.stringify(directory) != JSON.stringify(this.oldDirectory))
        return true
      return false
    }
  },
  methods: {
    collectDirectory () {
      return {
        peopleId: this.peopleId,
        typ: this.typ,
        role: this.role,
        tags: this.tags,
        institution: this.institution,
        department: this.department,
        area: this.area,
        specialty: this.specialty,
      }
    },
    getDirectory () {
      this.waiting = true
      this.$http.get(xHTTPx + '/get_directory/' + this.directoryId).then(response => {
        var resp = response.body
        this.peopleId = resp.peopleId
        this.typ = resp.typ
        this.role = resp.role
        this.tags = resp.tags
        this.institution = resp.institution
        this.department = resp.department
        this.area = resp.area
        this.specialty = resp.specialty
        this.oldDirectory = this.collectDirectory()
        
        this.waiting = false
        this.error = ''
      }, response => {
        this.error = 'Failed to get directory!'
        this.waiting = false
      })
    },
    requestResources () {
      this.$http.get(xHTTPx + '/get_people').then(response => {
        this.allPeople = response.body.map(function(p){
          return {id: p.id, label: p.firstName + ' ' + p.lastName + ' [' + p.id + ']'}
        }).sort(function(a, b){
          return a.label.localeCompare(b.label)
        })
      })
    },
    update () {
      var message = this.collectDirectory()
      this.$http.post(xHTTPx + '/update_directory/' + this.directoryId, message).then(response => {
        var resp = response.body
        this.success = 'Data updated successfully!'
        this.getDirectory()
      }, response => {
        this.error = 'Failed to update directory!'
        this.waiting = false
      })
    },
    deleteSelf () {
      var confirm = {
        title: 'Delete Directory',
        message: 'Are you sure to delete the directory?',
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
      var message = {directoryId: this.directoryId}
      this.$http.post(xHTTPx + '/delete_directory', message).then(response => {
        if(response.body.ok){
          this.$router.replace('/table/directories')
        }
      }, response => {
        this.error = 'Failed to delete directory!'
        this.waiting = false
      })
    },
    textareaChanged (id) {
      var el = document.getElementById(id);
      el.style.height = "1px";
      el.style.height = (25+el.scrollHeight)+"px";
    }
  },
  mounted () {
    this.getDirectory()
    this.requestResources()
  }
}
</script>

<style lang="scss" scoped>

</style>
