<template>
  <div>
    <h4 class="title is-4">
      New Directory
    </h4>

    <div class="field is-horizontal">
      <div class="field-label is-normal">
        <label class="label">People</label>
      </div>
      <div class="field-body">
        <div class="field">
          <div class="control">
            <div class="select">
              <select v-model="peopleId">
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
            <input class="input" type="text" v-model="typ">
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
            <input class="input" type="text" v-model="role">
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
            <input class="input" type="text" v-model="tags">
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
            <input class="input" type="text" v-model="institution">
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
            <input class="input" type="text" v-model="department">
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
            <input class="input" type="text" v-model="area">
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
            <input class="input" type="text" v-model="specialty">
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
            <button class="button is-link" @click="create" :disabled="!peopleId">Create</button>
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
  name: 'new-directory',
  components: {
    Datepicker
  },
  data () {
    return {
      waiting: false,
      error: '',
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
  methods: {
    requestResources () {
      this.$http.get(xHTTPx + '/get_people').then(response => {
        this.allPeople = response.body.map(function(p){
          return {id: p.id, label: p.firstName + ' ' + p.lastName + ' [' + p.id + ']'}
        }).sort(function(a, b){
          return a.label.localeCompare(b.label)
        })
      })
    },
    create () {
      var message = {
        peopleId: this.peopleId,
        typ: this.typ,
        role: this.role,
        tags: this.tags,
        institution: this.institution,
        department: this.department,
        area: this.area,
        specialty: this.specialty
      }
      this.$http.post(xHTTPx + '/create_directory', message).then(response => {
        var resp = response.body
        this.waiting = false
        this.error = ''
        this.$router.push('/table/directories')
      }, response => {
        this.error = 'Failed to create directory!'
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
    this.requestResources()
  }
}
</script>

<style lang="scss" scoped>

</style>
