<template>
  <div>
    <h4 class="title is-4">
      <span class="tag is-info my-title">{{thing}}</span> {{title}}
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

    <div class="field is-horizontal">
      <div class="field-label is-normal">
        <label class="label">Status</label>
      </div>
      <div class="field-body">
        <div class="field is-narrow">
          <div class="control">
            <div class="select is-fullwidth" >
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
              <span class="icon is-small restore-icon" v-if="countryInput.join(', ') != country" @click="countryInput = country ? country.split(', ') : []">
                <icon name="reply"></icon>
              </span>
              <span class="icon is-small restore-icon" v-if="countryInput.join(', ') == country && countryInput.length" @click="countryInput = []">
                <icon name="remove"></icon>
              </span>
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
              <span class="icon is-small restore-icon" v-if="stateInput.join(', ') != state" @click="stateInput = state ? state.split(', ') : []">
                <icon name="reply"></icon>
              </span>
              <span class="icon is-small restore-icon" v-if="stateInput.join(', ') == state && stateInput.length" @click="stateInput = []">
                <icon name="remove"></icon>
              </span>
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
        <label class="label">Start Date</label>
      </div>
      <div class="field-body">
        <div class="field">
          <div class="control">
            <div>
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
            <div>
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
    </div>

    <div class="field is-horizontal item-row" v-for="(g, i) in grants" v-if="g.grant_id">
      <div class="field-label is-normal">
        <label class="label" v-if="i==firstGrant">Grants</label>
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
        <label class="label" v-if="firstGrant >= grants.length">Grants</label>
      </div>
      <div class="field-body">
        <div class="field is-grouped">
          <div class="control">
            <button class="button" @click="addGrant">Add Grant</button>
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

    <div class="field is-horizontal item-row" v-for="(p, i) in publications" v-if="p.publication_id">
      <div class="field-label is-normal">
        <label class="label" v-if="i==firstPublication">Publications</label>
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
        <label class="label" v-if="firstPublication >= publications.length">Publications</label>
      </div>
      <div class="field-body">
        <div class="field is-grouped">
          <div class="control">
            <button class="button" @click="addPublication">Add Publication</button>
          </div>
          <div class="control">
            <button class="button" @click="openNewPublicationModal">Create New Publication</button>
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
            <button class="button" @click="addFile">Add File</button>
          </div>
          <div class="control">
            <button class="button" @click="openNewFileModal">Create New File</button>
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal">
      <div class="field-label is-normal">
        <label class="label">Progress Report</label>
      </div>
      <div class="field-body">
        <div class="field">
          <div class="control">
            <textarea id="textarea-progress" class="textarea" v-model="progress" @change="progressChanged"></textarea>
          </div>
          <p class="help is-info" v-if="progressTime">
            Last updated: {{progressTimeLabel}}
          </p>
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
        </div>
      </div>
    </div>

  </div>
</template>

<script>
import DateForm from 'dateformat'
import Datepicker from 'vuejs-datepicker'

