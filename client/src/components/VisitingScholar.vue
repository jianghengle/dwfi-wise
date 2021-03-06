<template>
  <div>
    <h4 class="title is-4">
      <a class="button back-button" @click="$router.go(-1)">
        <icon name="chevron-left"></icon>
      </a>&nbsp;&nbsp;&nbsp;&nbsp;
      Scholar {{visitingScholarId}}
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
            <input class="input" type="text" v-model="firstName" :disabled="privileges == 'Read Only'">
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
            <input class="input" type="text" v-model="lastName" :disabled="privileges == 'Read Only'">
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal">
      <div class="field-label is-normal">
        <label class="label">Research Topic</label>
      </div>
      <div class="field-body">
        <div class="field">
          <div class="control">
            <input class="input" type="text" v-model="researchTopic" :disabled="privileges == 'Read Only'">
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
            <div class="select is-fullwidth">
              <select v-model="status" :disabled="privileges == 'Read Only'">
                <option>Pending</option>
                <option>In progress</option>
                <option>Completed</option>
                <option>Unknown - refer to point of contact</option>
              </select>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal">
      <div class="field-label is-normal">
        <label class="label">Country</label>
      </div>
      <div class="field-body">
        <div class="field is-narrow">
          <div class="control">
            <div class="select is-fullwidth">
              <select v-model="country" :disabled="privileges == 'Read Only'">
                <option v-for="c in countries">{{c}}</option>
              </select>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal" v-if="country == 'United States of America'">
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

    <div class="field is-horizontal" v-if="country != 'United States of America'">
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
        <label class="label">Program</label>
      </div>
      <div class="field-body">
        <div class="field is-narrow">
          <div class="control">
            <div class="select is-fullwidth">
              <select v-model="programId" :disabled="privileges == 'Read Only'">
                <option v-for="opt in allPrograms" v-bind:value="opt.id">{{opt.label}}</option>
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
          <p class="control" v-if="privileges == 'Edit' || privileges == 'Approve'">
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
            <router-link class="button is-text" :to="'/table/visitingScholars'">Cancel</router-link>
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
  name: 'visiting-scholar',
  components: {
    Datepicker
  },
  data () {
    return {
      waiting: false,
      error: '',
      success: '',
      oldVisitingScholar: null,
      oldPeople: null,
      oldPublications: null,
      oldFiles: null,
      oldGrants: null,
      allPeople: [],
      allPublications: [],
      allFiles: [],
      allGrants: [],
      allPrograms: null,
      firstName: '',
      lastName: '',
      researchTopic: '',
      description: '',
      people: [],
      status: '',
      country: '',
      state: '',
      focusArea: '',
      programId: null,
      focusAreaInput: [],
      startDate: null,
      endDate: null,
      grants: [],
      funding: '',
      collaborators: '',
      moreInformation: '',
      publications: [],
      pointOfContact: null,
      files: [],
      isPublished: 'No',
    }
  },
  computed: {
    privileges () {
      return this.$store.state.user.privileges
    },
    visitingScholarId () {
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
      var visitingScholar = this.collectVisitingScholar()
      if(JSON.stringify(visitingScholar) != JSON.stringify(this.oldVisitingScholar))
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
    collectVisitingScholar () {
      return {
        firstName: this.firstName,
        lastName: this.lastName,
        researchTopic: this.researchTopic,
        description: this.description,
        status: this.status,
        country: this.country,
        state: this.state,
        focusArea: this.focusArea,
        focusArea: this.focusAreaInput.join(', '),
        programId: this.programId,
        startDate: this.startDate,
        endDate: this.endDate,
        funding: this.funding,
        collaborators: this.collaborators,
        moreInformation: this.moreInformation,
        pointOfContact: this.pointOfContact,
        isPublished: this.isPublished
      }
    },
    getVisitingScholar () {
      this.waiting = true
      this.$http.get(xHTTPx + '/get_visiting_scholar/' + this.visitingScholarId).then(response => {
        var resp = response.body
        this.firstName = resp[0].firstName
        this.lastName = resp[0].lastName
        this.researchTopic = resp[0].researchTopic
        this.description = resp[0].description
        this.status = resp[0].status
        this.country = resp[0].country
        this.state = resp[0].state
        this.focusArea = resp[0].focusArea
        this.focusAreaInput = resp[0].focusArea.split(', ')
        this.programId = resp[0].programId
        this.startDate = resp[0].startDate? (new Date(resp[0].startDate*1000)) : null
        this.endDate = resp[0].endDate? (new Date(resp[0].endDate*1000)) : null
        this.funding = resp[0].funding
        this.collaborators = resp[0].collaborators
        this.moreInformation = resp[0].moreInformation
        this.pointOfContact = resp[0].pointOfContact
        this.isPublished = resp[0].isPublished ? "Yes" : "No"
        this.oldVisitingScholar = this.collectVisitingScholar()
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
        this.error = 'Failed to get scholar!'
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
      this.$http.get(xHTTPx + '/get_programs').then(response => {
        this.allPrograms = response.body.map(function(p){
          return {id: p.id, label: p.title + ' [' + p.id + ']'}
        }).sort(function(a, b){
          return a.label.localeCompare(b.label)
        })
        this.allPrograms.unshift({id: null, label: 'None'})
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
        firstName: this.firstName,
        lastName: this.lastName,
        researchTopic: this.researchTopic,
        description: this.description,
        status: this.status,
        country: this.country,
        state: this.state,
        focusArea: this.focusAreaInput.join(', '),
        programId: this.programId,
        startDate: this.startDate == null ? null : Math.floor(this.startDate / 1000),
        endDate: this.endDate == null ? null : Math.floor(this.endDate / 1000),
        funding: this.funding,
        collaborators: this.collaborators,
        moreInformation: this.moreInformation,
        pointOfContact: this.pointOfContact,
        isPublished: this.isPublished == 'Yes',
        people: JSON.stringify(this.changedPeople),
        publications: JSON.stringify(this.changedPublications),
        files: JSON.stringify(this.changedFiles),
        grants: JSON.stringify(this.changedGrants)
      }
      this.$http.post(xHTTPx + '/update_visiting_scholar/' + this.visitingScholarId, message).then(response => {
        var resp = response.body
        this.success = 'Data updated successfully!'
        this.getVisitingScholar()
      }, response => {
        this.error = 'Failed to update scholar!'
        this.waiting = false
      })
    },
    deleteSelf () {
      var confirm = {
        title: 'Delete Scholar',
        message: 'Are you sure to delete the scholar?',
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
      var message = {visitingScholarId: this.visitingScholarId}
      this.$http.post(xHTTPx + '/delete_visiting_scholar', message).then(response => {
        if(response.body.ok){
          this.$router.replace('/table/visiting_scholars')
        }
      }, response => {
        this.error = 'Failed to delete scholar!'
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
    this.getVisitingScholar()
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
</style>
