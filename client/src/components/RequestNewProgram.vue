<template>
  <div>
    <h4 class="title is-4">
      New Program
    </h4>

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
        <label class="label">Description</label>
      </div>
      <div class="field-body">
        <div class="field">
          <div class="control">
            <textarea id="textarea-description" class="textarea" v-model="description" @change="descriptionChanged"></textarea>
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal item-row" v-for="(p, i) in people">
      <div class="field-label is-normal">
        <label class="label" v-if="i==0">People</label>
      </div>
      <div class="field-body">
        <div class="field is-grouped">
          <p class="select">
            <select v-model="p.people_id">
              <option v-for="opt in allPeople" v-bind:value="opt.id">{{opt.label}}</option>
            </select>
          </p>&nbsp;&nbsp;&nbsp;
          <p class="control is-expanded">
            <input class="input" type="text" placeholder="Role" v-model="p.role">
          </p>
          <p class="control">
            <a class="button is-text" @click="removePeople(i)">
              <icon name="remove"></icon>
            </a>
          </p>
        </div>
      </div>
    </div>

    <div class="field is-horizontal">
      <div class="field-label">
        <label class="label" v-if="!people.length">People</label>
      </div>
      <div class="field-body">
        <div class="field is-grouped">
          <div class="control">
            <button class="button" @click="addPeople"><icon name="plus"></icon>&nbsp;People</button>
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal">
      <div class="field-label is-normal">
        <label class="label">Status</label>
      </div>
      <div class="field-body">
        <div class="field is-narrow">
          <div class="control">
            <div class="select is-fullwidth">
              <select v-model="status">
                <option>Pending</option>
                <option>In progress</option>
                <option>On-going</option>
                <option>On hold</option>
                <option>Completed</option>
                <option>Other</option>
                <option>Unknown - refer to point of contact</option>
              </select>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal">
      <div class="field-label is-normal">
        <label class="label">Countries</label>
      </div>
      <div class="field-body">
        <div class="field is-narrow">
          <div class="control">
            <div class="selected-multiple-options">
              {{countryInput.join(', ')}}
              <a class="button is-text clear-country-button" @click="countryInput = []" v-if="countryInput.length">
                <icon name="remove"></icon>
              </a>
            </div>
            <div class="select is-multiple">
              <select multiple v-model="countryInput" size="3">
                <option v-for="c in countries">{{c}}</option>
              </select>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal" v-if="countryInput.length == 1 && countryInput[0] == 'United States of America'">
      <div class="field-label is-normal">
        <label class="label">State</label>
      </div>
      <div class="field-body">
        <div class="field">
          <div class="control">
            <div class="selected-multiple-options">
              {{stateInput.join(', ')}}
              <a class="button is-text clear-country-button" @click="stateInput = []" v-if="stateInput.length">
                <icon name="remove"></icon>
              </a>
            </div>
            <div class="select is-multiple">
              <select multiple v-model="stateInput" size="3">
                <option v-for="s in states">{{s}}</option>
              </select>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal" v-if="countryInput.length == 1 && countryInput[0] != 'United States of America'">
      <div class="field-label is-normal">
        <label class="label">State/Province</label>
      </div>
      <div class="field-body">
        <div class="field">
          <div class="control">
            <input class="input" type="text" v-model="state">
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal">
      <div class="field-label is-normal">
        <label class="label">Focus Area</label>
      </div>
      <div class="field-body">
        <div class="field is-narrow">
          <div class="control">
            <div class="selected-multiple-options">
              {{focusAreaInput.join(', ')}}
            </div>
            <div class="select is-multiple is-fullwidth">
              <select multiple v-model="focusAreaInput" size="7">
                <option>[FA1] Closing Water & Agricultural Productivity Gaps</option>
                <option>[FA2] Improving Groundwater Management for Agricultural Production</option>
                <option>[FA3] Enhancing High-productivity Irrigated Agriculture</option>
                <option>[FA4] Freshwater & Agriculture Ecosystems & Public Health</option>
                <option>[FA5] Management of Agricultural Drought</option>
                <option>Education & Engagement Projects & Programs</option>
                <option>Communications</option>
              </select>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal">
      <div class="field-label is-normal">
        <label class="label">Start Date</label>
      </div>
      <div class="field-body">
        <div class="field">
          <div class="control">
            <datepicker
              wrapper-class="date-picker-wrapper"
              input-class="date-picker-input"
              format="MMM dd yyyy"
              :value="startDate"
              v-on:selected="startDateSelected">
            </datepicker>
            <a class="button is-text" @click="startDate = null">
              <icon name="remove"></icon>
            </a>
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal">
      <div class="field-label is-normal">
        <label class="label">End Date</label>
      </div>
      <div class="field-body">
        <div class="field">
          <div class="control">
            <datepicker
              wrapper-class="date-picker-wrapper"
              input-class="date-picker-input"
              format="MMM dd yyyy"
              :value="endDate"
              v-on:selected="endDateSelected">
            </datepicker>
            <a class="button is-text" @click="endDate = null">
              <icon name="remove"></icon>
            </a>
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal item-row" v-for="(g, i) in grants">
      <div class="field-label is-normal">
        <label class="label" v-if="i==0">Grants</label>
      </div>
      <div class="field-body">
        <div class="field is-grouped">
          <p class="select">
            <select v-model="g.grant_id">
              <option v-for="opt in allGrants" v-bind:value="opt.id">{{opt.label}}</option>
            </select>
          </p>&nbsp;&nbsp;&nbsp;
          <p class="control is-expanded">
            <input class="input" type="text" placeholder="Comment" v-model="g.comment">
          </p>
          <p class="control">
            <a class="button is-text" @click="removeGrant(i)">
              <icon name="remove"></icon>
            </a>
          </p>
        </div>
      </div>
    </div>

    <div class="field is-horizontal">
      <div class="field-label">
        <label class="label" v-if="!grants.length">Grants</label>
      </div>
      <div class="field-body">
        <div class="field is-grouped">
          <div class="control">
            <button class="button" @click="addGrant"><icon name="plus"></icon>&nbsp;Grant</button>
          </div>
          <div class="control">
            <button class="button" @click="openNewGrantModal">Create New Grant</button>
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal">
      <div class="field-label is-normal">
        <label class="label">Other Funding</label>
      </div>
      <div class="field-body">
        <div class="field">
          <div class="control">
            <input class="input" type="text" v-model="funding">
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal">
      <div class="field-label is-normal">
        <label class="label">Collaborators</label>
      </div>
      <div class="field-body">
        <div class="field">
          <div class="control">
            <input class="input" type="text" v-model="collaborators">
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal">
      <div class="field-label is-normal">
        <label class="label">More Information</label>
      </div>
      <div class="field-body">
        <div class="field">
          <div class="control">
            <input class="input" type="text" v-model="moreInformation">
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal item-row" v-for="(p, i) in publications">
      <div class="field-label is-normal">
        <label class="label" v-if="i==0">Publications</label>
      </div>
      <div class="field-body">
        <div class="field is-grouped">
          <p class="select">
            <select v-model="p.publication_id">
              <option v-for="opt in allPublications" v-bind:value="opt.id">{{opt.label}}</option>
            </select>
          </p>&nbsp;&nbsp;&nbsp;
          <p class="control is-expanded">
            <input class="input" type="text" placeholder="Comment" v-model="p.comment">
          </p>
          <p class="control">
            <a class="button is-text" @click="removePublication(i)">
              <icon name="remove"></icon>
            </a>
          </p>
        </div>
      </div>
    </div>

    <div class="field is-horizontal">
      <div class="field-label">
        <label class="label" v-if="!publications.length">Publications</label>
      </div>
      <div class="field-body">
        <div class="field is-grouped">
          <div class="control">
            <button class="button" @click="addPublication"><icon name="plus"></icon>&nbsp;Publication</button>
          </div>
          <div class="control">
            <button class="button" @click="openNewPublicationModal">Create New Publication</button>
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal">
      <div class="field-label is-normal">
        <label class="label">Point of Contact</label>
      </div>
      <div class="field-body">
        <div class="field">
          <div class="control">
            <div class="select">
              <select v-model="pointOfContact">
                <option v-for="opt in contactOptions" v-bind:value="opt.id">{{opt.label}}</option>
              </select>
            </div>
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
          <div class="control">
            <button class="button" @click="openNewFileModal">Create New File</button>
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal">
      <div class="field-label">
        <label class="label">Is Published?</label>
      </div>
      <div class="field-body">
        <div class="field is-narrow">
          <div class="control">
            <label class="radio">
              <input type="radio" value="Yes" v-model="isPublished">
              Yes
            </label>
            <label class="radio">
              <input type="radio" value="No" v-model="isPublished">
              No
            </label>
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
            <button class="button is-link" @click="create">Create</button>
          </div>
          <div class="control">
            <button class="button is-text" @click="reset">Reset</button>
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
  name: 'request-new-program',
  components: {
    Datepicker
  },
  data () {
    return {
      waiting: false,
      error: '',
      success: '',
      allPeople: [],
      allPublications: [],
      allFiles: [],
      allGrants: [],
      title: '',
      description: '',
      people: [],
      status: '',
      country: '',
      countryInput: [],
      state: '',
      stateInput: [],
      focusArea: '',
      focusAreaInput: [],
      startDate: null,
      endDate: null,
      funding: '',
      collaborators: '',
      moreInformation: '',
      publications: [],
      pointOfContact: null,
      website: '',
      files: [],
      grants: [],
      isPublished: 'No'
    }
  },
  computed: {
    thing () {
      return this.$route.params.thing
    },
    key () {
      return this.$route.params.key
    },
    countries () {
      return this.$store.state.table.countries
    },
    states () {
      return this.$store.state.table.states
    },
    contactOptions () {
      var opts = this.allPeople.slice()
      opts.unshift({id: null, label: 'None'})
      return opts
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
      this.$http.get(xHTTPx + '/get_publications').then(response => {
        this.allPublications = response.body.map(function(p){
          return {id: p.id, label: p.title + ' [' + p.id + ']'}
        }).sort(function(a, b){
          return a.label.localeCompare(b.label)
        })
      })
      this.$http.get(xHTTPx + '/get_files').then(response => {
        this.allFiles = response.body.map(function(f){
          return {id: f.id, label: f.name + ' [' + f.id + ']'}
        }).sort(function(a, b){
          return a.label.localeCompare(b.label)
        })
      })
      this.$http.get(xHTTPx + '/get_grants').then(response => {
        this.allGrants = response.body.map(function(g){
          return {id: g.id, label: g.organization + ' [' + g.id + ']'}
        }).sort(function(a, b){
          return a.label.localeCompare(b.label)
        })
      })
    },
    startDateSelected (newDate) {
      this.startDate = newDate
    },
    endDateSelected (newDate) {
      this.endDate = newDate
    },
    addPeople () {
      this.people.push({people_id: (this.allPeople.length ? this.allPeople[0].id : null), role: ''})
    },
    removePeople (idx) {
      this.people.splice(idx, 1)
    },
    addPublication () {
      this.publications.push({publication_id: (this.allPublications.length ? this.allPublications[0].id : null), comment: ''})
    },
    removePublication (idx) {
      this.publications.splice(idx, 1)
    },
    addFile () {
      this.files.push({file_id: (this.allFiles.length ? this.allFiles[0].id : null), comment: ''})
    },
    removeFile (idx) {
      this.files.splice(idx, 1)
    },
    addGrant () {
      this.grants.push({grant_id: (this.allGrants.length ? this.allGrants[0].id : null), comment: ''})
    },
    removeGrant (idx) {
      this.grants.splice(idx, 1)
    },
    create () {
      var message = {
        source: this.thing,
        key: this.key,
        title: this.title,
        description: this.description,
        status: this.status,
        country: this.countryInput.join(', '),
        state: (this.countryInput.length == 1 && this.countryInput[0] == 'United States of America') ? this.stateInput.join(', ') : this.state,
        focusArea: this.focusAreaInput.join(', '),
        startDate: this.startDate == null ? null : Math.floor(this.startDate / 1000),
        endDate: this.endDate == null ? null : Math.floor(this.endDate / 1000),
        funding: this.funding,
        collaborators: this.collaborators,
        moreInformation: this.moreInformation,
        pointOfContact: this.pointOfContact,
        website: this.website,
        isPublished: this.isPublished == 'Yes',
        progress: null,
        progressTime: null,
        people: JSON.stringify(this.people),
        publications: JSON.stringify(this.publications),
        files: JSON.stringify(this.files),
        grants: JSON.stringify(this.grants)
      }
      this.$http.post(xHTTPx + '/new_program_by_requested', message).then(response => {
        var resp = response.body
        this.waiting = false
        this.error = ''
        this.success = 'Program created!'
      }, response => {
        this.error = 'Failed to create program!'
        this.success = ''
        this.waiting = false
      })
    },
    reset () {
      this.title = ''
      this.description = ''
      this.people = []
      this.status = ''
      this.country = ''
      this.countryInput = []
      this.state = ''
      this.focusArea = ''
      this.focusAreaInput = []
      this.startDate = null
      this.endDate = null
      this.funding = ''
      this.collaborators = ''
      this.moreInformation = ''
      this.publications = []
      this.pointOfContact = null
      this.website = ''
      this.files = []
      this.grants = []
      isPublished: 'No'
    },
    descriptionChanged () {
      var el = document.getElementById('textarea-description');
      el.style.height = "1px";
      el.style.height = (25+el.scrollHeight)+"px";
    },
    openNewGrantModal () {
      this.$store.commit('modals/openNewGrantModal', {
        source: this.thing,
        key: this.key,
        callback: { context: this, method: this.requestResources, args: []}
      })
    },
    openNewPublicationModal () {
      this.$store.commit('modals/openNewPublicationModal', {
        source: this.thing,
        key: this.key,
        callback: { context: this, method: this.requestResources, args: []}
      })
    },
    openNewFileModal () {
      this.$store.commit('modals/openNewFileModal', {
        source: this.thing,
        key: this.key,
        callback: { context: this, method: this.requestResources, args: []}
      })
    },
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

.selected-multiple-options {
  margin-top: 0.375em;
  margin-bottom: 0.375em;
}

.clear-country-button {
  height: 25px;
}

</style>