export default {
  name: 'requested',
  components: {
    Datepicker
  },
  data () {
    return {
      waiting: false,
      error: '',
      success: '',
      oldThing: null,
      oldPublications: null,
      oldFiles: null,
      oldGrants: null,
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
      startDate: null,
      endDate: null,
      grants: [],
      funding: '',
      collaborators: '',
      website: '',
      publications: [],
      files: [],
      progress: '',
      progressTime: null
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
      var thing = this.collectThing()
      if(JSON.stringify(thing) != JSON.stringify(this.oldThing))
        return true
      if(JSON.stringify(this.publications) != JSON.stringify(this.oldPublications))
        return true
      if(JSON.stringify(this.files) != JSON.stringify(this.oldFiles))
        return true
      if(JSON.stringify(this.grants) != JSON.stringify(this.oldGrants))
        return true
      return false
    },
    changedPublications () {
      var changed = []
      if(!this.oldPublications){
        return changed
      }
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
      if(!this.oldFiles){
        return changed
      }
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
      if(!this.oldGrants){
        return changed
      }
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
    progressTimeLabel () {
      return this.progressTime? DateForm(this.progressTime, 'mmm dd yyyy h:MM TT') : ''
    },
  },
  methods: {
    collectThing () {
      return {
        title: this.title,
        description: this.description,
        status: this.status,
        country: this.countryInput.join(', '),
        state: (this.countryInput.length == 1 && this.countryInput[0] == 'United States of America') ? this.stateInput.join(', ') : this.state,
        startDate: this.startDate,
        endDate: this.endDate,
        funding: this.funding,
        collaborators: this.collaborators,
        website: this.website,
        progress: this.progress,
        progressTime: this.progressTime
      }
    },
    getThing () {
      this.waiting = true
      this.$http.get(xHTTPx + '/get_requested_' + this.thing + '/' + this.key).then(response => {
        var resp = response.body
        this.title = resp[0].title
        this.description = resp[0].description
        this.status = resp[0].status
        this.country = resp[0].country ? resp[0].country : ''
        this.countryInput = this.country ? this.country.split(', ') : []
        this.state = resp[0].state
        this.stateInput = this.state ? this.state.split(', ') : []
        this.startDate = resp[0].startDate? (new Date(resp[0].startDate*1000)) : null
        this.endDate = resp[0].endDate? (new Date(resp[0].endDate*1000)) : null
        this.funding = resp[0].funding
        this.collaborators = resp[0].collaborators
        this.website = resp[0].website
        this.progress = resp[0].progress
        this.progressTime = resp[0].progressTime? (new Date(resp[0].progressTime*1000)) : null
        this.oldThing = this.collectThing()
        this.publications = resp[1].map(function(p){
          return {id: p.id, publication_id: p.publicationId, comment: p.comment}
        })
        this.oldPublications = JSON.parse(JSON.stringify(this.publications))
        this.files = resp[2].map(function(f){
          return {id: f.id, file_id: f.fileId, comment: f.comment}
        })
        this.oldFiles = JSON.parse(JSON.stringify(this.files))
        this.grants = resp[3].map(function(g){
          return {id: g.id, grant_id: g.grantId, comment: g.comment}
        })
        this.oldGrants = JSON.parse(JSON.stringify(this.grants))
        this.waiting = false
        this.error = ''
        this.$nextTick(() => {
          this.descriptionChanged()
          this.progressChanged()
        })
      }, response => {
        this.error = 'Failed to get thing!'
        this.waiting = false
      })
    },
    requestResources () {
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
        description: this.description,
        status: this.status,
        country: this.countryInput.join(', '),
        state: (this.countryInput.length == 1 && this.countryInput[0] == 'United States of America') ? this.stateInput.join(', ') : this.state,
        startDate: this.startDate == null ? null : Math.floor(this.startDate / 1000),
        endDate: this.endDate == null ? null : Math.floor(this.endDate / 1000),
        funding: this.funding,
        collaborators: this.collaborators,
        website: this.website,
        progress: this.progress,
        publications: JSON.stringify(this.changedPublications),
        files: JSON.stringify(this.changedFiles),
        grants: JSON.stringify(this.changedGrants)
      }
      this.$http.post(xHTTPx + '/update_requested_' + this.thing + '/' + this.key, message).then(response => {
        var resp = response.body
        this.success = 'Data updated successfully!'
        this.getThing()
      }, response => {
        this.error = 'Failed to update thing!'
        this.waiting = false
      })
    },
    descriptionChanged () {
      var el = document.getElementById('textarea-description');
      el.style.height = "1px";
      el.style.height = (25+el.scrollHeight)+"px";
    },
    progressChanged () {
      var el = document.getElementById('textarea-progress');
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
    this.getThing()
    this.requestResources()
  }
}
</script>

<style lang="scss" scoped>
.my-title {
  text-transform: capitalize;
}

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
