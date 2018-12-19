<template>
  <div>
    <h4 class="title is-4">
      <a class="button back-button" @click="$router.go(-1)">
        <icon name="chevron-left"></icon>
      </a>&nbsp;&nbsp;&nbsp;&nbsp;
      Program {{programId}}
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
        <label class="label">Title</label>
      </div>
      <div class="field-body">
        <div class="field">
          <div class="control">
            <input class="input" type="text" v-model="title" :disabled="privileges == 'Read Only'">
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
            <textarea id="textarea-description" class="textarea" v-model="description" @change="descriptionChanged" :disabled="privileges == 'Read Only'"></textarea>
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal item-row" v-for="(p, i) in people" v-if="p.people_id">
      <div class="field-label is-normal">
        <label class="label" v-if="i==firstPeople">People</label>
      </div>
      <div class="field-body">
        <div class="field is-grouped">
          <p class="select">
            <select v-model="p.people_id" :disabled="privileges == 'Read Only'">
              <option v-for="opt in allPeople" v-bind:value="opt.id">{{opt.label}}</option>
            </select>
          </p>&nbsp;&nbsp;&nbsp;
          <p class="control is-expanded">
            <input class="input" type="text" placeholder="Role" v-model="p.role" :disabled="privileges == 'Read Only'">
          </p>
          <p class="control" v-if="privileges == 'Edit' || privileges == 'Approve'">
            <a class="button is-text" @click="removePeople(i)">
              <icon name="remove"></icon>
            </a>
          </p>
        </div>
      </div>
    </div>

    <div class="field is-horizontal" v-if="privileges == 'Edit' || privileges == 'Approve'">
      <div class="field-label">
        <label class="label" v-if="firstPeople >= people.length">People</label>
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
            <div class="select is-fullwidth" >
              <select v-model="status" :disabled="privileges == 'Read Only'">
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
              <span class="icon is-small restore-icon" v-if="countryInput.join(', ') != country" @click="countryInput = country.split(', ')">
                <icon name="reply"></icon>
              </span>
            </div>
            <div class="select is-multiple" v-if="privileges == 'Edit' || privileges == 'Approve'">
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
            <div class="select">
              <select v-model="state" :disabled="privileges == 'Read Only'">
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
            <input class="input" type="text" v-model="state" :disabled="privileges == 'Read Only'">
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
              <span class="icon is-small restore-icon" v-if="focusAreaInput.join(', ') != focusArea" @click="focusAreaInput = focusArea.split(', ')">
                <icon name="reply"></icon>
              </span>
            </div>
            <div class="select is-multiple is-fullwidth">
              <select multiple v-model="focusAreaInput" size="7" :disabled="privileges == 'Read Only'">
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
            <div v-if="privileges == 'Edit' || privileges == 'Approve'">
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
            <div v-if="privileges == 'Read Only'">
              <input class="input" type="text" :value="startDateLabel" :disabled="privileges == 'Read Only'">
            </div>
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
            <div v-if="privileges == 'Edit' || privileges == 'Approve'">
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
            <div v-if="privileges == 'Read Only'">
              <input class="input" type="text" :value="endDateLabel" :disabled="privileges == 'Read Only'">
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal item-row" v-for="(g, i) in grants" v-if="g.grant_id">
      <div class="field-label is-normal">
        <label class="label" v-if="i==firstGrant">Grants</label>
      </div>
      <div class="field-body">
        <div class="field is-grouped">
          <p class="select">
            <select v-model="g.grant_id" :disabled="privileges == 'Read Only'">
              <option v-for="opt in allGrants" v-bind:value="opt.id">{{opt.label}}</option>
            </select>
          </p>&nbsp;&nbsp;&nbsp;
          <p class="control is-expanded">
            <input class="input" type="text" placeholder="Comment" v-model="g.comment" :disabled="privileges == 'Read Only'">
          </p>
          <p class="control" v-if="privileges == 'Edit' || privileges == 'Approve'">
            <a class="button is-text" @click="removeGrant(i)">
              <icon name="remove"></icon>
            </a>
          </p>
        </div>
      </div>
    </div>

    <div class="field is-horizontal" v-if="privileges == 'Edit' || privileges == 'Approve'">
      <div class="field-label">
        <label class="label" v-if="firstGrant >= grants.length">Grants</label>
      </div>
      <div class="field-body">
        <div class="field is-grouped">
          <div class="control">
            <button class="button" @click="addGrant"><icon name="plus"></icon>&nbsp;Grant</button>
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
            <input class="input" type="text" v-model="funding" :disabled="privileges == 'Read Only'">
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
            <input class="input" type="text" v-model="collaborators" :disabled="privileges == 'Read Only'">
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
            <input class="input" type="text" v-model="moreInformation" :disabled="privileges == 'Read Only'">
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal item-row" v-for="(p, i) in publications" v-if="p.publication_id">
      <div class="field-label is-normal">
        <label class="label" v-if="i==firstPublication">Publications</label>
      </div>
      <div class="field-body">
        <div class="field is-grouped">
          <p class="select">
            <select v-model="p.publication_id" :disabled="privileges == 'Read Only'">
              <option v-for="opt in allPublications" v-bind:value="opt.id">{{opt.label}}</option>
            </select>
          </p>&nbsp;&nbsp;&nbsp;
          <p class="control is-expanded">
            <input class="input" type="text" placeholder="Comment" v-model="p.comment" :disabled="privileges == 'Read Only'">
          </p>
          <p class="control"  v-if="privileges == 'Edit' || privileges == 'Approve'">
            <a class="button is-text" @click="removePublication(i)">
              <icon name="remove"></icon>
            </a>
          </p>
        </div>
      </div>
    </div>

    <div class="field is-horizontal" v-if="privileges == 'Edit' || privileges == 'Approve'">
      <div class="field-label">
        <label class="label" v-if="firstPublication >= publications.length">Publications</label>
      </div>
      <div class="field-body">
        <div class="field is-grouped">
          <div class="control">
            <button class="button" @click="addPublication"><icon name="plus"></icon>&nbsp;Publication</button>
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
              <select v-model="pointOfContact" :disabled="privileges == 'Read Only'">
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
            <input class="input" type="text" v-model="website" :disabled="privileges == 'Read Only'">
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
            <select v-model="f.file_id" :disabled="privileges == 'Read Only'">
              <option v-for="opt in allFiles" v-bind:value="opt.id">{{opt.label}}</option>
            </select>
          </p>&nbsp;&nbsp;&nbsp;
          <p class="control is-expanded">
            <input class="input" type="text" placeholder="Comment" v-model="f.comment" :disabled="privileges == 'Read Only'">
          </p>
          <p class="control" v-if="privileges == 'Edit' || privileges == 'Approve'">
            <a class="button is-text" @click="removeFile(i)">
              <icon name="remove"></icon>
            </a>
          </p>
        </div>
      </div>
    </div>

    <div class="field is-horizontal" v-if="privileges == 'Edit' || privileges == 'Approve'">
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

    <div class="field is-horizontal">
      <div class="field-label">
        <label class="label">Is Published?</label>
      </div>
      <div class="field-body">
        <div class="field is-narrow">
          <div class="control">
            <label class="radio">
              <input type="radio" value="Yes" v-model="isPublished" :disabled="privileges == 'Read Only'">
              Yes
            </label>
            <label class="radio">
              <input type="radio" value="No" v-model="isPublished" :disabled="privileges == 'Read Only'">
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
            <router-link class="button is-text" :to="'/table/programs'">Cancel</router-link>
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
  name: 'program',
  components: {
    Datepicker
  },
  data () {
    return {
      waiting: false,
      error: '',
      success: '',
      oldProgram: null,
      oldPeople: null,
      oldPublications: null,
      oldFiles: null,
      oldGrants: null,
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
      focusArea: '',
      focusAreaInput: [],
      startDate: null,
      endDate: null,
      grants: [],
      funding: '',
      collaborators: '',
      moreInformation: '',
      publications: [],
      pointOfContact: null,
      website: '',
      files: [],
      isPublished: 'No',
    }
  },
  computed: {
    privileges () {
      return this.$store.state.user.privileges
    },
    programId () {
      return this.$route.params.id
    },
    countries () {
      return this.$store.state.table.countries
    },
    states () {
      return this.$store.state.table.states
    },
    firstPeople () {
      var i = 0
      while(i < this.people.length && (!this.people[i].people_id))
        i++
      return i
    },
    firstPublication () {
      var i = 0
      while(i < this.publications.length && (!this.publications[i].publication_id))
        i++
      return i
    },
    firstFile () {
      var i = 0
      while(i < this.files.length && (!this.files[i].file_id))
        i++
      return i
    },
    firstGrant () {
      var i = 0
      while(i < this.grants.length && (!this.grants[i].grant_id))
        i++
      return i
    },
    changed () {
      var program = this.collectProgram()
      if(JSON.stringify(program) != JSON.stringify(this.oldProgram))
        return true
      if(JSON.stringify(this.people) != JSON.stringify(this.oldPeople))
        return true
      if(JSON.stringify(this.publications) != JSON.stringify(this.oldPublications))
        return true
      if(JSON.stringify(this.files) != JSON.stringify(this.oldFiles))
        return true
      if(JSON.stringify(this.grants) != JSON.stringify(this.oldGrants))
        return true
      return false
    },
    changedPeople () {
      var changed = []
      for(var i=0;i<this.people.length;i++){
        var p = this.people[i]
        if(!p.people_id){
          changed.push(p)
        }else if(p.id){
          var old = this.oldPeople[i]
          if(p.people_id != old.people_id || p.role != old.role){
            changed.push(p)
          }
        }else{
          changed.push(p)
        }
      }
      return changed
    },
    changedPublications () {
      var changed = []
      for(var i=0;i<this.publications.length;i++){
        var p = this.publications[i]
        if(!p.publication_id){
          changed.push(p)
        }else if(p.id){
          var old = this.oldPublications[i]
          if(p.publication_id != old.publication_id || p.comment != old.comment){
            changed.push(p)
          }
        }else{
          changed.push(p)
        }
      }
      return changed
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
    },
    changedGrants () {
      var changed = []
      for(var i=0;i<this.grants.length;i++){
        var g = this.grants[i]
        if(!g.grant_id){
          changed.push(g)
        }else if(g.id){
          var old = this.oldGrants[i]
          if(g.grant_id != old.grant_id || g.comment != old.comment){
            changed.push(g)
          }
        }else{
          changed.push(g)
        }
      }
      return changed
    },
    startDateLabel () {
      return this.startDate? DateForm(this.startDate, 'mmm dd yyyy') : ''
    },
    endDateLabel () {
      return this.endDate? DateForm(this.endDate, 'mmm dd yyyy') : ''
    },
    contactOptions () {
      var opts = this.allPeople.slice()
      opts.unshift({id: null, label: 'None'})
      return opts
    }
  },
  methods: {
    collectProgram () {
      return {
        title: this.title,
        description: this.description,
        status: this.status,
        country: this.countryInput.join(', '),
        state: this.state,
        focusArea: this.focusAreaInput.join(', '),
        startDate: this.startDate,
        endDate: this.endDate,
        funding: this.funding,
        collaborators: this.collaborators,
        moreInformation: this.moreInformation,
        pointOfContact: this.pointOfContact,
        website: this.website,
        isPublished: this.isPublished
      }
    },
    getProgram () {
      this.waiting = true
      this.$http.get(xHTTPx + '/get_program/' + this.programId).then(response => {
        var resp = response.body
        this.title = resp[0].title
        this.description = resp[0].description
        this.status = resp[0].status
        this.country = resp[0].country
        this.countryInput = resp[0].country.split(', ')
        this.state = resp[0].state
        this.focusArea = resp[0].focusArea
        this.focusAreaInput = resp[0].focusArea.split(', ')
        this.startDate = resp[0].startDate? (new Date(resp[0].startDate*1000)) : null
        this.endDate = resp[0].endDate? (new Date(resp[0].endDate*1000)) : null
        this.funding = resp[0].funding
        this.collaborators = resp[0].collaborators
        this.moreInformation = resp[0].moreInformation
        this.pointOfContact = resp[0].pointOfContact
        this.website = resp[0].website
        this.isPublished = resp[0].isPublished ? "Yes" : "No"
        this.oldProgram = this.collectProgram()
        this.people = resp[1].map(function(p){
          return {id: p.id, people_id: p.peopleId, role: p.role}
        })
        this.oldPeople = JSON.parse(JSON.stringify(this.people))
        this.publications = resp[2].map(function(p){
          return {id: p.id, publication_id: p.publicationId, comment: p.comment}
        })
        this.oldPublications = JSON.parse(JSON.stringify(this.publications))
        this.files = resp[3].map(function(f){
          return {id: f.id, file_id: f.fileId, comment: f.comment}
        })
        this.oldFiles = JSON.parse(JSON.stringify(this.files))
        this.grants = resp[4].map(function(g){
          return {id: g.id, grant_id: g.grantId, comment: g.comment}
        })
        this.oldGrants = JSON.parse(JSON.stringify(this.grants))
        this.waiting = false
        this.error = ''
        this.$nextTick(() => {
          this.descriptionChanged()
        })
      }, response => {
        this.error = 'Failed to get program!'
        this.waiting = false
      })
    },
    requestResources () {
      this.$http.get(xHTTPx + '/get_people').then(response => {
        this.allPeople = response.body.map(function(p){
          return {id: p.id, label: p.firstName + ' ' + p.lastName + ' [' + p.id + ']'}
        })
      })
      this.$http.get(xHTTPx + '/get_publications').then(response => {
        this.allPublications = response.body.map(function(p){
          return {id: p.id, label: p.title + ' [' + p.id + ']'}
        })
      })
      this.$http.get(xHTTPx + '/get_files').then(response => {
        this.allFiles = response.body.map(function(f){
          return {id: f.id, label: f.name + ' [' + f.id + ']'}
        })
      })
      this.$http.get(xHTTPx + '/get_grants').then(response => {
        this.allGrants = response.body.map(function(g){
          return {id: g.id, label: g.organization + ' [' + g.id + ']'}
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
      if(this.allPeople.length){
        this.people.push({people_id: this.allPeople[0].id, role: ''})
      }
    },
    removePeople (idx) {
      if(this.people[idx].id){
        this.people[idx].people_id = null
      }else{
        this.people.splice(idx, 1)
      }
    },
    addPublication () {
      if(this.allPublications.length){
        this.publications.push({publication_id: this.allPublications[0].id, comment: ''})
      }
    },
    removePublication (idx) {
      if(this.publications[idx].id){
        this.publications[idx].publication_id = null
      }else{
        this.publications.splice(idx, 1)
      }
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
    addGrant () {
      if(this.allGrants.length){
        this.grants.push({grant_id: this.allGrants[0].id, comment: ''})
      }
    },
    removeGrant (idx) {
      if(this.grants[idx].id){
        this.grants[idx].grant_id = null
      }else{
        this.grants.splice(idx, 1)
      }
    },
    update () {
      var message = {
        title: this.title,
        description: this.description,
        status: this.status,
        country: this.countryInput.join(', '),
        state: this.state,
        focusArea: this.focusAreaInput.join(', '),
        startDate: this.startDate == null ? null : Math.floor(this.startDate / 1000),
        endDate: this.endDate == null ? null : Math.floor(this.endDate / 1000),
        funding: this.funding,
        collaborators: this.collaborators,
        moreInformation: this.moreInformation,
        pointOfContact: this.pointOfContact,
        website: this.website,
        isPublished: this.isPublished == 'Yes',
        people: JSON.stringify(this.changedPeople),
        publications: JSON.stringify(this.changedPublications),
        files: JSON.stringify(this.changedFiles),
        grants: JSON.stringify(this.changedGrants)
      }
      this.$http.post(xHTTPx + '/update_program/' + this.programId, message).then(response => {
        var resp = response.body
        this.success = 'Data updated successfully!'
        this.getProgram()
      }, response => {
        this.error = 'Failed to update program!'
        this.waiting = false
      })
    },
    deleteSelf () {
      var confirm = {
        title: 'Delete Program',
        message: 'Are you sure to delete the program?',
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
      var message = {programId: this.programId}
      this.$http.post(xHTTPx + '/delete_program', message).then(response => {
        if(response.body.ok){
          this.$router.replace('/table/programs')
        }
      }, response => {
        this.error = 'Failed to delete program!'
        this.waiting = false
      })
    },
    descriptionChanged () {
      var el = document.getElementById('textarea-description');
      el.style.height = "1px";
      el.style.height = (25+el.scrollHeight)+"px";
    }
  },
  mounted () {
    this.getProgram()
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

.restore-icon {
  cursor: pointer;
  position: relative;
  top: 2px;
  left: 5px;
}
</style>
